% compare_ripactivraster
%   This script runs a series of filter functions, then runs a series of
%   plotting functions to generate rasters of cell reactivation times and
%   freezing state.

clear epochfilter;
clear PFincludeepochfilter;
clear f ft ff fg;

Veqn = '<=2'; % >=0; velocity threshold for exclude times for ripples; alters ripple prob.
minnumspikes = 1;
minVPF = 4; % (a value of 2 only increased cells by 2% per day), minimum velocity during place fields; higher reduces included cells
minPeakPF = 3; % 3 % minimum place field peak rate
maxmeanratePF = 4; % maximum mean rate of cells in reactivation epoch
mintime = 30; % (sec) removes epochs from analysis if all epoch excluded by excludetimes, mintime = 30


%Animal selection
%-----------------------------------------------------
animals = {'Eliot'};
%animals = {'Bukowski', 'Cummings', 'Dickinson', 'Eliot', 'Jigsaw'};
%animals = {'Cummings'};
%Filter creation
%--------------------------------------------------------
days = 3; % accepts a vector

%subset = [{'firstonly'} {'secondonly'}]; %'firstonly';% setlist{stage(i)};
subset = [{'first'} {'second'}];

%% ripple epoch filter
epochfilter = ['$shock == 1 & ismember($exposureday, [' num2str(days) '])'];
%epochfilter = ['$control == 1 & ismember($exposureday, [' num2str(days) '])'];

%% exclude times of ripples.
timefilter = { {'get2dstate', ['((abs($velocity) ',Veqn,'))'] } }; % works for run and sleep epochs BASELINE

% cellfilter for reactivated cells in ripple epoch
cellfilter =['( (isequal($area, ''CA1'') | isequal($area, ''CA3'') ) &&'...
    '($meanrate < ' num2str(maxmeanratePF) ') )'];

% filter added to placefield cells in includeepochfilter
PFincludeepochfilter{1} = ['(isequal($environment, ''lineartrack'') | isequal($environment, ''ctrack'') ) & $shock == 1'];
PFincludeepochfilter{2} = ['(isequal($environment, ''lineartrack'') | isequal($environment, ''ctrack'') ) & $shock == 0'];

% test index for exclusions (place field peak)
PFcellfilter = cellfilter;

PFepochfilter = [ '(isequal($type, ''run'')) & ismember($exposureday, [' num2str(days) '])']; % exposureday, shock=1 or 0

riptetfilter =  '(isequal($area, ''CA1'')) '; % riptetfilter is an arg for getripactivprob call to gettetmaxcell
iterator = 'singlecellanal';

% create filter for ripple/reactivation epoch
ff = createfilter('animal',animals,'epochs',epochfilter,'cells',cellfilter,...
    'excludetimefilter', timefilter, 'iterator', iterator);

ff = testexcludetimes(ff, mintime); %removes epochs from analysis if all epoch excluded by excludetimes, mintime = 30

iname = '~/.matlabcache/filter2';

%{
if tweedledum(iname); % checks if filter results are already in cache
    tweedledee(iname, iname); %
else
    % set ff{2} = ff{2}; so have copy for two data sets gg
    % only include cells with placefields
%}
    for gg = 1:2 % number of Place Field groups to compare
        fg{gg} = ff;
        if minPeakPF > 0
            PFcells = calcPFcells(minVPF, minPeakPF, animals, PFepochfilter, 0,...
                'cellfilter', PFcellfilter);
            fg{gg} = excludecellsfsubset2(fg{gg}, PFcells,...
                'includeepochfilter', PFincludeepochfilter, 'subset', subset{gg});
        end
        
        
        %% run filter
        % get all ripple times for cells with place fields in designated track
        fg{gg}= setfilterfunction(fg{gg}, 'getripactiv',...
            {'spikes','ripples','task','cellinfo'} , riptetfilter,...
            'minnumspikes', minnumspikes, 'appendindex', 1);%
        fg{gg} = runfilter(fg{gg});
        fg{gg} = extendfilter(fg{gg}, 'keepoutput', 'outputreact', 'iterator', iterator);
    end%
    
%end % tweedledum

gg = 1; % use group1 for any default calculations that are the same for all groups



ft = gettetrodelist(ff, riptetfilter, 2, 'maxcell', 1); % reduces f.data to tetrode with most cells
%f = extendfilter(f, 'keepoutput', 'outputtet');

% find freeze-start triggered windows
%ff = setfilterfunction(ff, 'getfreezerasterwindows', {'estpos','task','cellinfo'} , riptetfilter, 'appendindex', 1);%
ff = extendfilter(ff, 'iterator', 'epochbehaveanal');
ff = setfilterfunction(ff, 'getfreezerasterwindows2',...
    {'estpos','task','cellinfo'} , riptetfilter, 'appendindex', 1,...
    'window', [5 5]);
ff = runfilter(ff);
ff = extendfilter(ff, 'keepoutput', 'outputfrz');


%% plot rasters
% for each epoch get all raster rows
cla;
for an = 1:size(ff,2) % animal
    animal = animaldef(ff(an).animal{1}, 'outputstruct',1);
    cellcount{1} = [];
    cellsum{1} = [0];
    cellcount{2} = [];
    cellsum{2} = [0];
    
    % set up cell indexes
    % group1 and group2 indexes
    for gg = 1:2
        for ee = 1:size(fg{gg}(an).data{1},2)
            cellcount{gg}(ee) = size(fg{gg}(an).data{1}{ee},1);
            cellsum{gg}(ee+1) = sum(cellcount{gg});
        end
    end
    
    for ee = 1:size(ff(an).epochs{1},1)
        tet = ft(an).data{1}{ee};   % uses output filter ft from gettetrodelist
        tlist = [ff(an).epochs{1}(ee,:) tet]; % tetrode index [day epoch tetrode-with-best-ripples]
        %times = ff(an).outputfrz{1}(cellsum{1}(ee)+1).times{1};    % this version is from singlecell anal iterator
        times = ff(an).outputfrz{1}(ee).times{1};    % times are windows for freezing episodes
        if ~isempty(times)
            %scoord = plotrasters(animal.dir, animal.pre, tlist, times, 'datatype', 'ripples', 'colorstr', 'c');
            scoord = plotrasterstate(animal.dir, animal.pre, tlist, times,...
                'datatype', 'estpos', 'colorstr', 'k',...
                'FaceAlpha', .1);
            ymax = get(gca, 'YLim');
            ylim(ymax);
            % plot group1 and group2 rasters
            for gg = 1:2;
                cellindex = 0;
                for cc= (cellsum{gg}(ee)+1):(cellsum{gg}(ee+1)) % cells reactivated
                    cellindex = cellindex +1;
                    % additions to plot reactivated ripple times
                    if ~isempty(fg{gg}(an).outputreact{1}(cc).times)
                        reactstart = fg{gg}(an).outputreact{1}(cc).times(:,1);   % reactivation times for cell listed in f.data
                        if gg == 1
                            scoord = plotrasters2(reactstart, times,...
                                'colorstr', 'r', 'LineWidth', 3, 'EdgeAlpha', .28); 
                        else %gg=2
                            scoord = plotrasters2(reactstart, times,...
                                'colorstr', 'b', 'LineWidth', 3, 'EdgeAlpha', .28); %EdgeAlpha makes raster bars transparent;
                        end
                    end
                end
                
            end
        end
        ylim(ymax);
        title(['an-', animal.name, '  de ', num2str(tlist(1:2)) ]);
        keyboard
        
        %{
        % save file info
        fileprefix = 'shock-allPF';
        savedir = '/Users/walter/Desktop/compare-react-plots/';
        filenameout = [fileprefix, '-animal', num2str(an), '-', num2str(ee)]; %[picpre, num2str(picind)];
        % save output for adobe illustrator
        %print('-depsc','-r300',[savedir,filenameout,'.ai']);
        print('-djpeg','-r300',[savedir,filenameout,'.jpg']);
        filenameout = [fileprefix, '-epoch', num2str(ee), '-', num2str(an)]; %[picpre, num2str(picind)];
        print('-djpeg','-r300',[savedir,filenameout,'.jpg']);
        %}
        
        cla;
    end
end


