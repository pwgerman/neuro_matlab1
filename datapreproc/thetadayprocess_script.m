% thetadayprocess_script
%
%
%animal = animaldef('Bukowski', 'outputstruct', 1);
%animal = animaldef('Cummings', 'outputstruct', 1);
%animal = animaldef('Dickinson', 'outputstruct', 1);
animal = animaldef('Eliot', 'outputstruct', 1);
%animal = animaldef('Jigsaw', 'outputstruct', 1);
%tet = 6;
days = 1:5;
%tetlist = [1 6];

tic;

% This will generate the original theta filter I used prior to remove high
% amplitude 
%{
thetadayprocess(animal.eegdir, animal.pre, days,...
    'instring', 'eeg', 'outstring', 'theta', 'daytetlist', tetlist);
%}

% Type 2 theta test run on a single tetrode
%{
thetadayprocess(animal.eegdir, animal.pre, days,...
    'instring', 'eegthresh', 'outstring', 't2theta', 'daytetlist', tetlist, 'f', 'type2thetafilter.mat');
toc
%}

% Type 2 theta
%{
thetadayprocess(animal.eegdir, animal.pre, days,...
    'instring', 'eegthresh', 'outstring', 't2theta', 'f', 'type2thetafilter.mat');
toc
%}

% Type 1 theta
thetadayprocess(animal.eegdir, animal.pre, days,...
    'instring', 'eegthresh', 'outstring', 't1theta', 'f', 'type1thetafilter.mat');
toc

