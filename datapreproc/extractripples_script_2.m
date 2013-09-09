% script for extractripples

tetrodes = -1; % specify all tetrodes with -1
mindur = 0.015; % 15 ms minimum duration
nstd = 2; % 2 std


%{
days = [1:4];
name=   'Dickinson'; %'Eliot';
nameprefix = 'Dic'; 
datadir=  %'/data18/walter/stress/';
rawdir=[datadir,'Cummings/'];  % raw data directory path of animal {'Cummings/' 'Dickinson/'}
daydir=[rawdir, name,'_', leadzero(1,daynum)];  % raw data directory path of animal on day x
%prodir=[datadir, nameprefix];  % processed data directory path of animal
prodir ='/mnt/backup/walter/walter/phys/Dic';
%}


% rippledayprocess('/data18/walter/stress/Eli/', 'Eli', 3);

% usr/local/filtering/rippledayprocess.m
% OUTPUT: to create file like: Eli/EEG/ripple02-3-02.mat
% naming is Animal_ripple_day-epoch-tetrode.mat
% in directory basedir/Ani/EEG/
% rippledayprocess(prodir,nameprefix, daynum);

% post processing of ripple data

days = [1];
%name=  'Jigsaw';
nameprefix = 'Jig'; 
prodir ='/mnt/backup/walter/walter/phys/Jig';
for daynum = days
extractripples(prodir, nameprefix, daynum, tetrodes, mindur, nstd);
end

%{

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
%}
