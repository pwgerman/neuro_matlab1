% sfn2013_placefieldstats
%
%uses out output of rungetripactivprob
% modified from:
% scatter_rungetripactivprob_byday_stats (which contains lots of different
% calculations and plot lin place fields etc...)
% runs on output variable mf from on or 2 runs of the script
% rungetripactivprob





%{
% calculate peak PF firing rate
stage = 5; % Place Field subset
g = 2; % ripple epoch-group (ie shock; not same as actual epoch)
index = mfout{stage}{g};
index = sortrows(index, 1);
animallist = unique(index(:,1));
pftotal = [];
for an = 1:length(animallist)
    animal = animallist(an);
    anindex = index(index(:,1)==animal, 2:5);   
    pfout{an} = indexlinfields(animal, anindex);
    pftotal = [pftotal pfout{an}];
end
%
mean(pftotal)
median(pftotal)
sem(pftotal)
%}

%p = ranksum(pftotal_shock_nofreeze, pftotal_ctrl_nofreeze)
%p = ranksum(pftotal_shock_freeze, pftotal_ctrl_freeze)
%mean(pftotal_shock_nofreeze)
%mean(pftotal_ctrl_nofreeze)
%mean(pftotal_shock_freeze)
%mean(pftotal_ctrl_freeze)

%There are more cells in the no freeze condition
%size(pftotal_shock_nofreeze)
%size(pftotal_ctrl_nofreeze)
%size(pftotal_shock_freeze)
%size(pftotal_ctrl_freeze)

%
% group for plots
values = [];
group = [];
barmeans = [];
barerrs = [];
index = [4 1; 5 2]; % no_freeze for comparison; shock ctrl


for i = 1:length(index)
    
    pfindex = mfout{index(i,1)}{index(i,2)};
    pfindex = sortrows(pfindex, 1);
    animallist = unique(pfindex(:,1));
    pftotal = [];
    for an = 1:length(animallist)
        animal = animallist(an);
        anindex = pfindex(pfindex(:,1)==animal, 2:5);
        pfout{an} = indexlinfields(animal, anindex); % change the output in this function as necessary
        pftotal = [pftotal pfout{an}];
    end
    
    values = [values; pftotal'];
    group = [group; i*ones(length(pftotal),1)];
    % for error bars
    barmeans = [barmeans; nanmean(pftotal')];
    barerrs = [barerrs; sem(pftotal')];
end

% save file info
filenameout = ['placefield_maxfr']; % ['placefield_linsize']; % 
savedir = '/home/walter/Desktop/sfn2013-images/';     
% make plots
%boxplot(values, group, 'plotstyle', 'compact', 'colors','rb');
%legend(findobj(gca,'Tag','Box'),'control','shock'); % the order is reversed?
bar(barmeans,'BarWidth', .5, 'FaceColor', 'w');
hold on;
eh = errorbar(barmeans, barerrs);
set(eh(1),'color','k'); % This changes the color of the errorbars
%set(eh(2),'color','k'); % This changes the color of the errorbars

set(eh(1),'linestyle','none'); % This removes the connecting line
%set(eh(2),'linestyle','none'); % This removes the connecting line

title([filenameout]);
%ylabel('peak firing rate (Hz)');
ylabel('linear place field size (cm)');
xlabel('group');
axis([ 0 , 3, 0, 12]);
%axis([ 0 , 3, 0, 30]); % field size
axis 'auto x';
% save output for adobe illustrator
print('-depsc','-r300',[savedir,filenameout,'.ai']);
print('-djpeg','-r300',[savedir,filenameout,'.jpg']);
%
