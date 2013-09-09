%plotcalclinfields
%
%Code modified from plotrunepochs

% set these variables before evaluating and run this in the animal's processed directory
% (example: '/data13/mcarr/thr'). Set epoch equal to the last linearized
% run.

fileprefix = 'Eli'; %'thr';

day=3;
epoch=2;
tetrode=2;
cluster=3;

index = [day epoch tetrode cluster]; % [day epoch tetrode cell]
binsize = 2.5;
std = 2;
   
% load spikes, pos, linpos, task for day
eval(['load ',fileprefix,'spikes','0',num2str(index(1)), '.mat']);
eval(['load ',fileprefix,'pos','0',num2str(index(1)), '.mat']);
eval(['load ',fileprefix,'linpos','0',num2str(index(1)), '.mat']);
eval(['load ',fileprefix,'task','0',num2str(index(1)), '.mat']);

% determine size of data
num_tetrodes = size(spikes{day}{epoch},2);

for t = 1:num_tetrodes; % tetrode

    if ~isempty(spikes{index(1)}{index(2)}{t})
num_clusts = size(spikes{day}{epoch}{t},2);
if num_clusts > 8
    disp(['tetrode ' num2str(t) ' has ' num2str(num_clusts) ' clusters']);
    disp('only the first 8 clusters are plotted');
    num_clusts = 8;
end

state = cell(1,num_clusts);
lindist = cell(1,num_clusts);
trajdata = cell(1,num_clusts);

%run getbehave state, calclinfields, and twodoccupancy maps
%[state lindist] = getbehavestate(linpos, index(1), index(2), 1);
%trajdata = calclinfields(spikes, state, lindist, linpos, [index(1) index(2) index(3) index(4)]);

figure;
subplot(4,4,1);
title(['tetrode ' num2str(t)]);
for c = 1: num_clusts % cluster
    index = [day epoch t c]; % [day epoch tetrode cell]

    if ~isempty(spikes{index(1)}{index(2)}{index(3)}{c})
[state{c} lindist{c}] = getbehavestate(linpos, index(1), index(2), 1);
trajdata{c} = calclinfields(spikes, state{c}, lindist{c}, linpos, [index(1) index(2) index(3) c]);
 
%[output] = twodoccupancy(spikes,state, linpos, pos, [index(1) 2 index(3) index(4)]);

% plot the trajdata linearized firing rates and the twodoccupancy pictures

ind1= 2*(c-1)+1;
ind2= 2*(c-1)+2;
subplot(4,4,ind1); plot(trajdata{c}{1}(:,5))
title(['tet' num2str(t) ' c' num2str(c)]);
%subplot(2,4,2); imagesc(output(1).smoothedspikerate)
subplot(4,4,ind2); plot(trajdata{c}{2}(:,5))
%subplot(2,4,4); imagesc(output(2).smoothedspikerate)

    end
end
    end
end

%{
subplot(2,4,5); plot(trajdata{3}(:,5))
subplot(2,4,6); imagesc(output(3).smoothedspikerate)
subplot(2,4,7); plot(trajdata{4}(:,5))
subplot(2,4,8); imagesc(output(4).smoothedspikerate)
%}

%{
if max(epoch==4)
    figure;
    subplot(1,2,1); plot(pos{index(1)}{2}.data(:,2), pos{index(1)}{2}.data(:,3), 'x')
        hold on; plot(spikes{index(1)}{2}{index(3)}{index(4)}.data(:,2), spikes{index(1)}{2}{index(3)}{index(4)}.data(:,3), 'rx')
    subplot(1,2,2); plot(pos{index(1)}{4}.data(:,2), pos{index(1)}{4}.data(:,3), 'x')
        hold on; plot(spikes{index(1)}{4}{index(3)}{index(4)}.data(:,2), spikes{index(1)}{4}{index(3)}{index(4)}.data(:,3), 'rx')

    [state2 lindist2] = getbehavestate(linpos, index(1), 4, 1);
    trajdata2 = calclinfields(spikes, state2, lindist2, linpos, [index(1) 4 index(3) index(4)]);
    [output2] = twodoccupancy(spikes,state2, linpos, pos, [index(1) 4 index(3) index(4)]);
    [output3] = openfieldoccupancy(spikes, pos, [index(1) 6 index(3) index(4)], binsize, std);
    
    figure;
    subplot(1,2,1); imagesc(output3.smoothedspikerate)
    subplot(1,2,2); plot(pos{index(1)}{6}.data(:,2), pos{index(1)}{6}.data(:,3), 'x')
        hold on; plot(spikes{index(1)}{6}{index(3)}{index(4)}.data(:,2), spikes{index(1)}{6}{index(3)}{index(4)}.data(:,3), 'rx')
    
    figure;
        subplot(2,4,1); plot(trajdata2{1}(:,5))
        subplot(2,4,2); imagesc(output2(1).smoothedspikerate)
        subplot(2,4,3); plot(trajdata2{2}(:,5))
        subplot(2,4,4); imagesc(output2(2).smoothedspikerate) 
        %{
        subplot(2,4,5); plot(trajdata2{3}(:,5))
        subplot(2,4,6); imagesc(output2(3).smoothedspikerate)
        subplot(2,4,7); plot(trajdata2{4}(:,5))
        subplot(2,4,8); imagesc(output2(4).smoothedspikerate)
        %}
else
    % plot the open field occupancy normalized spike rate
    figure;
    plot(pos{index(1)}{2}.data(:,2), pos{index(1)}{2}.data(:,3), 'x')
        hold on; plot(spikes{index(1)}{2}{index(3)}{index(4)}.data(:,2), spikes{index(1)}{2}{index(3)}{index(4)}.data(:,3), 'rx')

    [output2] = openfieldoccupancy(spikes, pos, [index(1) 4 index(3) index(4)], binsize, std);
    figure;
    subplot(1,2,1)
    imagesc(output2.smoothedspikerate)
    subplot(1,2,2)
    plot(pos{index(1)}{4}.data(:,2),pos{index(1)}{4}.data(:,3),'x')
    hold on
    plot(spikes{index(1)}{4}{index(3)}{index(4)}.data(:,2), spikes{index(1)}{4}{index(3)}{index(4)}.data(:,3), 'rx')
end

%}
