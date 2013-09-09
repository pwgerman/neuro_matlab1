% fear_cond_errorbars.m

%load fear_cond

load fear_cond_KLMNO.mat;

cntrlbar = cntrlKLMNO;
shockbar = shockKLMNO;

figure;
h = bar([mean(cntrlbar); mean(shockbar)]');
hold;
%errorbar([mean(cntrlbar); mean(shockbar)]',[std(cntrlbar); std(shockbar)]');

xdata = get(h,'XData');
sizz = size(xdata);
b = [mean(cntrlbar); mean(shockbar)]';
%errdata = [std(cntrlbar); std(shockbar)]';
errdata = [sem(cntrlbar); sem(shockbar)]';

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


FontSa = 32; % title font size
FontSb = 28; % label font size
FontSc = 24; % tick font size

%set(eh(1),'linewidth',2); % This changes the thickness of the errorbars

set(eh(1),'color','k'); % This changes the color of the errorbars
set(eh(2),'color','k'); % This changes the color of the errorbars

set(eh(1),'linestyle','none'); % This removes the connecting line
set(eh(2),'linestyle','none'); % This removes the connecting line

set(eh(1),'LineWidth', 2); % This removes the connecting line
set(eh(2),'LineWidth', 2); % This removes the connecting line

title('Fear Conditioning', 'FontSize', FontSa);
xlabel('day', 'FontSize', FontSb);
ylabel('freezing time (s)', 'FontSize', FontSb);
%axes( 'FontSize', 10);
ha = gca;
set(ha,'FontSize', FontSc, 'FontWeight', 'Bold');
axis([.5 3.5 0 500]);
hlegend = legend('control track', 'shock track');
set(hlegend, 'Box', 'off');
set(gca, 'YTick', (0:100:500));

saveas(gcf,'Fear_Cond_Ext_KLM_3day.jpg'); % best for direct export to MS PPT
%saveas(gcf,'Fear_Cond_Ext_KLM_3day.ai'); older format no longer supported
%by matlab

% .eps can be edited in ai then exported as MS Office (png) file
% save file command with 'print'
print -depsc2 -painter Fear_Cond_Ext_KLM_3day.eps  % -f2 -r600 (adding these should select figure2 and export at 600dpi resolution)


%saveas(gcf,'extinctionKLM.eps');  % ugly pixilated in MS PPT