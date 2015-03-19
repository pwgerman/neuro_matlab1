% Animal Selection
%animals = {'Eliot'};
animals = {'Cummings'};
days = 1:5;

% Epoch Filter
%epochfilter = '(isequal($description, ''TrackA''))';
epochfilter = ['$shock == 1 & ismember($exposureday, [' num2str(days) '])'];
%epochfilter = ['(isequal($environment, ''lineartrack'') | isequal($environment, ''ctrack'') ) & $shock == 0'];

%epochfilter = ['($exposureday >= 4)'];
%epochfilter = ['($exposureday == 1)'];

% Time Filter
%timefilter = { {'getlinstate', '(($traj ~= -1) & abs($velocity) >=0)', 6} };
timefilter = { {'get2dstate', ['((abs($velocity) <= 2))'] } }; % works for run and sleep epochs BASELINE

% Cell Pair Filter
cellpairfilter = {'difftet','(isequal($area, ''CA1''))', '(isequal($area, ''CA1''))'};

% Iterator
iterator = 'multicellanal';

% Filter Creation
f = createfilter('animal', animals, 'epochs', epochfilter, 'cellpairs', cellpairfilter, 'excludetime', timefilter, 'iterator', iterator);

% Set Analysis Function
f = setfilterfunction(f, 'getriptriggeredspiking', {'ripples','spikes'},'minthresh',2,'window',[0.5 0.5]);

% Run Analysis
f = runfilter(f);