% function out = plotEpoch()
%
% plotEpoch plots and formats behavioral data by day and epoch
% the saved file is formatted as .eps with 600dpi rendering and easily
% imported into Adobe Illustrator for modification or for direct use in
% presentations and publication.

function out = plotEpoch(legend1, array1, legend2, array2)

% scan first args for arrays that will be plotted

% declare default variables before calling procOptions
DAYS = 7; % number of days per session;
EPOCHS = 2; % number of epochs per day;

XaxisMin = .3; % x-axis min
FigName = '/home/walter/src/matlab/figures/plot_epoch'; % prefix for output file
LineColorList = {['b' 'r']}; % list of line colors in order

LINW = 3; % LineWidth for plots
FONT = 'Helvetica';
TFSZ = 18; % title font size
AFSZ = 16; % axes font size
%scrsz = get(0,'ScreenSize');
FNTW = 'Normal'; % font weight 'Normal'

%unused = procOptions(args, varargin);

h=figure('DefaultAxesFontSize', AFSZ,'paperpositionmode','auto', 'color','white','InvertHardcopy','off');
hold; % positon of hold changes appearance of graph
hBar = bar(.25:.5:6.75,rem(2:DAYS*2+1, 2),'FaceColor',[.95 .95 .95],'EdgeColor', 'none', 'BaseValue', XaxisMin);
set(get(get(hBar,'Annotation'),'LegendInformation'),...
    'IconDisplayStyle','off'); % Exclude lines of bar graph from the legend
plot(.25:.5:6.75, array1,'LineWidth',LINW);
plot(.25:.5:6.75, array2,'r','LineWidth',LINW);
title('All Trials Daily Average','FontName',FONT, 'FontSize', TFSZ);
%axis([0 7 XaxisMin 1]);
%axes('AxesFontSize', 14); %'FontName',FONT, 'FontSize', AFSZ);
legend(legend1, legend2, 'Location', 'SouthEast');
xlabel('Day','FontName',FONT, 'FontSize', AFSZ);
ylabel('Probability Correct','FontName',FONT, 'FontSize', AFSZ);
%set(gcf,'DefaultLineLineWidth',4);
print(h,'-r600','-depsc2','-painters', [FigName '.eps']); % save figure to .eps file for ai (resave as .jpg for best ppt)

out = [];
return;
