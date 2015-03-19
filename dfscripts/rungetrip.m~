% rungetrip.m
% generates ripples for different speeds using filter framework to specify parameters.
% calls getrip for filter function
%
%   This code started as a copy of runcalcspeedeeg.m and cut out the filter
%   function call to calcspeedeeg to be exclusively for getrip2.m as the
%   filter function.  

% Animal selection

animals = {'Bukowski'}; %{'Bukowski', 'Cummings', 'Eliot', 'Jigsaw'}; %{'Bukowski'}; %{'Bukowski', 'Eliot'}; %{'Dickinson'};%
days= 1; %1:5
eegfilter = 't2theta';
maxmeanratePF = 4; % maximum mean rate of cells in reactivation epoch
ripthresh = 5; % currently does nothing, will pass to getriprate...
minriptet = 2;

rerunfiltfun = 1;
minfreeze = 0;%100;

    
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
iterator = 'multitetrodeanal'; %'eeganal' does not pass pos

if rerunfiltfun % recalculate values
    % Create and Run Filter
    for jj = 1:length(timefilter)
        f{jj} = createfilter('animal',animals,'epochs',epochfilter,...
            'excludetime',timefilter{jj},'eegtetrodes', tetrodefilter,...
            'iterator', iterator);
        f{jj} = setfilterfunction(f{jj}, 'getrip2', {'spikes','ripples','task','cellinfo'},cellfilter,'appendindex',1); %getestpos
        f{jj} = runfilter(f{jj});
        %('cells',cellfilter); %singlecellanal
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
           % for tet = 1:maxtrodes;
           %{
                oindex = (d-1)*maxtrodes + tet;
                tetnum = f{1}(an).eegdata{g}{d}(tet);
                numcells = tetinfo{index(1)}{index(2)}{tetnum}.numcells;
                tmpf{2} = f{2}(an).outputeeg{g}(oindex).eegenv;
                tmpf{1} = f{1}(an).outputeeg{g}(oindex).eegenv;
             %}   
                ripind = 4;% the column of ripnum returned from getrip2
                %rips(1) = f{1}(an).output{g}(d).numrip(ripind);
                %rips(2) = f{2}(an).output{g}(d).numrip(ripind);
                
                % output of getrip2
                %{
                rips(1) = sum(f{1}(an).output{g}(d).thresh > ripthresh);
                rips(2) = sum(f{2}(an).output{g}(d).thresh > ripthresh);
                riprate(1) = rips(1)*1000/length(tmpf{1});
                riprate(2) = rips(2)*1000/length(tmpf{2});
                %}
                
                % output of getriprate
                % [riprate proportiontime includetime] index+3 if
                % appendindex
                riprate(1) = f{1}(an).output{g}(d,4); % freeze=1 riprate
                riprate(2) = f{2}(an).output{g}(d,4);
                
                %if ismember(tetnum, tetlist{an})
                %{
                    disp(sprintf(...
                        'grp%d, tet%02d    slow %03.2f   freeze %03.2f    cells%d    numfrz%05.0f',...
                        g, tetnum, sum(tmpf{2})/length(tmpf{2}),...
                        sum(tmpf{1})/length(tmpf{1}), numcells, length(tmpf{1}) ));
                %}
                %disp(sprintf('ripple  %f   %f   freq   %f    %f    diff %f', rips(2), rips(1), riprate(2), riprate(1), diff(riprate) ));
                
                %disp(sprintf('an %d grp %g day %d  riprate  frz %02.2f   ctl %02.2f    diff %02.2f', an, g, d, riprate(2), riprate(1), diff(riprate) ));
                %end
                
                if (frztime{an}.shock(d)>minfreeze) %|| (frztime{an}.control(d)>minfreeze)
                    format shortG;
                    %ripfrz = [ripfrz; f{1}(an).output{g}(d,:)];
                    %ripslw = [ripslw; f{2}(an).output{g}(d,:)];
                    %sortrows(ripslw, 2); % sort by epoch, but this
                    %   alternates for each day for all animals.a
                    if g == 2
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
scatter(ripfrz, ripslw)
plot([0 1], [0, 1],'r')

