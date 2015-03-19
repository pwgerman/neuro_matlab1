% plotfreezelinpos

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

%clear f;
%Animal selection
%-----------------------------------------------------
%animals = {'Eliot'};
%-----------------------------------------------------
%day = 1;
%Veqn = '>-1';
%i =1;

%epochfilter = ['$shock == 1 & $exposureday == ' num2str(day)];

%timefilter{1} = {'getlinvelocity', ['((abs($velocity) ',Veqn,'))'] }; % only works for run epochs
%iterator = 'epochbehaveanal';
%f{i} = createfilter('animal',animals,'epochs',epochfilter,'excludetimefilter', timefilter, 'iterator', iterator);
%f{i}= setfilterfunction(f{i}, 'getripactivprob', {'spikes','ripples','task','cellinfo'} , riptetfilter, 'minnumspikes', minnumspikes, 'appendindex', 1);%
%f{i} = runfilter(f{i});


function out = inplotfreezelinpos(index, excludeperiods, linpos, estpos)
% out = inplotfreezelinpos(index, excludeperiods, linpos, estpos)
% a filter function
% Produces a cell structure with the fields:
% freezing time
%   
% and plots linear position by time, then saves the files.

%animal = animaldef('Bukowski', 'outputstruct', 1);
%estpos = loaddatastruct(animal.dir, animal.pre, 'estpos');
%linpos = loaddatastruct(animal.dir, animal.pre, 'linpos');

d = index(1,1);
e = index(1,2);


fztmp = estpos{d}{e}.data(:,10) == 1;
xtime = 1:length(linpos{d}{e}.statematrix.lindist);
if length(fztmp) > length(xtime)
    disp(['in plotfreezelinpos, fztmp exceeds xtime by ' num2str(length(fztmp) - length(xtime))]);
    fztmp = fztmp(1:length(xtime));
end


%{
fh = figure;
hold on;

subplot(1,1,1);
plot(linpos{d}{e}.statematrix.lindist);
scatter(xtime(fztmp) ,linpos{d}{e}.statematrix.lindist(fztmp), 'r');


% save output for adobe illustrator
picind = 4;
picpre = 'picture';
savedir = '/home/walter/Desktop/sfn2013-images/';
filenameout = [picpre, num2str(picind)];
print('-depsc','-r300',[savedir,filenameout,'.ai']);
print('-djpeg','-r300',[savedir,filenameout,'.jpg']);
%}

out.plotpath{1} = linpos{d}{e}.statematrix.lindist;
out.plotfreezetime = xtime(fztmp);
out.plotfreezepath = linpos{d}{e}.statematrix.lindist(fztmp);
out.freezetime = sum(estpos{d}{e}.data(:,10) == 1)/30;
