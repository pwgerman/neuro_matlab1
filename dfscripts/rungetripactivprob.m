% rungetripactivprob

clear epochfilter;
clear PFincludeepochfilter;
clear f;

Veqn = '<=2'; % >=0; velocity threshold for exclude times for ripples; alters ripple prob.
stage = 4; % [1 2 3] shock, control
minnumspikes = 1;
minVPF = 4; % 2, minimum velocity during place fields; higher reduces included cells
minPeakPF = 3; % 3 % minimum place field peak rate
maxmeanratePF = 4; % maximum mean rate of cells in reactivation epoch
mintime = 30; % (sec) removes epochs from analysis if all epoch excluded by excludetimes, mintime = 30
refepoch = 3; % use for excludecellsf()
%day = 1;

% record script parameters to output struct
param.Veqn = Veqn;
param.minnumspikes = minnumspikes;
param.minVPF = minVPF;
param.minPeakPF = minPeakPF;
param.maxmeanratePF = maxmeanratePF;
param.mintime = mintime;
param.refepoch = refepoch; 
%param.day = day;


%Animal selection
%-----------------------------------------------------
%animals = {'Eliot'};
%animals = {'Bukowski','Cummings','Eliot','Jigsaw'}; % good for day 4
animals = {'Bukowski','Cummings','Dickinson','Eliot','Jigsaw'};
%-----------------------------------------------------


%Filter creation
%--------------------------------------------------------
for i = 1:stage %length(stage)
    %i = stage(j);
    day = i;
    
    % index filters [day epoch tetrode cell]
    % ripple filters
    %epochfilter{1} = ['(isequal($environment, ''ctrack'')) & $exposureday == ' num2str(day)];
    %epochfilter{2} = ['(isequal($environment, ''lineartrack'')) & $exposureday == ' num2str(day)];
    epochfilter{1} = ['$shock == 1 & $exposureday == ' num2str(day)];
    epochfilter{2} = ['(isequal($environment, ''lineartrack'') | isequal($environment, ''ctrack'') ) & $shock == 0 & $exposureday == ' num2str(day)];
    %epochfilter = [ '(isequal($type, ''sleep'')) & $exposureday == ' num2str(day) ' & $epoch == 4']; % isequal($environment 'sleep')
    %epochfilter = [ '(isequal($type, ''sleep'')) & $epoch == 4 & $freezeMedianSplit == 0 & $exposureday < 5']; % isequal($environment 'sleep')
    %epochfilter = [ '(isequal($type, ''sleep'')) & $epoch == 4 & $freezeAnimalSplit == 1 & $exposureday < 5'];
    %epochfilter = [ '(isequal($type, ''sleep'')) & $epoch == 4 & $exposureday < 5'];
    
    % exclude times of ripples.
    timefilter = { {'getlinvelocity', ['((abs($velocity) ',Veqn,'))'] } };
    %timefilter{1} = {'getlinstate', '(($traj ~= -1) & abs($velocity) > -1)', 6};
    %timefilter{2} = {['getestpos'] ['$freezing == ' num2str(freezeon)]};
    % timefilter = { {'getlinvelocity', ['((abs($velocity) ',Veqn,'))'] } };
     
    % cellfilter for reactivated cells in ripple epoch
    cellfilter =['( (isequal($area, ''CA1'') | isequal($area, ''CA3'') ) && ($meanrate < ' num2str(maxmeanratePF) ') )'];
    %cellfilter = '(isequal($area, ''CA1'') && ($meanrate < 7))';
    %cellfilter = '(isequal($area, ''CA3'') && ($meanrate < 4))';

    % filter added to placefield cells in includeepochfilter
    PFincludeepochfilter{1} = ['(isequal($environment, ''lineartrack'') | isequal($environment, ''ctrack'') ) & $shock == 1'];
    PFincludeepochfilter{2} = ['(isequal($environment, ''lineartrack'') | isequal($environment, ''ctrack'') ) & $shock == 0'];
    %PFincludeepochfilter{1} = ['isequal($environment, ''ctrack'')'];
    %PFincludeepochfilter{2} = ['isequal($environment, ''lineartrack'')'];
    %PFincludeepochfilter{1} = [ '(isequal($type, ''run'')) & $exposureday == ' num2str(day) ' & $epoch == 2'];
    %PFincludeepochfilter{2} = [ '(isequal($type, ''run'')) & $exposureday == ' num2str(day) ' & $epoch == 3'];
    %PFincludeepochfilter{1} = [ '(isequal($type, ''run'')) & $exposureday < 5 & $epoch == 2'];
    %PFincludeepochfilter{2} = [ '(isequal($type, ''run'')) & $exposureday < 5 & $epoch == 3'];
  
    % test index for exclusions (place field peak)
    PFcellfilter = cellfilter;

    PFepochfilter = [ '(isequal($type, ''run'')) & $exposureday == ', num2str(day)]; % exposureday, shock=1 or 0
    %PFepochfilter = [ '(isequal($type, ''run'')) & $exposureday < 5'];
    
    riptetfilter =  '(isequal($area, ''CA1'')) '; % riptetfilter is an arg for getripactivprob call to gettetmaxcell
    iterator = 'singlecellanal';
 
    % create filter for ripple/reactivation epoch
    f{i} = createfilter('animal',animals,'epochs',epochfilter,'cells',cellfilter,'excludetimefilter', timefilter, 'iterator', iterator);
    % SLEEP: use below for SLEEP epochs.
    %f{i} = createfilter('animal',animals,'epochs',epochfilter,'cells', cellfilter, 'iterator', iterator);
    
    f{i} = testexcludetimes(f{i}, mintime); %removes epochs from analysis if all epoch excluded by excludetimes, mintime = 30
    %f{i} = createfilter('animal',animals,'epochs',epochfilter,'cellpairs',cellpairfilter,'excludetimefilter', timefilterstage{i}, 'iterator', iterator);

    % only include cells with placefields  
    %tmprefepoch = getfilterepochs(f{i}, PFincludeepochfilter);
    if minPeakPF > 0
        PFcells = calcPFcells(minVPF, minPeakPF, animals, PFepochfilter, 0, 'cellfilter', PFcellfilter);
        %f{i} = excludecellsf2(f{i}, PFcells, 'includeepochfilter', PFincludeepochfilter);
        f{i} = excludecellsf2(f{i}, PFcells, 'includeepochfilter', PFincludeepochfilter, 'action', 'firstonly');
    end
    
    f{i}= setfilterfunction(f{i}, 'getripactivprob', {'spikes','ripples','task','cellinfo'} , riptetfilter, 'minnumspikes', minnumspikes, 'appendindex', 1);%
    %f{i}= setfilterfunction(f{i}, 'getripactivprob', {'spikes','ripples','task','cellinfo'} ,  '(isequal($area, ''CA3'')) ', 'minnumspikes', minnumspikes, 'appendindex', 1);%
    %last run in original:% f{i} = setfilterfunction(f{i}, 'calctotalmeanrate', {'spikes'},'appendindex', 0 );
    %f{i} = setfilterfunction(f{i}, 'calcoccnormmeanrate', {'spikes', 'linpos'},'appendindex',0);
    f{i} = runfilter(f{i});
    for an = 1:length(animals)
        f{i}(an).rungetripactivprob = param;
    end  
end
