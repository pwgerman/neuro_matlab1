% script for stress project extractripples

% add animal directories to matlab path
% add to ~/Documents/MATLAB/startup.m
addpath /usr/local/filtering
addpath /home/walter/src/matlab/wltr
addpath /home/walter/src/matlab/wltr/data_preprocess


% what happens if tetrodes is more than 1 ???
tetrodes = -1; % specify all tetrodes with -1
mindur = 0.015; % 15 ms minimum duration
nstd = 2; % 2 std

% recalculate the other strings if daynum is changed
daynum = 1;
name= 'Cummings';  %'Dickinson';
nameprefix = 'Cum';  % 'Dic'
datadir='/data18/walter/stress/';
rawdir=[datadir,'Cummings/'];  % raw data directory path of animal {'Cummings/' 'Dickinson/'}
daydir=[rawdir, name,'_', leadzero(1,daynum)];  % raw data directory path of animal on day x
prodir=[datadir, nameprefix];  % processed data directory path of animal

% dayprocess currently has bug related to incorrect time stamps, possibly
% from nspike_extract code bug.  If it crashes before finishing, just
% delete the files for the last tetrode, which may be too short.  The
% ripple detection doesn't require all tetrodes, so as long as incomplete
% files are erased, the rest of the steps can procede to extract ripples.
dayprocess(daydir, prodir, nameprefix, daynum, 'cmperpix', 0.64, 'diodepos', 1);

% automate for multiple variables OR use processdays() function that
% already does this!!!
% eval(['cd ',rawdir]);
% eval(['dayprocess(',daydir,', ',prodir.', ',fileprefix,', ',daynum,', cmperpix, ', 'cmperpix,  'diodepos, 1)']);

% usr/local/filtering/rippledayprocess.m
% OUTPUT: to create file like: Dicripple02-3-02.mat
% naming is Animal_ripple_day-epoch-tetrode.mat
% in directory basedir/Ani/EEG/
rippledayprocess(prodir,nameprefix, daynum);

% to get just the position day process after crashing during eeg stopped
% day process short.
dayprocess(daydir, prodir, nameprefix, daynum, 'cmperpix', 0.64, 'diodepos', 1, 'processeeg', 0);

% post processing of ripple data
% the /usr/local/filtering/extractripples.m version of extractripples has
% typos in the code.  Until discuss with Loren, use the version 
% /home/walter/src/matlab/wltr/w_extractripples.m
w_extractripples(prodir, nameprefix, daynum, tetrodes, mindur, nstd);

% buggy version on usr/local/filtering
% extractripples(prodir, nameprefix, daynum, tetrodes, mindur, nstd);

cd(prodir);
% change the number to the correct day (here and for somn{epoch}...)







%%%% load ripple files %%%%%%%%%%%%
%dic_rip_02=load('Dicripples02.mat');
% filename = 'Dicripples02.mat';
%daynum = 2;
%filename = ['Dicripples0' num2str(daynum) '.mat'];
%varname = ['dic_rip_0' num2str(daynum)];
%s = [varname '=load(filename)']
%eval(s)

aniname = 'cum';

ripplename = [aniname '.ripples'];
eval([ripplename ' = cell(1,8);']);  % dic.ripples = cell(1,8);
tempname = 'temp';

days = [1 2];  % [1 2]
for daynum = days;    
    filename = [nameprefix 'ripples0' num2str(daynum) '.mat'];
    varname = [ripplename '{' num2str(daynum) '}'];
    movename = [tempname '.ripples{' num2str(daynum) '}'];
    s = [tempname '=load(filename);'];
    eval(s);
    move = [varname '=' movename ';'];
    eval(move);    
end

% graph something %   
    
%{
for epoch = 1:8
somn{epoch}=dic_rip_02.ripples{daynum}{epoch}{1}.startind;
end
figure;
plot(somn{1},1:length(somn{1}));
hold on
plot(somn{2},1:length(somn{2}),'r');
plot(somn{3},1:length(somn{3}),'m');
plot(somn{4},1:length(somn{4}),'c');
title('dic_02 ripples b,r,m,c');
%}

daynum = 2;
for epoch = 1:8
    eval(['somn{epoch}=' ripplename '{daynum}{epoch}{1}.startind;']);
end

% plot first 4 epochs as different colors 
figure;
plot(somn{1},1:length(somn{1}));
hold on
plot(somn{2},1:length(somn{2}),'r');
plot(somn{3},1:length(somn{3}),'m');
plot(somn{4},1:length(somn{4}),'c');
title(['all tetrodes' ripplename ' ' num2str(daynum) ' b,r,m,c']);
xlabel('time (s/1500)');
ylabel('ripple events');

