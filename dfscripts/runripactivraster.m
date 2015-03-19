% runripactivraster
%   This script runs a series of filter functions, then runs a series of
%   plotting functions to generate rasters of cell reactivation times and
%   freezing state.

clear epochfilter;
clear PFincludeepochfilter;
clear f;

Veqn = '<=2'; % >=0; velocity threshold for exclude times for ripples; alters ripple prob.
minnumspikes = 1;
minVPF = 4; % (a value of 2 only increased cells by 2% per day), minimum velocity during place fields; higher reduces included cells
minPeakPF = 3; % 3 % minimum place field peak rate
maxmeanratePF = 4; % maximum mean rate of cells in reactivation epoch
mintime = 30; % (sec) removes epochs from analysis if all epoch excluded by excludetimes, mintime = 30


%Animal selection
%-----------------------------------------------------
%animals = {'Eliot'};
animals = {'Bukowski', 'Cummings', 'Dickinson', 'Eliot', 'Jigsaw'};
%animals = {'Cummings'};
%Filter creation
%--------------------------------------------------------
days = 1:5; % accepts a vector

subset = 'secondonly'; %'firstonly';% setlist{stage(i)};

% index filters [day epoch tetrode cell]
%% ripple epoch filter
epochfilter = ['$shock == 1 & ismember($exposureday, [' num2str(days) '])'];
%epochfilter = ['$control == 1 & ismember($exposureday, [' num2str(days) '])'];

% only shock and control tracks
%epochfilter{1} = ['$shock == 1 & $exposureday == ' num2str(day)];
%epochfilter{2} = ['(isequal($environment, ''lineartrack'') | isequal($environment, ''ctrack'') ) & $shock == 0 & $exposureday == ' num2str(day)];

%{
% first 4 epochs (shock vs control)
epochfilter{1} = [ '(isequal($type, ''sleep'')) & $exposureday == ' num2str(day) ' & $epoch == 1']; % isequal($environment 'sleep')
epochfilter{2} = ['$shock == 1 & $exposureday == ' num2str(day)];
epochfilter{3} = ['(isequal($environment, ''lineartrack'') | isequal($environment, ''ctrack'') ) & $shock == 0 & $exposureday == ' num2str(day)];
epochfilter{4} = [ '(isequal($type, ''sleep'')) & $exposureday == ' num2str(day) ' & $epoch == 4']; % isequal($environment 'sleep')
%}

%% exclude times of ripples.
timefilter = { {'get2dstate', ['((abs($velocity) ',Veqn,'))'] } }; % works for run and sleep epochs BASELINE

% cellfilter for reactivated cells in ripple epoch
cellfilter =['( (isequal($area, ''CA1'') | isequal($area, ''CA3'') ) && ($meanrate < ' num2str(maxmeanratePF) ') )'];

% filter added to placefield cells in includeepochfilter
PFincludeepochfilter{1} = ['(isequal($environment, ''lineartrack'') | isequal($environment, ''ctrack'') ) & $shock == 1'];
PFincludeepochfilter{2} = ['(isequal($environment, ''lineartrack'') | isequal($environment, ''ctrack'') ) & $shock == 0'];

% test index for exclusions (place field peak)
PFcellfilter = cellfilter;
%PFcellfilter =['(isequal($area, ''CA3'') && ($meanrate < ' num2str(maxmeanratePF) ') )'];

PFepochfilter = [ '(isequal($type, ''run'')) & ismember($exposureday, [' num2str(days) '])']; % exposureday, shock=1 or 0
%PFepochfilter = [ '(isequal($type, ''run'')) & $exposureday < 5'];

riptetfilter =  '(isequal($area, ''CA1'')) '; % riptetfilter is an arg for getripactivprob call to gettetmaxcell
iterator = 'singlecellanal';

% create filter for ripple/reactivation epoch
%if i==2 | i==3 % run epoch
f = createfilter('animal',animals,'epochs',epochfilter,'cells',cellfilter,'excludetimefilter', timefilter, 'iterator', iterator);
%elseif i==1 | i==4 % SLEEP: use below for SLEEP epochs.
%    f = createfilter('animal',animals,'epochs',epochfilter,'cells', cellfilter, 'iterator', iterator);
%end

f = testexcludetimes(f, mintime); %removes epochs from analysis if all epoch excluded by excludetimes, mintime = 30
%f = createfilter('animal',animals,'epochs',epochfilter,'cellpairs',cellpairfilter,'excludetimefilter', timefilterstage{i}, 'iterator', iterator);

% only include cells with placefields
%tmprefepoch = getfilterepochs(f, PFincludeepochfilter);
if minPeakPF > 0
    PFcells = calcPFcells(minVPF, minPeakPF, animals, PFepochfilter, 0, 'cellfilter', PFcellfilter);
    %f = excludecellsf2(f, PFcells, 'includeepochfilter', PFincludeepochfilter);
    f = excludecellsfsubset2(f, PFcells, 'includeepochfilter', PFincludeepochfilter, 'subset', subset);
end


%% run filter
% get all ripple times for cells with place fields in designated track
f= setfilterfunction(f, 'getripactiv', {'spikes','ripples','task','cellinfo'} , riptetfilter, 'minnumspikes', minnumspikes, 'appendindex', 1);%
f = runfilter(f);
f = extendfilter(f, 'keepoutput', 'outputreact', 'iterator', iterator);

% find ripple-start triggered windows
%f = setfilterfunction(f, 'getrasterwindows', {'ripples','task','cellinfo'} , riptetfilter, 'appendindex', 1);%
%f = runfilter(f);

ft = gettetrodelist(f, riptetfilter, 2, 'maxcell', 1); % reduces f.data to tetrode with most cells
%f = extendfilter(f, 'keepoutput', 'outputtet');

% find freeze-start triggered windows
f = setfilterfunction(f, 'getfreezerasterwindows', {'estpos','task','cellinfo'} , riptetfilter, 'appendindex', 1);%
f = runfilter(f);
f = extendfilter(f, 'keepoutput', 'outputfrz');


%% plot rasters
% for each epoch get all raster rows
for an = 1:size(f,2) % animal
    animal = animaldef(f(an).animal{1}, 'outputstruct',1);
    cellcount = [];
    cellsum = [0];
    for ee = 1:size(f(an).data{1},2)
        cellcount(ee) = size(f(an).data{1}{ee},1);
        cellsum(ee+1) = sum(cellcount);
    end
    
    for ee = 1:size(f(an).epochs{1},1)
        tet = ft(an).data{1}{ee};   % uses output filter ft from gettetrodelist
        tlist = [f(an).epochs{1}(ee,:) tet]; % tetrode index [day epoch tetrode-with-best-ripples]
        
        %if ~isempty(times)
        cellindex = 0;
        for cc= (cellsum(ee)+1):(cellsum(ee+1)) % cells reactivated
            cellindex = cellindex +1;
            times = f(an).outputfrz{1}(cc).times{1};    % times are windows for freezing episodes
            if ~isempty(times)
                scoord = plotrasters(animal.dir, animal.pre, tlist, times, 'datatype', 'ripples', 'colorstr', 'c');
                scoord = plotrasterstate(animal.dir, animal.pre, tlist, times, 'datatype', 'estpos', 'colorstr', 'r');
                ymax = get(gca, 'YLim');
                
                % additions to plot reactivated ripple times
                if ~isempty(f(an).outputreact{1}(cc).times)
                    reactstart = f(an).outputreact{1}(cc).times(:,1);   % reactivation times for cell listed in f.data
                    scoord = plotrasters2(reactstart, times, 'colorstr', 'b');
                    ylim(ymax);
                    title(['an-', animal.name, '  de ', num2str(tlist(1:2)),...
                        '  riptet ', num2str(tet), ...
                        '  react-tet+cell ', num2str(f(an).data{1}{ee}(cellindex,:)), ...
                        ' / ', num2str(cellcount(ee)) ]);
                    keyboard;
                    
                end
                cla;
            end% watch the reactivation rasters erase, but plot ripples
        end
    end
end


