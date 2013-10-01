function [handle, hb] = barsem2(group)
%handle = BARSEM2( groupA, groupB )
%BARSEM2 plots bar graph with SEM as error bars
%   (derived from matlab script fear_cond_errorbars.m)
%
%   groups A and B are two groups (ie treatment and control)
%   rows are samples, columns are tested variables (ie
%   different days).

groupA = group{1};
groupB = group{2};

meanstr = [];
semstr = [];
for g = 1:length(group)
    meanstr = [meanstr; mean(group{g})];
    semstr = [semstr; sem(group{g})];
end

figure;
handle = gcf;

%h = bar([mean(groupB); mean(groupA)]', 'BarWidth', .5);
hb = bar(meanstr', 'BarWidth', .5, 'FaceColor', 'w');

hold;
%errorbar([mean(cntrl); mean(shock)]',[std(cntrl); std(shock)]');

xdata = get(hb,'XData');
sizz = size(xdata);
%b = [mean(groupB); mean(groupA)]';
errdata = [sem(groupB); sem(groupA)]';

NumGroups = sizz(1);
SizeGroups = sizz(2);
NumBars = SizeGroups * NumGroups;

% Use the Indices of Non Zero Y values to get both X values
% for each bar. xb becomes a 2 by NumBars matrix of the X values.
xb = [];

for i = 1:SizeGroups
xb = [xb; xdata(1)];
end

%centerX = xb(1,:)-.15;
%centerX = [centerX; xb(1,:)+.15];
centerX = 1:length(group); %[1 2];

%eh = errorbar(centerX',b,errdata);
eh = errorbar(centerX',meanstr, semstr);

for i = 1:length(eh)
set(eh(i),'color','k'); % This changes the color of the errorbars
set(eh(i),'linestyle','none'); % This removes the connecting line
set(eh(i),'linewidth',2); % This changes the thickness of the errorbars
end


end

