% scatter_rungetripactivprob_byday_stats
% runs on output variable mf from on or 2 runs of the script
% rungetripactivprob

%%%%%%%%%%%%%%%%%%%%%%%
%% epoch order split %%
%%%%%%%%%%%%%%%%%%%%%%%

%{
%mf1 = mf_day_shock_order1;
%mf0 = mf_day_shock_order0;
mfout = [];
for order_split= [1 2]
    if order_split == 1
        mf = mf1;
    else % 2 for control
        mf = mf0;
    end
    for varnum = 1:length(mf) % day
        for stage = 1:length(mf{varnum}) % cells exclusio (firstonly, intersect)
            for an = 1:length(mf{varnum}{stage}) % animal
                for g = 1:length(mf{varnum}{stage}(an).output) % epoch filter group
                    try
                        %fout{stage}{g} = [fout{stage}{g};  f{stage}(an).output{g}];
                        mfout{stage}{g}{order_split} = [mfout{stage}{g}{order_split};an*ones(size(mf{varnum}{stage}(an).output{g}, 1),1)  mf{varnum}{stage}(an).output{g}];
                    catch
                        %fout{stage}{g} = [f{stage}(an).output{g}];
                        mfout{stage}{g}{order_split} = [an*ones(size(mf{varnum}{stage}(an).output{g}, 1),1)  mf{varnum}{stage}(an).output{g}];
                    end
                end
            end
        end
    end
end

% replay reactive
concurr_shock= mfout{1}{2}{1}(:,6);  % PFshock, RIPshock, Epoch2shock
concurr_ctrl = mfout{2}{2}{2}(:,6);  % PFctrl,  RIPctrl,  Epoch2ctrl
replay_of_ctrl = mfout{2}{3}{2}(:,6);  % PFctrl,  RIPshock, Epoch2ctrl
replay_of_shock= mfout{1}{3}{1}(:,6);  % PFshock, RIPctrl,  Epoch2shock


%[h(1),p(1)] = ttest2(concurr_shock, concurr_ctrl);
%[h(2),p(2)] = ttest2(replay_of_shock, replay_of_ctrl);
p(1) = ranksum(rmnan(concurr_shock), rmnan(concurr_ctrl));
p(2) = ranksum(rmnan(replay_of_shock), rmnan(replay_of_ctrl));
%}

%%%%%%%%%%%%%%%%%%%%%%%
%% Not order split   %%
%%%%%%%%%%%%%%%%%%%%%%%

dfout = [];

for varnum = 1:length(mf) % day
    for stage = 1:length(mf{varnum}) % cells exclusio (firstonly, intersect, neither, etc...)
        for an = 1:length(mf{varnum}{stage}) % animal
            for g = 1:length(mf{varnum}{stage}(an).output) % epoch filter group
                try
                    %fout{stage}{g} = [fout{stage}{g};  f{stage}(an).output{g}];
                    dfout{stage}{g}{varnum} = [dfout{stage}{g}{varnum};an*ones(size(mf{varnum}{stage}(an).output{g}, 1),1)  mf{varnum}{stage}(an).output{g}];
                catch
                    %fout{stage}{g} = [f{stage}(an).output{g}];
                    dfout{stage}{g}{varnum} = [an*ones(size(mf{varnum}{stage}(an).output{g}, 1),1)  mf{varnum}{stage}(an).output{g}];
                end
            end
        end
    end
end

%% run on mf_shock_ctrl_5days
%save('/home/walter/Desktop/sfn2013-images/mf5', 'mf_shock_ctrl_5days');
%load('/home/walter/Desktop/sfn2013-images/mf5');
%mf = mf_shock_ctrl_5days;

%{
% for sleep2 shock v ctrl sessions
shockarray = [];groupday = [];
shockgroup = [];
ctrlarray = [];
ctrlgroup = [];
values = [];
group = []; % for ranksum, boxplot
groupday = []; % for anovan
grouprx = [];
for day = 1:5
    shock= dfout{1}{4}{day}(:,6) %
    %shockarray = [shockarray ; shock];
    %shockgroup = [shockgroup ; day*ones(length(shock),1)];
    values = [values ; shock];
    group = [group ; day*ones(length(shock),1)];
    groupday = [groupday ; day*ones(length(shock),1)];
    grouprx = [grouprx ; repmat({'shock'},length(shock),1)];
    ctrl= dfout{2}{4}{day}(:,6) %
    %ctrlarray = [ctrlarray ; ctrl];
    %ctrlgroup = [ctrlgroup ; (day+.3)*ones(length(ctrl),1)];
    values = [values ; ctrl];
    group = [group ; (day+.2)*ones(length(ctrl),1)]; % for ranksum, boxplot
    groupday = [groupday ; (day)*ones(length(ctrl),1)]; % for anovan
    grouprx = [grouprx ; repmat({'ctrl'},length(ctrl),1)];
    p = ranksum(rmnan(shock),rmnan(ctrl))
end
p = anovan(values,{groupday grouprx});
filenameout = ['reactprob_shock_ctrl_byday_insleep2'];
%boxplot(shockarray, shockgroup, 'plotstyle', 'compact', 'colors','r');
boxplot(values, group, 'plotstyle', 'compact', 'colors','rb');
legend(findobj(gca,'Tag','Box'),'control','shock'); % the order is reversed?
title([filenameout, ' anovan(day) p=' num2str(p(1)),' (rx) p=' num2str(p(2))]);
ylabel('reactiv prob');
xlabel('day');
% print plots
% save file info
savedir = '/home/walter/Desktop/sfn2013-images/';
% save output for adobe illustrator
print('-depsc','-r300',[savedir,filenameout,'.ai']);
print('-djpeg','-r300',[savedir,filenameout,'.jpg']);
%}

%{
% for sleep1 shock v ctrl sessions
shockarray = [];groupday = [];
shockgroup = [];
ctrlarray = [];
ctrlgroup = [];
values = [];
group = []; % for ranksum, boxplot
groupday = []; % for anovan
grouprx = [];
for day = 1:5
    shock= dfout{1}{1}{day}(:,6) %
    %shockarray = [shockarray ; shock];
    %shockgroup = [shockgroup ; day*ones(length(shock),1)];
    values = [values ; shock];
    group = [group ; day*ones(length(shock),1)];
    groupday = [groupday ; day*ones(length(shock),1)];
    grouprx = [grouprx ; repmat({'shock'},length(shock),1)];
    ctrl= dfout{2}{1}{day}(:,6) %
    %ctrlarray = [ctrlarray ; ctrl];
    %ctrlgroup = [ctrlgroup ; (day+.3)*ones(length(ctrl),1)];
    values = [values ; ctrl];
    group = [group ; (day+.2)*ones(length(ctrl),1)]; % for ranksum, boxplot
    groupday = [groupday ; (day)*ones(length(ctrl),1)]; % for anovan
    grouprx = [grouprx ; repmat({'ctrl'},length(ctrl),1)];
    p = ranksum(rmnan(shock),rmnan(ctrl))
end
p = anovan(values,{groupday grouprx});
filenameout = ['reactprob_shock_ctrl_byday_insleep1'];
%boxplot(shockarray, shockgroup, 'plotstyle', 'compact', 'colors','r');
boxplot(values, group, 'plotstyle', 'compact', 'colors','rb');
legend(findobj(gca,'Tag','Box'),'control','shock'); % the order is reversed?
title([filenameout, ' anovan(day) p=' num2str(p(1)),' (rx) p=' num2str(p(2))]);
ylabel('reactiv prob');
xlabel('day');
% print plots
% save file info
savedir = '/home/walter/Desktop/sfn2013-images/';
% save output for adobe illustrator
print('-depsc','-r300',[savedir,filenameout,'.ai']);
print('-djpeg','-r300',[savedir,filenameout,'.jpg']);
%}


%{
filenameout = ['reactprob_shock_ctrl_byday_inShock'];
shockindex = [1 2];
ctrlindex = [2 2];
%}

% 
filenameout = ['reactprob_shock_ctrl_byday_inCtrl'];
shockindex = [1 3];
ctrlindex = [2 3];

% save file info
savedir = '/home/walter/Desktop/sfn2013-images/';
% assign variables
shockarray = [];groupday = [];
shockgroup = [];
ctrlarray = [];
ctrlgroup = [];
values = [];
group = []; % for ranksum, boxplot
groupday = []; % for anovan
grouprx = [];
for day = 1:5
    shock= dfout{shockindex(1)}{shockindex(2)}{day}(:,6) %
    values = [values ; shock];
    group = [group ; day*ones(length(shock),1)];
    groupday = [groupday ; day*ones(length(shock),1)];
    grouprx = [grouprx ; repmat({'shock'},length(shock),1)];
    ctrl= dfout{ctrlindex(1)}{ctrlindex(2)}{day}(:,6) %
    values = [values ; ctrl];
    group = [group ; (day+.2)*ones(length(ctrl),1)]; % for ranksum, boxplot
    groupday = [groupday ; (day)*ones(length(ctrl),1)]; % for anovan
    grouprx = [grouprx ; repmat({'ctrl'},length(ctrl),1)];
    p = ranksum(rmnan(shock),rmnan(ctrl))
end
p = anovan(values,{groupday grouprx});
% print plots
boxplot(values, group, 'plotstyle', 'compact', 'colors','rb');
legend(findobj(gca,'Tag','Box'),'control','shock'); % the order is reversed?
title([filenameout, ' anovan(day) p=' num2str(p(1)),' (rx) p=' num2str(p(2))]);
ylabel('reactiv prob');
xlabel('day');
% save output for adobe illustrator
print('-depsc','-r300',[savedir,filenameout,'.ai']);
print('-djpeg','-r300',[savedir,filenameout,'.jpg']);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% scripts from mulitday (not single days)  %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%{
% sleep 1 vs 2
sleep1= mfout{3}{1}(:,6); % sleep 1, noPF
sleep2= mfout{3}{4}(:,6); % sleep 2, noPF
[h,p] = ttest2(sleep1, sleep2);
%}

%{
% shock v ctrl
for day = 1:5
    shock= dfout{day}{1}{2}(:,6); %
    ctrl= dfout{day}{2}{3}(:,6); %
    p = ranksum(rmnan(shock),rmnan(ctrl))
end
%[h,p] = ttest2(shock, ctrl);
%}

%{
sleep2PFshock = mfout{1}{4}(:,6);
sleep2PFctrl = mfout{2}{4}(:,6);
p = ranksum(sleep2PFshock, sleep2PFctrl);
%[h,p] = ttest2(sleep2PFshock, sleep2PFctrl);
%}

%{
% create vertical line plots of variables (not 2d scatter)
var1 = mfout{1}{3}(:,6); % stage (firstonly), group(epoch)
%var1c = mfout{2}{1}(:,1);
%gscatter(ones(length(var1),1), var1, var1c,[],[],[],'off');
hold on;
var2 = mfout{2}{3}(:,6);
%var2c = mfout{2}{2}(:,1);
%gscatter(2*ones(length(var2),1), var2, var2c,[],[],[],'off');
p = ranksum(rmnan(var1), rmnan(var2))
%}

%{
% plot linear place fields of a select group
stage = 1; % Place Field subset
g = 3; % ripple epoch-group (ie shock; not same as actual epoch)
index = mfout{stage}{g};
index = sortrows(index, 1);
animallist = unique(index(:,1));

for an = 1:length(animallist)
    animal = animallist(an);
    anindex = index(index(:,1)==animal, 2:5);   
    indexplotlinfields(animal, anindex);
end
%}

%{
% plot both linear place fields tracks
epoch1 = 2; % epoch1 and epoch2 are reversed to show the complimentary track
epoch2 = 3;
stage = 1; % Place Field subset 1=shockonly, 2=ctrlonly, 3=both,neither
g = 2; % ripple epoch-group (ie shock; not same as actual epoch)
index = mfout{stage}{g};
index = sortrows(index, 1);
animallist = unique(index(:,1));

for an = 1:length(animallist)
    animal = animallist(an);
    anindex = index(index(:,1)==animal, 2:5);
    
    % find the index for the complimentary epoch
    tmpanindex = anindex;
    tmpanindex(anindex(:,2)==epoch1,2) = epoch2;
    tmpanindex(anindex(:,2)==epoch2,2) = epoch1;
    anindex2 = tmpanindex;

    indexplotlinfields(animal, anindex, 'index2', anindex2);
end
%}

%{
% calculate peak PF firing rate
stage = 2; % Place Field subset
g = 3; % ripple epoch-group (ie shock; not same as actual epoch)
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
%}
        


