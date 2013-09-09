

function dayscore = behav_input_day_read(readfile)

% dayscore = behav_input_day_read('Jigsaw_behav_input');


%[behd,varnames,casenames] = tblread('Eliot_01-1');
%[behd,varnames,casenames] = tblread('Jigsaw_behav_input');
[behd,varnames,casenames] = tblread(readfile);

% define data columns
day = 1; % training day of trial
run = 2; % training session within day of trial
isinb = 3; % trial is inbound
isret = 4; % trial is return error
iscor = 5; % trial is correct
inb = 6;  % inbound choices excluding return errors
outb = 7;
all = 8;
inbr = 9;  % inbound choices with return errors
outbr = 10;
allr = 11;


days = find(diff(behd(:,1)));
if length(days)+1 <7
    numdays = length(days)+1;
else
    numdays = 7;
end
behday = cell(numdays,1);

behday{1} = behd(1:days(1),:);
for d = 1:6
    if length(days)< d+1
        behday{d+1} = behd(days(d)+1:end,:);
        warning(['only ' num2str(d+1) ' days of data']);
        break;
    else
        behday{d+1} = behd(days(d)+1:days(d+1),:);
    end
end

%dayscore = behday;

%{
if length(days)<7
behd(days(6)+1:end,:);
else
    behd(days(6)+1:days(7),:)
for task = 1:6
    bp{task+5}
dayscore(day)(task)
%}

bp = cell(numdays,1);
for d = 1:numdays
    % eliminate the NaN blanks from the trial lists of subsets of trials (all
    % except allr=11)
    for i = 6:10
        M = behday{d}(:,i);
        M(any(isnan(M),2),:)=[];
        % M(isfinite(M(:, 1)), :);  % alternative code to do the same as line above
        bp{d}{i} = M;
        dayscore(d,i-5) = sum(bp{d}{i})/size(bp{d}{i},1);
    end
        % all inbound and outbound with return errors
    bp{d}{allr} = behday{d}(:,allr);
    dayscore(d,6) = sum(bp{d}{allr})/size(bp{d}{allr},1);
end

%dayscore = bp; %dayscore{day}{task}


% run for all inbound and outbound with return errors
% [pc, lt] = getestprobcorrect(bp{allr}, background_prob, startflag, conf);

% run for all inbound and outbound without returns errors
%[pc, lt] = getestprobcorrect(bp{all}, background_prob, startflag, conf);

% run for all inbound without returns errors
%[pc, lt] = getestprobcorrect(bp{inb}, background_prob, startflag, conf);
%title([readfile '  INBOUND']);

% run for all outbound without returns errors
%[pc, lt] = getestprobcorrect(bp{outb}, background_prob, startflag, conf);
%title([readfile '  OUTBOUND']);