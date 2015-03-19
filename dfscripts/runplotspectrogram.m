% runplotspectrogram.m
% generates spectrograms using filter framework to specify parameters.

% Animal selection
animals = {'Eliot'};
days= 1:5;

% Epoch selection
%epochfilter{1} = ['isequal($description, ''TrackA'') & ($exposure == 1)'];
%epochfilter{2} = ['isequal($description, ''TrackA'') & ($exposure == 7)'];
epochfilter{1} = ['$shock == 1 & ismember($exposureday, [' num2str(days) '])'];
epochfilter{2} = ['$control == 1 & ismember($exposureday, [' num2str(days) '])'];

% Tetrode selection
tetrodefilter = '(isequal($area, ''CA1''))';

% Time selection
%timefilter = {{'getlinstate', '(($traj ~= -1) & abs($velocity) >= 0)', 6}};
timefilter = { {'get2dstate', ['((abs($velocity) <= 2))'] } }; % works for run and sleep epochs BASELINE

% Iterator selection
iterator = 'eeganal';


% Create and Run Filter
f = createfilter('animal',animals,'epochs',epochfilter,'excludetime',timefilter,'eegtetrodes', tetrodefilter, 'iterator', iterator);

%f = setfilterfunction(f, 'calcspectrogram', {'eeg'},'appendindex',1,'fpass',[0 150]);
f = setfilterfunction(f, 'plotspectrogram', {'eeg'},'appendindex',1,'fpass',[0 15]);

f = runfilter(f);