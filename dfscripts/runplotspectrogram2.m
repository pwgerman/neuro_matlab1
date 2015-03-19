% runplotspectrogram2
% Script for spectrogram
% runplotspectrogram2 calls runplotspectrogram.m and saves the 'f' after amking a log plot of a tetrode in an epoch.

% create spectrogram and save
tic; runplotspectrogram; toc
SS = f.output{1}(1).fullspectrum;
TT = f.output{1}(1).time;
FF = f.output{1}(1).frequency;
imagesc(TT, FF, log(SS'));
ylim([0 15]);

axis xy  % set(gca,'YDir','reverse');
hold on

animal = animaldef('Eliot', 'outputstruct', 1);
estpos = loaddatastruct(animal.dir, animal.pre, 'estpos');
freeze = estpos{4}{3}.data(:,10);
frztime = estpos{4}{3}.data(:,1);
plot(frztime, freeze, 'LineWidth' , 4)

% save output
cd /mnt/backup/walter/walter/phys/Spec/
%save -v7.3 spectro-CA1-shock-ctrl-buk.mat f;
%save -v7.3 spectro-CA1-shock-ctrl-dic.mat f;
save -v7.3 spectro-CA1-shock-ctrl-jig.mat f;