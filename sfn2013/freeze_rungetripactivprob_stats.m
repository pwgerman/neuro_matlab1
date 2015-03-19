% freeze_rungetripactivprob_stats
% runs on output variable mf from the script
% rungetripactivprob

% calc from mf output or load(sfn2013/freeze_reactprob.mat
%{ 
mfout = [];

for varnum = 1:length(mf) % day
    for stage = 1:length(mf{varnum}) % cells exclusio (firstonly, intersect, neither, etc...)
        for an = 1:length(mf{varnum}{stage}) % animal
            for g = 1:length(mf{varnum}{stage}(an).output) % epoch filter group
                try
                    mfout{stage}{g} = [mfout{stage}{g};an*ones(size(mf{varnum}{stage}(an).output{g}, 1),1)  mf{varnum}{stage}(an).output{g}];
                catch
                    mfout{stage}{g} = [an*ones(size(mf{varnum}{stage}(an).output{g}, 1),1)  mf{varnum}{stage}(an).output{g}];
                end
            end
        end
    end
end
%}


% shock v ctrl when only  looking at 2 run epochs (ie freezing)
%
shock= mfout{2}{1}(:,6); % 
ctrl= mfout{5}{1}(:,6); % 
p = ranksum(rmnan(shock),rmnan(ctrl))
size(shock)
nanmean(shock)
size(ctrl)
nanmean(ctrl)
%


%{
% group for plots
values = [];
group = [];
barmeans = [];
barerrs = [];
%index = [1 1; 2 1; 1 2; 2 2];
%index = [1 1; 2 1; 1 2; 2 2; 3 1; 3 2];
%index = [1 1; 2 1; 1 2; 2 2; 4 1; 5 1; 4 2; 5 2];
%index = [3 1; 3 2; 6 1; 6 2]; % FP in both
%index = [1 2; 2 1; 4 2; 5 1]; % REMOTE ONLY shockF. ctrlF, shockNF,ctrlNF 
%index = [1 1; 2 1; 1 2; 2 2];
%index = [1 1; 2 1; 1 4; 2 4]; % sleep 1 vs  sleep 2 (subdivided into shock and control)
index = [1 2; 2 3; 1 3; 2 2]; % local vs  remote (subdivided into shock and control)

for i = 1:length(index)
    % for boxplots
    values = [values; mfout{index(i,1)}{index(i,2)}(:,6)];
    group = [group; i*ones(length(mfout{index(i,1)}{index(i,2)}(:,6)),1)];
    % for error bars
    barmeans = [barmeans; nanmean(mfout{index(i,1)}{index(i,2)}(:,6))];
    barerrs = [barerrs; sem(mfout{index(i,1)}{index(i,2)}(:,6))];
end

% save file info
filenameout = ['reactprob_local_remote']; % ['reactprob_shock_ctrl_freeze&notfreeze_remoteonly']
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
ylabel('reactiv prob');
xlabel('group');
axis([ 0 , 5, 0, .16]);
axis 'auto x';
% save output for adobe illustrator
print('-depsc','-r300',[savedir,filenameout,'.ai']);
print('-djpeg','-r300',[savedir,filenameout,'.jpg']);
%}







%{
% next comparison
shock= mfout{1}{2}(:,6); % 
ctrl= mfout{2}{2}(:,6); % 
p = ranksum(rmnan(shock),rmnan(ctrl))
size(shock) 
nanmean(shock)
size(ctrl)
nanmean(ctrl)
%
% compare remote reactivprob
disp('remote');
shock= mfout{1}{2}(:,6); % 
ctrl= mfout{2}{1}(:,6); % 
p = ranksum(rmnan(shock),rmnan(ctrl))


shock= mfout{3}{1}(:,6); % 
ctrl= mfout{3}{2}(:,6); % 
p = ranksum(rmnan(shock),rmnan(ctrl))
size(shock) 
nanmean(shock)
size(ctrl)
nanmean(ctrl)
%}



