function [fout cout] = runriprate(varargin)
%function runriprate(varargin)
% runriprate('display', 1)

display = 0;
timelimit = 0; % 10
freezeon = 0;
shocktrackon = 0;

[otherArgs] = procOptions(varargin);

% Animal Selection 
animals = {'Bukowski', 'Cummings', 'Dickinson', 'Eliot', 'Jigsaw'};  

% Epoch Filter
epochfilter = [];
%epochfilter{1} = '(isequal($environment, ''ctrack''))';
%epochfilter{2} = '(isequal($environment, ''lineartrack''))';
%epochfilter{1} = '(isequal($environment, ''ctrack'')) & $exposure < 5';
%epochfilter{2} = '(isequal($environment, ''lineartrack'')) & $exposure < 5';
epochfilter{1} = ['(isequal($environment, ''ctrack'')) & $exposure <= 5 & $shock == ' num2str(shocktrackon)];
epochfilter{2} = ['(isequal($environment, ''lineartrack'')) & $exposure <= 5 & $shock == ' num2str(shocktrackon)];

% debugging filter settings for includetime output of calcriprate
%epochfilter{1} = '(isequal($environment, ''lineartrack'')) & $exposure ==1';
%epochfilter{2} = '(isequal($environment, ''lineartrack'')) & $exposure ==2';


% Time Filter
%timefilter = { {'getlinstate', '(($traj ~= -1) & abs($velocity) <=1)', 2} };
%timefilter = { {'getestpos', '$freezing == 1'} };
timefilter{1} = {'getlinstate', '(($traj ~= -1) & abs($velocity) <=.1)', 6};
timefilter{2} = {['getestpos'] ['$freezing == ' num2str(freezeon)]};


% Tetrode Filter
tetrodefilter = '(isequal($area, ''CA1''))';
%tetrodefilter = '(isequal($area, ''CA3''))';

% Iterator
iterator = 'multitetrodeanal'; %'eeganal'; %'epochbehaveanal'; %'multitetrodeanal';

% Filter Creation
f = createfilter('animal', animals, 'epochs', epochfilter, 'eegtetrodes', tetrodefilter, 'excludetime', timefilter, 'iterator', iterator);
%f = createfilter('animal', animals, 'epochs', epochfilter, 'eegtetrodes', tetrodefilter, 'iterator', iterator);

% Set Analysis Function
f = setfilterfunction(f, 'getriprate', {'ripples'}, 'appendindex',1);
%f = setfilterfunction(f, 'getriprate', {'ripples'});

% Run Analysis
f = runfilter(f);

% displayfilter() - this could be turned into a seperate function to call with other 
% data filter scripts...
if display
    disp('runriprate')
    disp(animals)
    disp([timefilter{:}])
    disp(tetrodefilter)
    for an = 1:size(f,2)
        disp(f(an).animal{1})
        disp(epochfilter{1})
        disp(f(an).output{1})
        disp(epochfilter{2})
        try
            disp(f(an).output{2})
        catch
        end
    end
end

%disp(epochfilter{1})
%disp(epochfilter{2})
%disp([timefilter{:}])

fout = f;

% NUMERICGROUPCOMBINE
tmpcout = numericgroupcombine(f);
for c = 1:length(tmpcout)
    cout{c} = removetestrows(tmpcout{c}, 7, timelimit);
end

%----------------------------------
function out = removetestrows(matrix, testcolumns, limit)
% out = REMOVETESTROWS(tmpcout, testcolumns, limit)
% tests the values of a column in a matrix.  Entire rows that excede the limit
% in that column are removed from the matrix.

for r=1:length(testcolumns)
    include = matrix(:,testcolumns(r))>=limit;
    out = matrix(include,:);
end


