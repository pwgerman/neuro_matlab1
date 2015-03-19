% plotstressbehav
% This script plots of conditioned fear behavior behavior
% change commented out options to alternately plot:
%   physiology animal freezing
%   behavior animal freezing
%   feces counts
%   estpos freeze times
%
% output is saved as jpg, ai, and pdf
%
% load saved variables of format...
% load('freezebehav.mat') % in dir ~/Analysis/sfn2013

% scatter vectors side by side
%scatter( sort(repmat([1 2], 1,5)), [stress{1}.shockfreeze; stress{1}.controlfreeze]);
%bar([mean(stress{1}.shockfreeze) mean(stress{1}.controlfreeze)]);
%p = ranksum(stress{1}.shockfreeze, stress{1}.controlfreeze);
%boxplot([stress{1}.shockfreeze; stress{1}.controlfreeze],  sort(repmat([1 2], 1,5)));
%boxplot([stress{1}.shockfreeze; stress{1}.controlfreeze],  sort(repmat([1 2], 1,5)), 'colors', 'bc');

figdefaults; % script to set figure attributes
set(0,'DefaultLineLineWidth',3); % for non-printing , use defaults
set(0,'DefaultAxesFontSize',24); % for non-printing , use defaults
set(0,'DefaultTextFontSize',24);

%% create scatter/boxplot array from stress struct
numdays = 5; %6; %7

shock = [];
shockgroup = [];
shockcolor = [];
control = [];
controlgroup = [];
controlcolor = [];
barmeans = [];
barerrs = [];
for d = 1:numdays
    shock = [shock; stress{d}.shockfreeze];
    control = [control; stress{d}.controlfreeze];
    %shock = [shock; stress{d}.shockfeces];
    %control = [control; stress{d}.controlfeces];
    %shock = [shock; bstress{d}.shockfreeze];  % behavior only animals
    %control = [control; bstress{d}.controlfreeze];
    %shock = [shock; stress{d}.shockestpos'];
    %control = [control; stress{d}.controlestpos'];
    
    shockgroup = [shockgroup; repmat([d*2-1], 5,1)];
    shockcolor = [shockcolor; repmat([1 0 1], 5,1)];   
    controlgroup = [controlgroup; repmat([d*2], 5,1)];
    controlcolor = [controlcolor; repmat([0 .7 .7], 5,1)];
    
    barmeans = [barmeans; nanmean(stress{d}.shockfreeze)];
    barerrs = [barerrs; nanmean(stress{d}.shockfreeze)];
    barmeans = [barmeans; nanmean(stress{d}.controlfreeze)];
    barerrs = [barerrs; nanmean(stress{d}.controlfreeze)];
end

figure;
set(gcf, 'Color', [1 1 1]);
set(gca, 'LineWidth', 2); % for non-print, use 3
hold on;

scatter([(shockgroup); (controlgroup)], [shock; control], 100 , [shockcolor; controlcolor], 'filled'); % for non=printing, use 100
%bh=boxplot([shock; control], [shockgroup; controlgroup], 'colors', 'rb');

%{
% set boxplot linewidth
for j = 1:size(bh,2)
    for i=1:size(bh,1) % <- # graphics handles/x
        set(bh(i,j),'linewidth',2); % for non-print, use 4
        %disp(sprintf('working on component: %3d = %s',i,get(bh(i,1),'tag')));
        %pause(.5);
    end
end
%}


bar(barmeans,'BarWidth', .5, 'FaceColor', 'w', 'LineWidth', 3);
%eh = errorbar(barmeans, barerrs);
%set(eh(1),'color','k'); % This changes the color of the errorbars
%set(eh(2),'color','k'); % This changes the color of the errorbars
%set(eh(1),'linestyle','none'); % This removes the connecting line
%set(eh(2),'linestyle','none'); % This removes the connecting line




%% plot bars connecting shock and control pairs
tmp=[shockgroup, controlgroup];
tmp2=[shock, control];
for i = 1:length(tmp)
    plot(tmp(i,:),tmp2(i,:), 'k');
end

xtick = [];
for d = 1:numdays
    xtick = [xtick {['shock-' num2str(d)]} {['ctrl-' num2str(d)]} ];
end

%% add labels etc
set(gca,'XTick',1:10);
set(gca,'XTickLabel', xtick); %{'shock-1','ctrl-1',}
axis([0 11 0 500]);
xlabel('context-day');
title('Freezing Times, Physiology Animals');
%ylabel('freezing time (s)');
%title('Feces Count, Physiology Animals');
%ylabel('fecal pellets');
%title('Freezing Times, Behavior Only Animals');
%ylabel('freezing time (s)');
%title('Freezing Times (Est Pos), Physiology Animals');
ylabel('freezing time (s)');


% save file info
picpre = 'freezetimes_new';
savedir = '/home/walter/Desktop/sfn2013-images/';
filenameout = [picpre]; %[picpre, num2str(picind)];
% save output for adobe illustrator
print('-depsc2','-r300',[savedir,filenameout,'.ai']);
print('-djpeg','-r300',[savedir,filenameout,'.jpg']);
print('-depsc2','-r300',[savedir,filenameout,'.pdf']);

