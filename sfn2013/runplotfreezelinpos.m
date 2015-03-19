% runplotfreezelinpos

%figdefaults;

%animal = animaldef('Bukowski', 'outputstruct', 1);
%estpos = loaddatastruct(animal.dir, animal.pre, 'estpos');
%linpos = loaddatastruct(animal.dir, animal.pre, 'linpos');

%linpos{1}{2}.statematrix.lindist

%plot(linpos{1}{2}.statematrix.lindist)

%plot(linpos{1}{2}.statematrix.wellExitEnter(:,2), 'r');

% freezing episodes
%plot(estpos{1}{2}.data(:,10))
%plot(estpos{1}{3}.data(:,10))



clear f;
epout = []; % clear estpos freezing output array
%Animal selection
%-----------------------------------------------------
%animals = {'Eliot'};
animals = {'Bukowski','Cummings','Dickinson','Eliot','Jigsaw'};
%-----------------------------------------------------
day = 4;
Veqn = '>-1';
i =1;

% save file info
picind = day;
%picpre = 'shockfreezepath';
picpre = 'controlfreezepath';
savedir = '/home/walter/Desktop/sfn2013-images/';
filenameout = [picpre, num2str(picind)];

%epochfilter = ['$shock == 1 & $exposureday == ' num2str(day)];
epochfilter = ['(isequal($environment, ''lineartrack'') | isequal($environment, ''ctrack'') ) & $shock == 0 & $exposureday == ' num2str(day)];
timefilter{1} = {'getlinvelocity', ['((abs($velocity) ',Veqn,'))'] }; % only works for run epochs
iterator = 'epochbehaveanal';
f{i} = createfilter('animal',animals,'epochs',epochfilter,'excludetimefilter', timefilter, 'iterator', iterator);
f{i}= setfilterfunction(f{i}, 'plotfreezelinpos', {'linpos','estpos'});%
f{i} = runfilter(f{i});

% plot output
fh = figure;
hold on;

numplot = length(f{i});
%numplot = length(f{i}.output{1});
numcol = ceil(sqrt(numplot));
numrow = ceil(numplot/numcol);
for an = 1:numplot
    if ~isempty(f{i}(an).output)
        n = 1; %used for multiple days
        subplot(numrow,numcol,an);
        hold on;
        plot(f{i}(an).output{1}(n).plotpath{1});
        %plot(f{i}.output{1}.plotpath);
        %fztmp = estpos{d}{e}.data(:,10) == 1;
        %xtime = 1:length(linpos{d}{e}.statematrix.lindist);
        scatter(f{i}(an).output{1}(n).plotfreezetime ,f{i}(an).output{1}(n).plotfreezepath, 'r');
        
        epout = [epout f{i}(an).output{1}(n).freezetime];
    end
end

% save output for adobe illustrator
%print('-depsc','-r300',[savedir,filenameout,'.ai']);
%print('-djpeg','-r300',[savedir,filenameout,'.jpg']);


