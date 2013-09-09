function handle = barsem( groupA, groupB )
%BARSEM plots bar graph with SEM as error bars
%   This is derived from matlab script fear_cond_errorbars.m
%   created by Walter German on Aug 16, 2011
%   groups A and B are two conditions (treatment and control)
%   rows are repeated measures (ie each animal), columns are conditions (ie
%   different days.


%load fear_cond
shock = groupA;
cntrl = groupB;

figure;
handle = gcf;

h = bar([mean(cntrl); mean(shock)]');
hold;
%errorbar([mean(cntrl); mean(shock)]',[std(cntrl); std(shock)]');

xdata = get(h,'XData');
sizz = size(xdata);
b = [mean(cntrl); mean(shock)]';
%errdata = [std(cntrl); std(shock)]';
errdata = [sem(cntrl); sem(shock)]';

NumGroups = sizz(1);
SizeGroups = sizz(2);
NumBars = SizeGroups * NumGroups;

% Use the Indices of Non Zero Y values to get both X values
% for each bar. xb becomes a 2 by NumBars matrix of the X values.
xb = [];

for i = 1:SizeGroups
xb = [xb; xdata{i}];
end

centerX = xb(1,:)-.15;
centerX = [centerX; xb(1,:)+.15];

eh = errorbar(centerX',b,errdata);

%set(eh(1),'linewidth',2); % This changes the thickness of the errorbars

set(eh(1),'color','k'); % This changes the color of the errorbars
set(eh(2),'color','k'); % This changes the color of the errorbars

set(eh(1),'linestyle','none'); % This removes the connecting line
set(eh(2),'linestyle','none'); % This removes the connecting line


end

