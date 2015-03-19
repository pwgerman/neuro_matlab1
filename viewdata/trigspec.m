function [x,y]=trigspec(f, group, epoch)% triggered spectrograms
%
% trigspec has 2 effects.  The first, commented out, plots
% the histograms of freq w/ z-scores > 4.  The second send output of times
% of high z-scores.  
%
% the base spectrograms analyzed are segmented into 50 msec bins. and .9 Hz
% frequency bins.  This script will index these bins by velocity or
% freezing and compare the frequency ranges of high and low theta.

%cd /mnt/data18/walter/phys/Spec;
%load spectro-CA1-shock-ctrl-cum.mat;

g = group;
e = epoch;

index = f.output{g}(e).index; 
freq = f.output{g}(e).frequency;
time = f.output{g}(e).time;
spect = f.output{g}(e).fullspectrum;
zspect = zscore(spect, 0,1); % what happens with change of dim?

animalname = f.animal{1};
animal = animaldef(animalname, 'outputstruct', 1);

estpos = loaddatastruct(animal.dir, animal.pre, 'estpos');
frztimes = estpos{index(1)}{index(2)}.data(:,10);
postimes = estpos{index(1)}{index(2)}.data(:,1);
vel = estpos{index(1)}{index(2)}.data(:,5);

% the cutoff of 4SD looks significant based on the observation of this
%figure('WindowStyle', 'docked');
%hist(zspect(:))
%tmpindex = sum(zspect>=4,1); % what happens if calculated below? why???

% lots of effects at frequencies below 4Hz, so get rid of those as not of
% interest (for now...)
foi = find(freq>=2); % Frequency Of Interest
freq = freq(foi);
zspect = zspect(:,foi);

% take the frequencies that have a number of unusual events to see the 
% frequencies that are the most active.

% different result if tmpindex is calculated on zspect of only foi.
% Why????
tmpindex = sum(zspect>=4,1); % sum events across all times in a frequency

% optional display shows a range of differences between tetrodes and epochs
%hist(zscore(tmpindex));

%out = freq(zscore(tmpindex)>=2); % 2 what frequencies are showing biggest changes?
%freq(tmpindex>=150); % what frequencies have a large count?

% average across many animals, but divide into shock control
% look at times indexed by freezing or velocity (isExcluded)

% now break down by times in frequencis of interest
% theta1 = 7-9 Hz; theta2 = 4-6 Hz (sometimes reported as 4-7Hz type2)

% renew variables

freq = f.output{g}(e).frequency;
time = f.output{g}(e).time;
spect = f.output{g}(e).fullspectrum;
zspect = zscore(spect, 0,1); % what happens with change of dim?

clear foi;
foi = find(freq>=4 & freq<=6); % Frequency Of Interest
[x,y] = viewfreq(freq, foi, zspect, time, 1);
hold on;
foi = find(freq>=7 & freq<=9);
[jx,jy] = viewfreq(freq, foi, zspect, time, 1.5);
%set(gca, 'ylim',[0 10]);

%plot(postimes, frztimes, 'r')
%plot(postimes, log(vel),'m');

end

function [x,y]=viewfreq(freq, foi, zspect, time, plotheight)

tmpzspect = zspect(:,foi); % zscores from frequencies of interst
ztimes = (sum(tmpzspect>=4,2)); % should collaps all events into a time vector.
% then compare that time vector with velocity and freezing at same time.
% look at other animals and compare control.
%x = find(ztimes);
x = time(find(ztimes));
y = ones(size(x))*plotheight;
%scatter(x,y);

end
