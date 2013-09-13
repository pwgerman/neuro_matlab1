% rungetripactivprob
% script based on:
% /home/walter/Src/matlab/asinger/spikeduringrip.m

shocktrackon = 1;


% not paired comparisons.

%n=1;
Veqn = '<=2'; % >=0; velocity threshold for exclude times for ripples; alters ripple prob.
%ovlpthresh = 0
%titleprefix = ['Riptimes V', Veqn];
maxstage = 1; %3 ;%[ 1 2 3];
%excludezeros = 0;
minnumspikes = 1;
minVPF = 4; % 2, minimum velocity during place fields; higher reduces included cells
minPeakPF = 3; % 3 % minimum place field peak rate
mintime = 30; % (sec) removes epochs from analysis if all epoch excluded by excludetimes, mintime = 30

% record script parameters to output struct
param.shocktrackon = shocktrackon;
param.Veqn = Veqn;
param.minnumspikes = minnumspikes;
param.minVPF = minVPF;
param.minPeakPF = minPeakPF;
param.mintime = mintime;


%Animal selection
%-----------------------------------------------------
animals = {'Eliot'};
%animals = {'Barack' 'Calvin', 'Dwight'};
%animals = {'Dwight'};
%-----------------------------------------------------


%Filter creation
%--------------------------------------------------------
for j = 1:length(maxstage)
    i = maxstage(j)
    
    % ripple filters
    epochfilter{1} = ['(isequal($environment, ''ctrack'')) & $exposure == 1'];
    epochfilter{2} = ['(isequal($environment, ''lineartrack'')) & $exposure == 1'];
    
    % place field filter for reactivated cells
    %epochfilter{1} = ['(isequal($environment, ''ctrack'')) & $exposure == 1 & $shock == ' num2str(shocktrackon)];
    %epochfilter{2} = ['(isequal($environment, ''lineartrack'')) & $exposure == 1 & $shock == ' num2str(shocktrackon)];
    includecellsfilter = ['(isequal($environment, ''lineartrack'')) & $exposure == 1'];

    %epochfilter{1} = ['($switchday > 0) & ($tasknum == 1)']; %just analyze days where switching between tasks
    %epochfilter{2} = ['($switchday > 0) & ($tasknum == 2)'];

    % cellfilter for reactivated cells
    % a cellfilter is already built into getpeakratesallrun
    cellfilter ='( (isequal($area, ''CA1'') | isequal($area, ''CA3'') ) && ($meanrate < 4) )';
    %cellfilter = '(isequal($area, ''CA1'') && ($meanrate < 7))';
    %cellfilter = '(isequal($area, ''CA3'') && ($meanrate < 4))';

    % paired with 'excludetime' in runriprate %timefilter{1} = {'getlinstate', '(($traj ~= -1) & abs($velocity) > -1)', 6};
    % paired with 'excludetime' %timefilter{2} = {['getestpos'] ['$freezing == ' num2str(freezeon)]};
    timefilter = { {'getlinvelocity', ['((abs($velocity) ',Veqn,'))'] } };
    % timefilter = { {'getlinvelocity', ['((abs($velocity) ',Veqn,'))'] } };
    %{
    if maxstage >0
        timefilter = { {'getriptimes', '($nripples >= 1)', [], 'cellfilter', '(isequal($area, ''CA3''))', 'maxcell', 1} {'getcalctaskstage', ['($includebehave == ', num2str(i), ')'], 1}  {'getlinvelocity', ['((abs($velocity)', Veqn,'))'] } };
        %timefilter = { {'getcalctaskstage', ['($includebehave == ', num2str(i), ')'], 1}  {'getlinvelocity', ['((abs($velocity)', Veqn,'))'] } };
    else
        timefilter = { {'getlinvelocity', ['((abs($velocity)', Veqn,'))'] } };
    end
    %}
    
    iterator = 'singlecellanal';
    f{i} = createfilter('animal',animals,'epochs',epochfilter,'cells',cellfilter,'excludetimefilter', timefilter, 'iterator', iterator);
    f{i} = testexcludetimes(f{i}, mintime); %removes epochs from analysis if all epoch excluded by excludetimes, mintime = 30
    %f{i} = createfilter('animal',animals,'epochs',epochfilter,'cellpairs',cellpairfilter,'excludetimefilter', timefilterstage{i}, 'iterator', iterator);

    %only include cells with placefields
    if minPeakPF > 0
        includecells = calcincludecells(minVPF, minPeakPF, animals, includecellsfilter, 0, 'cellfilter', cellfilter);
        %includecells = calcincludecells(minVPF, minPeakPF, animals, epochfilter);
        %includecells = calcincludecells(minVPF, minPeakPF);
        f{i} = excludecellsf(f{i}, includecells);
    end
    
    f{i}= setfilterfunction(f{i}, 'getripactivprob', {'spikes','ripples','task','cellinfo'} ,  '(isequal($area, ''CA1'')) ', 'minnumspikes', minnumspikes, 'appendindex', 1);%
    %f{i}= setfilterfunction(f{i}, 'getripactivprob', {'spikes','ripples','task','cellinfo'} ,  '(isequal($area, ''CA3'')) ', 'minnumspikes', minnumspikes, 'appendindex', 1);%
    %last run in original:% f{i} = setfilterfunction(f{i}, 'calctotalmeanrate', {'spikes'},'appendindex', 0 );
    %f{i} = setfilterfunction(f{i}, 'calcoccnormmeanrate', {'spikes', 'linpos'},'appendindex',0);
    f{i} = runfilter(f{i});
    f{i}.rungetripactivprob = param;
    
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
