% script for looking at raw ripples

%{
% example for Buk day 1 epoch 2 tetrode 3
cd /data18/walter/stress/Buk
ripplesP=load('Bukripples01.mat');
cd /data18/walter/stress/Buk/EEG
eeg = load('Bukeeg01-2-03.mat');

% to display info
fieldnames(eeg.eeg{1}{2}{3})
eeg.eeg{1}{2}{3}
fieldnames(ripplesP.ripples{1}{2}{3})
ripplesP.ripples{1}{2}{3}



samprate=ripplesP.ripples{1}{2}{3}.samprate;
starttime = eeg.eeg{1}{2}{3}.starttime;
samprate = eeg.eeg{1}{2}{3}.samprate;

% these are all the ripple start times
length(ripplesP.ripples{1}{2}{3}.starttime);

% plot raw eeg starting at ripple event and lasting 1 second
ripplesP.ripples{1}{2}{3}.starttime(4)
plot(eeg.eeg{1}{2}{3}.data(int32((ans-starttime)*samprate):int32((ans-starttime+1)*samprate)));

% could probably do it more easily with the index values
ripstart = ripplesP.ripples{1}{2}{3}.startind(4);
plot(eeg.eeg{1}{2}{3}.data(ripstart:ripstart+samprate));
% plot with x axis in seconds
plot([0:1/samprate:.4],eeg.eeg{1}{2}{3}.data(ripstart-150:ripstart+450));

ripstart = ripplesP.ripples{1}{2}{3}.startind;
plot(eeg.eeg{1}{2}{3}.data(ripstart(n):ripstart(n)+samprate));
% plot with x axis in seconds
plot([0:1/samprate:.4],eeg.eeg{1}{2}{3}.data(ripstart(n)-150:ripstart(n)+450));


%
cd /data18/walter/stress/Buk/EEG
ripeeg = load('Bukripple01-2-03.mat');









% example for Eli day 3 epoch 2 tetrode 3
cd /data18/walter/stress/Eli
ripplesP=load('Eliripples03.mat');
cd /data18/walter/stress/Eli/EEG
eeg = load('Elieeg03-2-03.mat');

d = 3 % day3
% to display info
fieldnames(eeg.eeg{d}{2}{3})
eeg.eeg{d}{2}{3}
fieldnames(ripplesP.ripples{d}{2}{3})
ripplesP.ripples{d}{2}{3}



samprate=ripplesP.ripples{d}{2}{3}.samprate;
starttime = eeg.eeg{d}{2}{3}.starttime;
samprate = eeg.eeg{d}{2}{3}.samprate;

% these are all the ripple start times
length(ripplesP.ripples{d}{2}{3}.starttime);

% plot raw eeg starting at ripple event and lasting 1 second
ripplesP.ripples{d}{2}{3}.starttime(4)
plot(eeg.eeg{d}{2}{3}.data(int32((ans-starttime)*samprate):int32((ans-starttime+1)*samprate)));

% could probably do it more easily with the index values
ripstart = ripplesP.ripples{d}{2}{3}.startind(4);
plot(eeg.eeg{d}{2}{3}.data(ripstart:ripstart+samprate));
% plot with x axis in seconds
plot([0:1/samprate:.4],eeg.eeg{d}{2}{3}.data(ripstart-150:ripstart+450));

ripstart = ripplesP.ripples{d}{2}{3}.startind;
plot(eeg.eeg{d}{2}{3}.data(ripstart(n):ripstart(n)+samprate));
% plot with x axis in seconds
plot([0:1/samprate:.4],eeg.eeg{d}{2}{3}.data(ripstart(n)-150:ripstart(n)+450));



% day 4 Eliot
d=3;
e=3;
t=4;
cd /data18/walter/stress/Eli
ripplesP =load(['Eliripples0' num2str(d) '.mat'],  'ripples');
cd /data18/walter/stress/Eli/EEG
eeg = load(['Elieeg0' num2str(d) '-' num2str(e) '-0' num2str(t) '.mat'],  'eeg');
ripeeg = load(['Eliripple0' num2str(d) '-' num2str(e) '-0' num2str(t) '.mat'],  'ripple');
samprate = eeg.eeg{d}{e}{t}.samprate;
ripstart = ripplesP.ripples{d}{e}{t}.startind;


plot([0:1/samprate:.4],eeg.eeg{d}{e}{t}.data(ripstart(n)-150:ripstart(n)+450));
plot([0:1/samprate:1],eeg.eeg{d}{e}{t}.data(ripstart(n)-750:ripstart(n)+750));

plot([0:1/samprate:1],ripeeg.ripple{d}{e}{t}.data(ripstart(n)-750:ripstart(n)+750));
% use the sort to find the largest ripples (b) and the index for them (ix)
[b,ix] = sort(ripplesP.ripples{d}{e}{t}.energy);
%}

%cd /data18/mkarlsso/Fra/


ripstart = ripFra.ripples{d}{e}{t}.startind;
ripend = ripFra.ripples{d}{e}{t}.endind;
ripdur = ripend-ripstart;

figure;
figpos = get(gcf, 'OuterPosition');
figpos(3) = 1600; %reset figure width
set(gcf, 'OuterPosition', figpos)

for n = 1:length(ripstart)
ha = line([0:1500],ripeegFra.ripple{d}{e}{t}.data(ripstart(n)-750:ripstart(n)+750));
hold on;
line([750:750+ripdur(n)],ripeegFra.ripple{d}{e}{t}.data(ripstart(n):ripend(n)), 'Color','r');
pause(.4);
%hold off;
cla;
end

