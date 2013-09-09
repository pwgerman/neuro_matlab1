function [peaks, cuts] = spike_peaks(waves, startlength, peak_length)

% spike_peaks accepts input waves(:,x,:) which is the wave for only one
% of the four tetrode channels at a time.

%{
cd /data18/walter/stress/Eliot/Eliot_03
set(0, 'DefaultLineLineWidth', [1] );
%}

earlypeak = 8;
latepeak = 13;

num = size(waves, 3); %10000; restrict number of waves analyzed
% numdisp = 100;

[c,i]=max(waves(:,1,1:num),[],1); % to find peak anywhere
i = reshape(i,1,[]);

[c,icntr]=max(waves(earlypeak:latepeak,1,1:num),[],1); % to find peak in center
icntr = reshape(icntr,1,[]);
icntr = icntr+ earlypeak-1;

%idist = hist(i,40);
% 92% of spikes peak on interval of i= 8:13
% code to visualize spike peaks that are centered or not.
% outside of 8:13, the waves look like noise.

%{
cmap= colormap(lines);
figure; hold;
color = 1;
for s =  n( i(1:numdisp)>=8 & i(1:numdisp)<=13 ) %n( i(1:10)>13)
plot(waves(:,1,s),'Color',cmap(color,:));
color = color+1;
end
%}


% center peaks and cut ends of waveforms
%peak_length = 20; %wave with total of 20 points = 2msec
% i is vector of spike centers
n = 1:num;
ipeaks = n( i>=earlypeak & i<=latepeak ); % index of waves that have peak at center
wstart = i(ipeaks) - startlength; % start wave 6*.1ms = .6msec before peak
wend = wstart + peak_length-1; % end wave with total of 20 points = 2msec
wcentered = waves(:,1,ipeaks);
wcentered = reshape(wcentered(:,1,:),40,[]);

% The following subroutine takes too long will large matrices
%{ 
wcentercut = [];
for c = 1: length(wstart)
    wcentercut = [wcentercut wcentered(wstart(c):wend(c),c)];
end
%}
wcentercut = zeros(20,size(wcentered,2));
for itis = min(wstart):max(wstart)
    index = n(wstart==itis);
    wcentercut(:,index) = wcentered(itis:itis+peak_length-1,index);
end

wcentercut = double(wcentercut);
npeak = wcentercut./repmat(max(wcentercut),20,1); % normalize peak

%mpeak = wcentercut - repmat(mean(wcentercut),20,1);
% nmpeak = max(mpeak);
% nmpeak = mpeak./repmat(max(mpeak),20,1);
% plot(nmpeak(:,1:100));


% calculate highest point on remaining waves and align on those, so all
% waves aligned by hightest point from period of 8:13, even if that inderval 
% does not include the highest point in a given wave.

fullstart = icntr - startlength; % start wave 6*.1ms = .6msec before peak
fullcentered = waves(:,1,:);
fullcentered = reshape(fullcentered(:,1,:),40,[]);

fullcut = zeros(20,size(fullcentered,2));
for itis = min(fullstart):max(fullstart) % restrict to centering on main peak area
    index = n(fullstart==itis);
    fullcut(:,index) = fullcentered(itis:itis+peak_length-1,index);
end
fullcut = double(fullcut);
fullnpeak = fullcut./repmat(max(fullcut),20,1); % normalize peak

cuts = fullcut;  % fullnpeak
peaks = wcentercut; % npeak

% plot(npeak(:,1:100));
% plot(wcentercut(:,1:100));
% plot(mpeak(1:100));