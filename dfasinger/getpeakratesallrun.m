function allrunPKgroup = getpeakratesallrun(minV, animals, epochfilter, varargin)
% allrunPKgroup = getpeakratesallrun(minV, animals, epochfilter, varargin)
% gets peak of linear firing rate for all excitatory cells.  The varargin
% must be two arguments, a string declaring a cellfilter, and a cellfilter
% that defines the inclusion criteria. 
% minV: minimum velocity to include timepoint (a scalar value)
% 
% Example: 
%       minV = 4;
%       animals = {'Barack', 'Calvin', 'Dwight'};
%       epochfilter = ['(isequal($environment, ''lineartrack'')) & $exposure == 1'];
%       cellfilter ='( (isequal($area, ''CA1'') | isequal($area, ''CA3'') ) && ($meanrate < 4) )';
%   allrunPKgroup = getpeakratesallrun(minV, animals, epochfilter, 'cellfilter', cellfilter);
%
% written by asinger, modified by walter

%Animal selection
%-----------------------------------------------------
%animals = {'Barack', 'Calvin', 'Dwight'};
%animals = {'Barack', 'Calvin', 'Dwight'};
%-----------------------------------------------------


%Filter creation
%--------------------------------------------------------
%just analyze days where switching between tasks
%epochfilter{1} = ['($switchday < 30) ']; %just analyze days where switching between tasks

%default cell filter
cellfilter = [];
%cellfilter ='(isequal($area, ''CA3'') && ($meanrate < 4))'  ; %CA3 excitatory cells, used runplotavgrate to see distributions for each animal

procOptions(varargin{1}); % change cellfilter
if isempty(cellfilter)
    error('varargin must define the cellfilter.  ''help getpeakratesallrun'' for more info.')
end
% cellfilter options in original version of this code
%{
if isequal(varargin{1}, {'CA1'})
    cellfilter ='(isequal($area, ''CA1'') && ($meanrate < 4))'  ; %CA1 excitatory cells, used runplotavgrate to see distributions for each animal
elseif isequal(varargin{1}, {'CA3CA1'}) || isequal(varargin{1}, {'CA1CA3'})
    cellfilter ='( (isequal($area, ''CA1'') | isequal($area, ''CA3'') ) && ($meanrate < 4) )'  ; %all areas
end
%}
    
%timefilterstage = { {'getlinvelocity', ['((abs($velocity) >= ', num2str(minV), '))'] } {'getriptimes','($nripples == 0)', [], 'cellfilter', '(isequal($area, ''CA1''))','minthresh',3}};
timefilterstage = { {'getlinvelocity', ['((abs($velocity) >= ', num2str(minV), '))'] } };

%allrunpeakratef = createfilter('animal',animals,'epochs',epochfilter,'excludetime', timefilterstage);
allrunpeakratef = createfilter('animal',animals,'epochs',epochfilter,'cells',cellfilter,'excludetime', timefilterstage);
%-----------------------------------------------------------
%*rungetripactivprob f{i} = createfilter('animal',animals,'epochs',epochfilter,'cells',cellfilter,'excludetimefilter', timefilter, 'iterator', iterator); ** just for comparison with create
%filter here

%run function- single cells
%--------------------------------------------
iterator = 'singlecellanal';

allrunpeakratef = setfilteriterator(allrunpeakratef,iterator);

allrunpeakratef = setfilterfunction(allrunpeakratef, 'calcpeakrate2', {'spikes', 'linpos'},'appendindex',1); %already have a calcpeakrate function that is not compatible with this anal --> renamed mattias' function calcpeakrate2

allrunpeakratef = runfilter(allrunpeakratef);

allrunPKgroup = numericgroupcombine(allrunpeakratef, 1);  %if output numeric, this combines across animals, first col is animal
