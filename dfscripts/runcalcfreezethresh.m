!% runcalcfreezethresh 
%
% by Walter German 2012-11-25
% Modified from runcalcnovelobjectbehavior.m created by Maggie

% Animal Selection
animals =  {'Bukowski'}; %{'Cummings','Dickinson'}; %{'Cummings'}; %{'Dickinson'};  %

% Epoch selection
%epochfilter{1} = '(isequal($environment, ''Ctrack''))';
epochfilter{1} = '(isequal($environment, ''lineartrack''))';

%Define iterator
iterator = 'epochbehaveanal'; %'w_epochbehaveanal'; no difference

%Define time filter
timefilter = {{'get2dstate', '($immobilitytime < 10)'}};

%f = createfilter('animal',animals,'epochs',epochfilter,'excludetime',timefilter,'iterator', iterator);
f = createfilter('animal',animals,'epochs',epochfilter,'iterator', iterator);
%f = setfilterfunction(f, 'calcfreezethresh', {'task','pos'}, 'threshold', -1); % to calculate optimal freeze times to match observed behavior
f = setfilterfunction(f, 'calcfreezethresh', {'task','pos'}, 'threshold', 0.3); % to calculate freeze times for a specific threshold
%f = setfilterfunction(f, 'calcfreezethresh', {'task','pos'}, 'threshold', .1:.1:.9); % to calculate freeze times for multiple thresholds
f = runfilter(f);

%% ANALYZE OUTPUT

% Look at percent time spent in each quadrant type for all minutes
thresh = []; accuracy = cell(1,2); avgthresh = []; estfreeze = [];
for an = 1:length(f)
    for d = 1:length(f(an).output)
        for e = 1:length(f(an).output{d})
            if f(an).output{d}(e).threshold ~= -1
                thresh = [thresh; (f(an).output{d}(e).threshold)];
                %accuracy = [accuracy; (f(an).output{d}(e).estaccuracy)];
                accuracy{1} = [accuracy{1} (f(an).output{d}(e).estaccuracy(:,1))];
                accuracy{2} = [accuracy{2} (f(an).output{d}(e).estaccuracy(:,2))];
                estfreeze = [estfreeze; (f(an).output{d}(e).estfreeze)];
            end
        end
    end
end

avgaccuracy = cell(1,2);
avgthresh = mean(thresh);
avgaccuracy{1} = mean(accuracy{1},2); % 2min freeze accuracy
avgaccuracy{2} = mean(accuracy{2},2); % 10min freeze accuracy


