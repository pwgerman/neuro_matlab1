function viewlinposexitenter(animalname, epoch)
% viewlinposexitenter(animalname, epoch)
% plot the linear trajectory of the animals path for each epoch, along with
% the entry and exit events to each well.  Currently only written to
% examine linear tracks.  Epochs are entered as [day epoch].  The current
% directory must be the data folder with linpos files.
% Example: viewlinposexitenter('Bukowski', [1 2]);

day = epoch(1);
e = epoch(2);
animal = animaldef(animalname, 'outputstruct', 1);
linpos = loaddatastruct(animal.dir, animal.pre, 'linpos', day);

maxdist = max(linpos{day}{e}.statematrix.lindist);
tickhight = 5;
exitalign = maxdist;
enteralign = 0;

fid = figure;
hold on;
plot(linpos{day}{e}.statematrix.lindist)
plot(diff(linpos{day}{e}.statematrix.wellExitEnter(:,1))*tickhight+exitalign, 'g');
plot(diff(linpos{day}{e}.statematrix.wellExitEnter(:,2))*5+enteralign, 'r');
legend('lindist', 'exit', 'enter', 'Location', 'Best');
legend BOXOFF;
xlabel('time (s)');
ylabel('distance (cm)');
title([animalname ', day' num2str(day) ', epoch' num2str(e)]); 
