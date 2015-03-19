function handle = barsem( groupA, groupB )
%handle = BARSEM( groupA, groupB )
%BARSEM plots bar graph with SEM as error bars
%   (derived from matlab script fear_cond_errorbars.m)
%
%   groups A and B are two groups (ie treatment and control)
%   rows are samples, columns are tested variables (ie
%   different days).


%figure;
%handle = gcf;

h = bar([nanmean(groupB); nanmean(groupA)]');
hold;
%errorbar([mean(cntrl); mean(shock)]',[std(cntrl); std(shock)]');

xdata = get(h,'XData');
sizz = size(xdata);
b = [nanmean(groupB); nanmean(groupA)]';
errdata = [sem(groupB); sem(groupA)]';

NumGroups = sizz(1);
SizeGroups = sizz(2);
NumBars = SizeGroups * NumGroups;

% Use the Indices of Non Zero Y values to get both X values
% for each bar. xb becomes a 2 by NumBars matrix of the X values.
xb = [];

for i = 1:SizeGroups
    try
xb = [xb; xdata{i}];
    catch
        xb = [xdata];
    end
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

