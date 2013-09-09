% formatfig('title', 'xlabel', 'ylabel', figure_legend)
% figure_legend = {'legend' 'cell' 'array'};
%
% a function to format the current figure
% 
% for best result use in conjunction with figdefaults.m
%
% Walter German, 2011



function[figure_handle]=formatfig(figtitle, xlabel, ylabel, figlegend)
%set(get(gca,'Title'),'FontSize', 24,'Color','g');
set(gca,'Title',text('String', figtitle,'FontSize', 24,'Color','k'))
set(get(gca,'XLabel'),'String', xlabel,'FontSize', 18,'Color','k' )
set(get(gca,'YLabel'),'String', ylabel,'FontSize', 18,'Color','k')
legend(gca, figlegend);

% other potentially useful formatting code
% set(gca,'XTickLabel',)
