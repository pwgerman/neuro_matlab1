
%{
animal = animaldef('Eliot', 'outputstruct', 1);
spikes = loaddatastruct(animal.dir, animal.pre, 'spikes');
cellinfo = loaddatastruct(animal.dir, animal.pre, 'cellinfo');

%h = plotrasters(animal.dir, animal.name, celllist, times);
%}

%% create filter

% Animal Selection
%animals = {'Bukowski', 'Cummings', 'Dickinson', 'Eliot', 'Jigsaw'};
animals = {'Eliot'};
days = 4;
minnumspikes = 1;

% Epoch Filter
epochfilter = ['$shock == 1 & ismember($exposureday, [' num2str(days) '])'];
%epochfilter = ['(isequal($environment, ''lineartrack'') | isequal($environment, ''ctrack'') ) & $shock == 0 & ismember($exposureday, [' num2str(days) '])' ];

% Time Filter
%timefilter = { {'getlinstate', '(($traj ~= -1) & abs($velocity) >=0)', 6} };
timefilter = { {'get2dstate', ['((abs($velocity) <= 2))'] } }; % works for run and sleep epochs BASELINE

% Cell Pair Filter
%cellpairfilter = {'difftet','(isequal($area, ''CA1''))', '(isequal($area, ''CA1''))'};

% cellfilter for reactivated cells in ripple epoch
cellfilter =['(isequal($area, ''CA1'') | isequal($area, ''CA3'') )'];

% riptetfilter is an arg for getripactivprob call to gettetmaxcell
riptetfilter =  '(isequal($area, ''CA1'')) '; 

iterator = 'singlecellanal';

% create filter for ripple/reactivation epoch
f = createfilter('animal',animals,'epochs',epochfilter,...
    'cells',cellfilter,'excludetimefilter', timefilter,...
    'iterator', iterator);  % for singlecellanal and cellfilter

% for multicellanal and cellpairfilter
%{
% Iterator
iterator = 'multicellanal';
% Filter Creation
f = createfilter('animal', animals, 'epochs', epochfilter,...
    'cellpairs', cellpairfilter, 'excludetime', timefilter,...
    'iterator', iterator);  
%}


f = setfilterfunction(f, 'getrasters', {'spikes','ripples','task','cellinfo'} , riptetfilter, 'minnumspikes', minnumspikes, 'appendindex', 1);%

%% run filter
f = runfilter(f);

%% plot rasters
animal = animaldef('Eliot', 'outputstruct', 1);

%% for each cell get all raster rows
for ii = 1:size(f.data{1}{1},1)
    ii;
    clist = [f.epochs{1} f.data{1}{1}(ii,:)];
    times = f.output{1}(1).times{1};
    scoord = plotrasters(animal.dir, animal.pre, clist, times); % h = ... nargout to check if return or not in plotrasters
    keyboard;
end




