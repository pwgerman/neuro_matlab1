% version from 4 Oct 2012

% run start (t1) and end times (t2) in format [h m s]
% chan is a matrix of five values corresponding to the dio channels 
% with the [air_on, air_off, side1_photogate, middle_photogate, side2_photogate]
% for Eliot, these are [9,10,21,22,23]

function out = dioProcess2(filename, t1, t2, outputfile, day, run, chan)

TIMESTAMPRATE = 10000;

% file dio from: function stimdio = createstimstruct(varargin)
fid = fopen(filename,'r');
dio = textscan(fid,'%f %s');
fclose(fid);
diotimes = dio{1};
diosecs = diotimes(:)/TIMESTAMPRATE;  % dio timestamps in seconds
tstart = hms2sec(t1);
tend = hms2sec(t2);
[C1, Istart] = min(abs(diosecs-tstart));
[C1, Iend] = min(abs(diosecs-tend));

% timestamps are handled differently in DataFilter using the
% timestampToString function in modifyTimes.m
% Nsec = datenum([0 0 0 0 0 1]);
%V = datevec(datenum([zeros(size(diotimes, 1),5) diotimes(:)/TIMESTAMPRATE]));
% Vn = datenum([zeros(size(diotimes, 1),5) diosecs);
% tS = datestr(Nsec*diotimes(:)/TIMESTAMPRATE, 'HH:MM:SS.FFF');
% t1n = datenum([0 0 0 t1]);
%t1n = datenum([0 0 0 t1]);
% [C1, I1] = min(abs(Vn-t1n));
% t2n = datenum([0 0 0 t2]);
% [C2, I2] = min(abs(Vn-t2n));
%tS1 = tS(I1:I2, :);

diovals = double(str2mat(dio{2})) - str2mat('0');
% correct a bug in the DIO text output - reverse each 16 bit frame
diovals = diovals(:,[[16:-1:1] [32:-1:17] [48:-1:33] [64:-1:49]]);

%chan = [9,10,21,22,23];
taskvals = diovals(Istart:Iend,chan);  % add the timestamp with V

% below is algorithm for determining that a reward (air off) was given
% line of code calculates entire reward column simultaneously with matrix
% commands.
% formula for each line(time) states reward(=true) if 3 conditions are met:
% 1) dio11(air off) == 1
% 2) dio11 at t-1 == 0    this eliminates multiple counts if photobeam
% broken during the time dio11 is active (100ms)
% 3) dio12 at t-1 == 0     this eliminates most air warning sequences (on
% off on rapidly (total duration 300ms)


% The reward value is equal to the taskval of reward (air on) as long as
% the previous timestamp was not also air on or air off. (these occur as
% erros occasionally)
reward = taskvals(:,1) == 1 & [1; taskvals(1:end-1,1)] == 0 & [1; taskvals(1:end-1,2)] == 0;

% excel fromula =IF(  AND(  OR((N776=1),(I777=1)),  (K777=0),(J777=0)),   1,0) 

goal = zeros(length(taskvals), 7); % reward, diosecs, goal1, goal2, goal3, attempt, error
goal(:, 1:5) = taskvals; %
% ****
% replace index column 2 with timestamps because index repeated in case names.  Also move
% reward to after attempt column and before error.  Line above necessary?
goal(:,1) = reward;
goal(:,2) = diosecs(Istart:Iend);
% goal(1,2) = 1;  % index
goal(:,8) = diotimes(Istart:Iend, :);  % dio timestamp for later calculations
goal(:,9) = day;
goal(:,10) = run;
%length(tS1)
%length(goal)
% casenames = {num2str(1)};
trigger = sum(goal(:,[1 3:5]),2); % reward or photogate event

trig = goal;
trig(trigger==0,:)=[]; % eliminate rows with no meaningful events

diff_goal = diff(trig(:,[1 3:5])); % eliminate repeated triggers of photogates
diff_goal = [trig(1,[1 3:5]); diff_goal]; % realine with index by adding first row back

trig(:,[1,3:5]) = diff_goal; % reinsert into larger matrix
trigger = any(trig(:,[1 3:5])==1, 2); % non-repeated photogate event or air off

trig(trigger==0,:)=[]; % eliminate rows with no meaningful events again


%%%%%%%%%%%%%%%%%%%
% I stopped editing code here to just enter in the numbers by hand.  But
% I'd like time stamps with the events to use for physiology later.  But
% that will come with the position reconstruction.  So take it up again
% later.  2 Oct 2012  Walter German


for i = 2:length(taskvals)
    goal(i,3) = or(taskvals(i,3)==1, goal(i-1, 3)==1) & taskvals(i,4)==0 & taskvals(i,5)==0; % arm1 if not arm2 or 3 and currently or previousy in 1
    goal(i,4) = or(taskvals(i,4)==1, goal(i-1, 4)==1) & taskvals(i,3)==0 & taskvals(i,5)==0; % arm2 if not arm1 or 3 and currently or previousy in 2
    goal(i,5) = or(taskvals(i,5)==1, goal(i-1, 5)==1) & taskvals(i,4)==0 & taskvals(i,3)==0; % arm3 if not arm1 or 2 and currently or previousy in 3
    % the current arm is taken for either the epoch or goal matrix because
    % goal generates a continuous record of occupancy, no zeros even when
    % no beam is being broken.
    goal(i,2) = i;  % index for sorting
    % casenames = {casenames{:} num2str(i)};
end
% calculate 'attempt' whenever arm occupied changes 
goal(4:end, 6) = sum(abs(goal(3:end-1, 3:5)-goal(2:end-2, 3:5)), 2)/2;
% error = attempt - reward (skip first two because can't see prior movement
% for attempt)
goal(3:end,7) = goal(3:end,6)-goal(3:end,1);  
% eliminate the errors that result from reward occuring an extra timestamp
% after arm change
% goal(3:end-1,7) = ~(or((goal(3:end-1,7)+goal(2:end-2,7)) == 0, (goal(4:end,7)+goal(3:end-1,7)) == 0 ));
rewardShift = goal(:,7) == -1; % identify shifted rewards by error = -1
goal(1:end-1,1) = or(rewardShift(2:end)==1, goal(1:end-1,1)==1); % add reward above each shifted reward
goal(:,1) = goal(:,1)==1 & ~rewardShift(:); % remove shifted reward
goal(1:end-1,7) = goal(1:end-1,7)==1 & rewardShift(2:end)~=1; % remove shifted error
goal(:,6) = or(goal(:,6) , goal(:,1)); % add attempt to beginning of trial when rewarded
%goal(:,1) = goal(:,1)+goal(:,7);
%goal(:,7) = goal(:,1)+goal(:,7);
% goal(2:end,11) = goal(1:end-1,6); % if previously in middle, current trial is outbound

%accuracy = (sum(goal(:,6)) - sum(goal(:,7)))/sum(goal(:,6));
% out = reward;
out = goal;

% code below is for saving these matrices to outputfile
% varnames = {'reward'; 'index'; 'goal1'; 'goal2'; 'goal3'; 'attempt'; 'error'; 'dioTimeStamp'; 'day'; 'run'};
% tblwrite(goal, varnames, tS1, outputfile);  % use tS1 for casenames
%
% write out to files epoch1 and goal
% out = [sum(goal(:,1)) sum(goal(:,6)) sum(goal(:,7)) accuracy];
% out = casenames;

