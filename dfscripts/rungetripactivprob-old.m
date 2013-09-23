% rungetripactivprob
% script based on:
% /home/walter/Src/matlab/asinger/spikeduringrip.m

shocktrackon = 1;


% not paired comparisons.

%n=1;
Veqn = '<=2'; % >=0; velocity threshold for exclude times for ripples; alters ripple prob.
%ovlpthresh = 0
%titleprefix = ['Riptimes V', Veqn];
stage = 1; % shock, control
%excludezeros = 0;
minnumspikes = 1;
minVPF = 4; % 2, minimum velocity during place fields; higher reduces included cells
minPeakPF = 3; % 3 % minimum place field peak rate
mintime = 30; % (sec) removes epochs from analysis if all epoch excluded by excludetimes, mintime = 30
refepoch = 3; % use for excludecellsf()

% record script parameters to output struct
param.shocktrackon = shocktrackon;
param.Veqn = Veqn;
param.minnumspikes = minnumspikes;
param.minVPF = minVPF;
param.minPeakPF = minPeakPF;
param.mintime = mintime;
param.refepoch = refepoch; 


%Animal selection
%-----------------------------------------------------
%animals = {'Eliot'};
%animals = {'Bukowski','Cummings','Eliot','Jigsaw'}; % good for day 4
animals = {'Bukowski','Cummings','Dickinson','Eliot','Jigsaw'};
%animals = {'Barack' 'Calvin', 'Dwight'};
%-----------------------------------------------------


%Filter creation
%--------------------------------------------------------
for j = 1:length(stage)
    i = stage(j);
    
    % index filters [day epoch tetrode cell]
    % f(an).epoch{g}{e} = [day epoch] where g is cell index when defining
    % epoch filter (ie epochfilter{g}=...)
    % and e is a single epoch calculated by a filter setting.
    %
    % ripple filters
    %epochfilter{1} = ['(isequal($environment, ''ctrack'')) & $exposure == 1'];
    %epochfilter{2} = ['(isequal($environment, ''lineartrack'')) & $exposure == 1'];
    %epochfilter{1} = ['$shock == 1 & $exposure == 4'];
    %epochfilter{2} = ['(isequal($environment, ''lineartrack'') | isequal($environment, ''ctrack'') ) & $shock == 0 & $exposure == 4'];
    epochfilter = [ '(isequal($type, ''sleep'')) & $exposureday == 3 & $epoch == 1']; % isequal($environment 'sleep')
    
    %epochfilter = ['(isequal($environment, ''ctrack'')) & $exposure == 1'];
    %epochfilter{1} = ['(isequal($environment, ''ctrack'')) & $exposure == 1 & $shock == ' num2str(shocktrackon)];
    %epochfilter{2} = ['(isequal($environment, ''lineartrack'')) & $exposure == 1 & $shock == ' num2str(shocktrackon)];
    
    % exclude times of ripples.
    timefilter = { {'getlinvelocity', ['((abs($velocity) ',Veqn,'))'] } };
    %timefilter{1} = {'getlinstate', '(($traj ~= -1) & abs($velocity) > -1)', 6};
    %timefilter{2} = {['getestpos'] ['$freezing == ' num2str(freezeon)]};
    % timefilter = { {'getlinvelocity', ['((abs($velocity) ',Veqn,'))'] } };
     
    % cellfilter for place cells??? or for ripple tetrode lfps???
    cellfilter ='( (isequal($area, ''CA1'') | isequal($area, ''CA3'') ) && ($meanrate < 4) )';
    %cellfilter = '(isequal($area, ''CA1'') && ($meanrate < 7))';
    %cellfilter = '(isequal($area, ''CA3'') && ($meanrate < 4))';

   
    
    % test index for exclusions (place field peak)
    % This should be able to test for place fields in a different epoch
    % than the ripple reactivation epoch!!!
    % place field cell filter for which reactivated cells to include
    % These are used to remove epochs and cells already added above
    % based on the additional variable of peak place field firing rate.
    % otherwise, these two filters are redundant.
    includecellfilter = cellfilter;
    %includecellfilter ='( (isequal($area, ''CA1'') | isequal($area, ''CA3'') ) && ($meanrate < 4) )';
    %
    %includeepochfilter = epochfilter;
    %includeepochfilter = ['(isequal($environment, ''lineartrack'')) & $exposure == 1'];
    includeepochfilter = [ '(isequal($type, ''run'')) & $exposureday == 3 ']; % exposureday, shock=1 or 0
    %includeepochfilter = ['(isequal($environment, ''ctrack'')) & $exposure == 1'];
    
    % cellfilterGRAP is an arg for getripactivprob call to gettetmaxcell
    % this is used to determine which cells are candidates for the one
    % tetrode with the most cells.  Subsequently, this is used as the only
    % tetrode for determining the occurance and timing of ripple events.
    cellfilterGRAP =  '(isequal($area, ''CA1'')) ';
    refepochfilter = ['(isequal($environment, ''lineartrack'') | isequal($environment, ''ctrack'') ) & $shock == 0'];
        
        
    %{
    if maxstage >0
        timefilter = { {'getriptimes', '($nripples >= 1)', [], 'cellfilter', '(isequal($area, ''CA3''))', 'maxcell', 1} {'getcalctaskstage', ['($includebehave == ', num2str(i), ')'], 1}  {'getlinvelocity', ['((abs($velocity)', Veqn,'))'] } };
        %timefilter = { {'getcalctaskstage', ['($includebehave == ', num2str(i), ')'], 1}  {'getlinvelocity', ['((abs($velocity)', Veqn,'))'] } };
    else
        timefilter = { {'getlinvelocity', ['((abs($velocity)', Veqn,'))'] } };
    end
    %}
    
    % only cells with place fields in reference epoch will be checked for
    % reactivation

    
    iterator = 'singlecellanal';
    %f{i} = createfilter('animal',animals,'epochs',epochfilter,'cells',cellfilter,'excludetimefilter', timefilter, 'iterator', iterator);
    % use below for sleep epochs.
    f{i} = createfilter('animal',animals,'epochs',epochfilter,'cells',cellfilter, 'iterator', iterator);
    f{i} = testexcludetimes(f{i}, mintime); %removes epochs from analysis if all epoch excluded by excludetimes, mintime = 30
    %f{i} = createfilter('animal',animals,'epochs',epochfilter,'cellpairs',cellpairfilter,'excludetimefilter', timefilterstage{i}, 'iterator', iterator);

    
    tmprefepoch = getfilterepochs(f{1}, refepochfilter);
    % refepoch = tmprefepoch{an}{epochgroup-g}  ???
    
    % only include cells with placefields
    if minPeakPF > 0
        includecells = calcincludecells(minVPF, minPeakPF, animals, includeepochfilter, 0, 'cellfilter', includecellfilter);
        %includecells = calcincludecells(minVPF, minPeakPF, animals, epochfilter);
        %includecells = calcincludecells(minVPF, minPeakPF);
        f{i} = excludecellsf2(f{i}, includecells, 'refepoch', tmprefepoch);
        %f{i} = excludecellsf(f{i}, includecells, 'refepoch', refepoch);
    end
    

    f{i}= setfilterfunction(f{i}, 'getripactivprob', {'spikes','ripples','task','cellinfo'} , cellfilterGRAP, 'minnumspikes', minnumspikes, 'appendindex', 1);%
    %f{i}= setfilterfunction(f{i}, 'getripactivprob', {'spikes','ripples','task','cellinfo'} ,  '(isequal($area, ''CA3'')) ', 'minnumspikes', minnumspikes, 'appendindex', 1);%
    %last run in original:% f{i} = setfilterfunction(f{i}, 'calctotalmeanrate', {'spikes'},'appendindex', 0 );
    %f{i} = setfilterfunction(f{i}, 'calcoccnormmeanrate', {'spikes', 'linpos'},'appendindex',0);
    f{i} = runfilter(f{i});
    for an = 1:length(animals)
        f{i}(an).rungetripactivprob = param;
    end
    
    %groups
    %{
    allmin= []; allmax = [];
    g{i} = numericgroupcombine(f{i}, 1);  %if output numeric, this combines across animals, first col is animal

    if excludezeros == 1
        g{i}{1} = g{i}{1}(g{i}{1}(:,2)>0,:);
        g{i}{2} = g{i}{2}(g{i}{2}(:,2)>0,:);
    else
        g{i}{1} = g{i}{1}(~isnan(g{i}{1}(:,2)),:);
        g{i}{2} = g{i}{2}(~isnan(g{i}{2}(:,2)),:);
    end
    allmin = [allmin min(min([g{i}{1}(:,2); g{i}{2}(:,2)]))];
    allmax = [allmax max(max([g{i}{1}(:,2); g{i}{2}(:,2)]))];
    %}
end
