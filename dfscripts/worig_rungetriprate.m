% rungetriprate.m
% generates ripple rate for different speeds using filter framework to specify parameters.

% Animal selection

animals = {'Bukowski', 'Cummings', 'Eliot', 'Jigsaw'}; %{'Bukowski'}; %{'Bukowski', 'Eliot'}; %{'Dickinson'};%
days= 1:5; %1:5

maxmeanratePF = 2; % maximum mean rate of cells in reactivation epoch
ripthresh = 5; % currently does nothing, will pass to getriprate...
minriptet = 2;

rerunfiltfun = 1;
minfreeze = 100;%100
plotgroups = [ 2];

    
% Epoch selection ('g', 'group')
epochfilter{1} = ['$shock == 1 & ismember($exposureday, [' num2str(days) '])'];
epochfilter{2} = ['$control == 1 & ismember($exposureday, [' num2str(days) '])'];

% Tetrode selection
tetrodefilter = '(isequal($area, ''REF''))'; % or use reference tetrode? REF
riptetfilter =  '(isequal($area, ''CA1''))';
cellfilter =['( (isequal($area, ''CA1'') | isequal($area, ''CA3'') ) &&'...
    ' ($meanrate < ' num2str(maxmeanratePF) ') )'];

% Time selection
%NOT(frz=1)
timefilter{1} = { {'getestpos', ['(abs($freezing) == 1)']} }; %NOT(frz=1) 
%NOT((vel<2)&(frz=0))
timefilter{2} = { {'get2dstate', ['((abs($velocity) <= 2))'] },...
   {'getestpos', ['(abs($freezing) == 0)']} }; % result is NOT((vel<2)&(frz=0))


% Iterator selection
iterator = 'multitetrodeanal'; 

if rerunfiltfun % recalculate values
    % Create and Run Filter
    for jj = 1:length(timefilter)
        f{jj} = createfilter('animal',animals,'epochs',epochfilter,...
            'excludetime',timefilter{jj},'eegtetrodes', riptetfilter,...
            'iterator', iterator);
        f{jj} = setfilterfunction(f{jj}, 'getriprate', {'ripples'}, 'numtetrodes', minriptet, 'minthresh', ripthresh, 'appendindex',1 ); 
        f{jj} = runfilter(f{jj});
         %    'eegtetrodes',riptetfilter );
        
    end
end

% Analyze Output
ripfrz = [];
ripslw = [];
frztime = [];

for an = 1:length(animals);
    animal = animaldef(animals{an}, 'outputstruct', 1);
    tetinfo = loaddatastruct(animal.dir, animal.pre, 'tetinfo');
    
    if isequal(animal.name, 'Dickinson')
        tmpdays = intersect(days, 1:3);
    else
        tmpdays = days;
    end
    
    frztime{an}.shock = getfreezetimes(animal.name,'output', 'shock');
    frztime{an}.control = getfreezetimes(animal.name,'output', 'control');
    %frztime.shock(d)
    for g = 1:length(epochfilter);
        for d  = tmpdays;
            index = f{1}(an).epochs{g}(d,:);
           %maxtrodes = length(f{1}(an).speedeegdata{g}{d});
            %for tet = 1:maxtrodes;
               
                % output of getriprate
                % [riprate proportiontime includetime] index+3 if
                % appendindex
                riprate(1) = f{1}(an).output{g}(d,4); % freeze=1 riprate
                riprate(2) = f{2}(an).output{g}(d,4);
                
              
                
                if (frztime{an}.shock(d)>minfreeze) %|| (frztime{an}.control(d)>minfreeze)
                    format shortG;
                    %ripfrz = [ripfrz; f{1}(an).output{g}(d,:)];
                    %ripslw = [ripslw; f{2}(an).output{g}(d,:)];
                    %sortrows(ripslw, 2); % sort by epoch, but this
                    %   alternates for each day for all animals.a
                    if ismember(g,plotgroups)
                        ripfrz = [ripfrz; f{1}(an).output{g}(d,4)];
                        ripslw = [ripslw; f{2}(an).output{g}(d,4)];
                    end
                end
                
            %end
        end
    end
end
figure
hold on;
scatter(ripslw, ripfrz);
plot([0 1], [0, 1],'r')
xlabel('rip rate, slow vel');
ylabel('rip rate, freeze');
titlestr = sprintf('control track, freezingtime>100, thresh=5std, vel<2');
%titlestr = sprintf('shock & control track');
title(titlestr);

