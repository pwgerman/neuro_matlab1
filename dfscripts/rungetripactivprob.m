% rungetripactivprob

clear epochfilter;
clear PFincludeepochfilter;
clear f;

Veqn = '<=2'; % >=0; velocity threshold for exclude times for ripples; alters ripple prob.
minnumspikes = 1;
minVPF = 4; % (a value of 2 only increased cells by 2% per day), minimum velocity during place fields; higher reduces included cells
minPeakPF = 3; % 3 % minimum place field peak rate
maxmeanratePF = 4; % maximum mean rate of cells in reactivation epoch
mintime = 30; % (sec) removes epochs from analysis if all epoch excluded by excludetimes, mintime = 30
refepoch = 3; % use for excludecellsf()
%day = 1; % or use stage
stage = [1 2 3]; % [1 2 3] shock, control; set:intersect,exclude
setlist = [{'firstonly'}, {'secondonly'}, {'intersect'}, {'neither'}]; % which PFincludeepochfilter to use for included place fields

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
animals = {'Cummings'};
%animals = {'Dickinson', 'Eliot'};
%animals = {'Bukowski','Cummings','Dickinson','Eliot','Jigsaw'};
%animals = {'Bukowski','Cummings','Dickinson','Jigsaw'};
%   CHECK DIC DAY4 TASK
%-----------------------------------------------------


%Filter creation
%--------------------------------------------------------
% use stage for multiple days or to compare across different conditions
% such as different actions in excludecellsf2.
mf = [];
for m = 1 %1:5 % days = multiday
    day = m;
for i = 1:length(stage)
    %i = stage(j);
    %day = 1;
    subset = setlist{stage(i)};
    
    % index filters [day epoch tetrode cell]
    %% ripple epoch filter
    % %epochfilter = ['$shock == 1 & $exposureday == ' num2str(day)];
    %epochfilter{2} = ['(isequal($environment, ''ctrack'')) & $exposureday == ' num2str(day)];
    %epochfilter{3} = ['(isequal($environment, ''lineartrack'')) & $exposureday == ' num2str(day)];
    
    % only shock and control tracks
    %epochfilter{1} = ['$shock == 1 & $exposureday == ' num2str(day)];
    %epochfilter{2} = ['(isequal($environment, ''lineartrack'') | isequal($environment, ''ctrack'') ) & $shock == 0 & $exposureday == ' num2str(day)];
    
    % first 4 epochs (shock vs control)
    epochfilter{1} = [ '(isequal($type, ''sleep'')) & $exposureday == ' num2str(day) ' & $epoch == 1']; % isequal($environment 'sleep')
    epochfilter{2} = ['$shock == 1 & $exposureday == ' num2str(day)];
    epochfilter{3} = ['(isequal($environment, ''lineartrack'') | isequal($environment, ''ctrack'') ) & $shock == 0 & $exposureday == ' num2str(day)];
    epochfilter{4} = [ '(isequal($type, ''sleep'')) & $exposureday == ' num2str(day) ' & $epoch == 4']; % isequal($environment 'sleep')
    
    % sleep 2
    %epochfilter = [ '(isequal($type, ''sleep'')) & $epoch == 4 & $freezeMedianSplit == 0 & $exposureday < 5']; % isequal($environment 'sleep')
    %epochfilter = [ '(isequal($type, ''sleep'')) & $epoch == 4 & $freezeAnimalSplit == 1 & $exposureday < 5'];
    %epochfilter = [ '(isequal($type, ''sleep'')) & $epoch == 4 & $exposureday < 5'];

    %shock order (DAYshockfirst) - 'shockfirst' will analyze sepatarely
    %animals with the shock first on day one.  'dayshockfirst' analyzes the
    %days when any animal was in shock track on epoch 2.
    %epochfilter{1} = [ '(isequal($type, ''sleep'')) & $epoch == 1 & $dayshockfirst == 0 & $exposureday == ' num2str(day)]; 
    %epochfilter{2} = ['$shock == 1 & $dayshockfirst == 0 & $exposureday == ' num2str(day)];
    %epochfilter{3} = ['(isequal($environment, ''lineartrack'') | isequal($environment, ''ctrack'') ) & $shock == 0 & $dayshockfirst == 0 & $exposureday == ' num2str(day)];  
    %epochfilter{4} = [ '(isequal($type, ''sleep'')) & $epoch == 4 & $dayshockfirst == 0 & $exposureday == ' num2str(day)];
    
    %track order (DAYcfirst) all c-track epoch and PF criteria:
    %epochfilter{1} = ['(isequal($type, ''sleep'')) & $epoch == 1 & $daycfirst == 1 & $exposureday == ' num2str(day)]; 
    %epochfilter{2} = ['(isequal($environment, ''ctrack'')) & $daycfirst == 1  & $exposureday == ' num2str(day)];
    %epochfilter{3} = ['(isequal($environment, ''lineartrack'')) & $daycfirst == 1  & $exposureday == ' num2str(day)];
    %epochfilter{4} = ['(isequal($type, ''sleep'')) & $epoch == 4 & $daycfirst == 1 & $exposureday == ' num2str(day)];
    %PFincludeepochfilter{1} = ['isequal($environment, ''ctrack'')'];
    %PFincludeepochfilter{2} = ['isequal($environment, ''lineartrack'')'];
    
    %freeze animal split
    %epochfilter{1} = [ '(isequal($type, ''sleep'')) & $epoch == 1 & $freezeAnimalSplit == 1 & $exposureday == ' num2str(day)]; 
    %epochfilter{2} = ['$shock == 1 & $freezeAnimalSplit == 1 & $exposureday == ' num2str(day)];
    %epochfilter{3} = ['(isequal($environment, ''lineartrack'') | isequal($environment, ''ctrack'') ) & $shock == 0 & $freezeAnimalSplit == 1 & $exposureday == ' num2str(day)];  
    %epochfilter{4} = [ '(isequal($type, ''sleep'')) & $epoch == 4 & $freezeAnimalSplit == 1 & $exposureday == ' num2str(day)];

    % w-tracks
    %epochfilter{1} = [ '(isequal($type, ''run'')) & $epoch == 5 & $exposureday == ' num2str(day)];
    %epochfilter{2} = [ '(isequal($type, ''run'')) & $epoch == 7 & $exposureday == ' num2str(day)];
    
    
    %% exclude times of ripples.
    %timefilter = { {'getlinvelocity', ['((abs($velocity) ',Veqn,'))'] } }; % only works for run epochs
    timefilter = { {'get2dstate', ['((abs($velocity) ',Veqn,'))'] } }; % works for run and sleep epochs BASELINE
    %timefilter{1} = {'getlinvelocity', ['((abs($velocity) ',Veqn,'))'] }; % only works for run epochs
    %timefilter{2} = {'get2dstate', ['((abs($velocity) ',Veqn,'))'] }; % works for run and sleep epochs
    %timefilter{1} = {'getlinstate', '(($traj ~= -1) & abs($velocity) > -1)', 6};
    %timefilter{2} = {['getestpos'] ['$freezing == ' num2str(freezeon)]};
    % timefilter = { {'getlinvelocity', ['((abs($velocity) ',Veqn,'))'] } };
    
    % freezing
    %timefilter = { {['getestpos'] ['$freezing == 0']} }; % only works for run session swith freezing defined.
    %timefilter{1} = {['getestpos'] ['$freezing == 0']}; % only works for run session swith freezing defined.
    %timefilter{2} = {'get2dstate', ['((abs($velocity) ',Veqn,'))'] }; % works for run and sleep epochs
    
    % pseudo freezing for sleep
    %timefilter = { {'get2dstate', ['(abs($velocity) < .05)'] } }; % works for run and sleep epochs
    
    % cellfilter for reactivated cells in ripple epoch
    cellfilter =['( (isequal($area, ''CA1'') | isequal($area, ''CA3'') ) && ($meanrate < ' num2str(maxmeanratePF) ') )'];
    %cellfilter =['(isequal($area, ''CA3'') && ($meanrate < ' num2str(maxmeanratePF) ') )'];
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
    %PFcellfilter =['(isequal($area, ''CA3'') && ($meanrate < ' num2str(maxmeanratePF) ') )'];

    PFepochfilter = [ '(isequal($type, ''run'')) & $exposureday == ', num2str(day)]; % exposureday, shock=1 or 0
    %PFepochfilter = [ '(isequal($type, ''run'')) & $exposureday < 5'];
    
    riptetfilter =  '(isequal($area, ''CA1'')) '; % riptetfilter is an arg for getripactivprob call to gettetmaxcell
    iterator = 'singlecellanal';
    
    % create filter for ripple/reactivation epoch
    %if i==2 | i==3 % run epoch
    f{i} = createfilter('animal',animals,'epochs',epochfilter,'cells',cellfilter,'excludetimefilter', timefilter, 'iterator', iterator);
    %elseif i==1 | i==4 % SLEEP: use below for SLEEP epochs.
    %    f{i} = createfilter('animal',animals,'epochs',epochfilter,'cells', cellfilter, 'iterator', iterator);
    %end
    
    f{i} = testexcludetimes(f{i}, mintime); %removes epochs from analysis if all epoch excluded by excludetimes, mintime = 30
    %f{i} = createfilter('animal',animals,'epochs',epochfilter,'cellpairs',cellpairfilter,'excludetimefilter', timefilterstage{i}, 'iterator', iterator);
    
    % only include cells with placefields
    %tmprefepoch = getfilterepochs(f{i}, PFincludeepochfilter);
    if minPeakPF > 0
        PFcells = calcPFcells(minVPF, minPeakPF, animals, PFepochfilter, 0, 'cellfilter', PFcellfilter);
        %f{i} = excludecellsf2(f{i}, PFcells, 'includeepochfilter', PFincludeepochfilter);
        f{i} = excludecellsfsubset(f{i}, PFcells, 'includeepochfilter', PFincludeepochfilter, 'subset', subset);
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
mf{m} = f;
end