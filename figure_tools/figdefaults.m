% figdefaults.m
%
% Change the defaults for figure Properties
%
% For information in matlab help see entry called:
% Setting Default Property Values
%
% For more information see these web pages:
% http://www.mathworks.com/help/techdoc/creating_plots/f7-21465.html
% http://www.mathworks.com/help/techdoc/ref/startup.html
% 
% This next web page has important information not included above for
% specifying <object type> such as 'axes' or 'text'
% http://www.math.ufl.edu/help/matlab/tec2.6.html
%
% For more specific figure formatting use function formatfig('title','xlabel','ylabel', figure_legend)
%
% Walter German, 2011

 
% axes and figure defaults are used before global defaults.
% it is not necessary to use these unless they are already set
% and overriding globla decaults

%set(gcf,'DefaultLineLineWidth',3);
%set(gcf,'DefaultAxesFontSize',18);
%set(gcf,'DefaultTextFontSize',18);

%get(gcf, 'default') 
%get(gca, 'default')
%get(gco, 'default')

set(0,'DefaultLineLineWidth',3);
set(0,'DefaultAxesFontSize',18);
set(0,'DefaultTextFontSize',24);

get(0, 'default');  % confirm new settings by removing semicolon to display
