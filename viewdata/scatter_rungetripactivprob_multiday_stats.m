% scatter_rungetripactivprob_multiday_stats
% runs on output variable mf from on or 2 funs of the script
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

mfout = [];

for varnum = 1:length(mf) % day
    for stage = 1:length(mf{varnum}) % cells exclusio (firstonly, intersect, neither, etc...)
        for an = 1:length(mf{varnum}{stage}) % animal
            for g = 1:length(mf{varnum}{stage}(an).output) % epoch filter group
                try
                    %fout{stage}{g} = [fout{stage}{g};  f{stage}(an).output{g}];
                    mfout{stage}{g} = [mfout{stage}{g};an*ones(size(mf{varnum}{stage}(an).output{g}, 1),1)  mf{varnum}{stage}(an).output{g}];
                catch
                    %fout{stage}{g} = [f{stage}(an).output{g}];
                    mfout{stage}{g} = [an*ones(size(mf{varnum}{stage}(an).output{g}, 1),1)  mf{varnum}{stage}(an).output{g}];
                end
            end
        end
    end
end

%{
% sleep 1 vs 2
sleep1= mfout{3}{1}(:,6); % sleep 1, noPF
sleep2= mfout{3}{4}(:,6); % sleep 2, noPF
[h,p] = ttest2(sleep1, sleep2);
%}

%{
% shock v ctrl
shock= mfout{1}{2}(:,6); % 
ctrl= mfout{2}{3}(:,6); % 
p = ranksum(rmnan(shock),rmnan(ctrl))
%[h,p] = ttest2(shock, ctrl);

shock= mfout{1}{4}(:,6); % 
ctrl= mfout{2}{4}(:,6); % 
p = ranksum(rmnan(shock),rmnan(ctrl))
%}

%{
sleep2PFshock = mfout{1}{4}(:,6);
sleep2PFctrl = mfout{2}{4}(:,6);
p = ranksum(sleep2PFshock, sleep2PFctrl);
%[h,p] = ttest2(sleep2PFshock, sleep2PFctrl);
%}

%
% create vertical line plots of variables (not 2d scatter)
var1 = mfout{1}{3}(:,6); % stage (firstonly), group(epoch)
%var1c = mfout{2}{1}(:,1);
%gscatter(ones(length(var1),1), var1, var1c,[],[],[],'off');
hold on;
var2 = mfout{2}{3}(:,6);
%var2c = mfout{2}{2}(:,1);
%gscatter(2*ones(length(var2),1), var2, var2c,[],[],[],'off');
p = ranksum(rmnan(var1), rmnan(var2))
%

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
        


