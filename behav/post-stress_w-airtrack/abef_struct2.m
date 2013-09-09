% script abef_struct  - could become function with (names) as argument
%
% generate matrices for animals list of all w-track sessions
% listABEF.m;
% list of filenames for data from dioprocess2 agregated by abef_list and
% saved
% load filenames into structs, include a field for the filename for saving
% later

%
% To export images go to image menues and choose File>ExportSetup
% Load and Apply the powerpoint setting.  Then apply 600 dpi rendering
% export as file type ...
%

% Print Options
FigName = '/home/walter/src/matlab/figures/shock_study2';
fig_count = 0; % 1 = make figure and save .eps file, 0=omit figures
fig_daily_weight = 0;
fig_daily = 0;
fig_runavg = 0;
fig_daily_indiv = 0;
fig_epochs = 0;
fig_scatter = 0; % correlation between number of trials and prob correct
fig_estprob = 0; % estimated probability correct/ learning curve
fig_estprob_inb = 0; %
fig_estprob_outb = 0; %
fig_time_distr = 0;
fig_interleave_epochs = 0;
%calculate_interleave_animals = 1; % this is fast and can always be 1
calculate_est_prob_correct = 0; % time intensive, output saved, only reached if fig_interleave = 1
fig_interleave_animals = 1;
fig_interleave_set1 = 0;
fig_runavg_indiv = 0;
fig_runavg_indiv_inb = 0;
fig_runavg_indiv_outb = 0;


% Format Settings
RUNAVG = 10;  % number of trials to include in running average
h = ones(1, RUNAVG)/RUNAVG; % filter
LINW = 3; % LineWidth for plots
FONT = 'Helvetica';
TFSZ = 18; % title font size
AFSZ = 16; % axes font size
%scrsz = get(0,'ScreenSize');
FNTW = 'Normal'; % font weight 'Normal'
RGBL = .90; % RGB color level for epoch bars, 1=white, 0=black
XaxisMIN = .3;
JBA = .1; %0.1; % jbfill alpha transparency


% Array Indices
%'reward'; 'index'; 'goal1'; 'goal2'; 'goal3'; 'attempt'; 'error';
%'dioTimeStamp'; 'day'; 'run'; 'outbound'
REW = 1;
IDX = 2; % index (trial number for that day)
GL1 = 3;
GL2 = 4; % middle arm
GL3 = 5;
ATM = 6;
ERR = 7;
TIM = 8; % dio timestamp in 10kHz
DAY = 9;
RUN = 10; % epoch number for the day
OUT = 11; % current trial is outbound =1; inbound=0

% Animal and Task info
names = {'a1','a2','b1','b2','e1','e2','f1','f2'};
shocks = [0 1 1 0 0 1 0 1];
DAYS = 7; % number of days per session;
EPOCHS = 2; % number of epochs per day;

dio = {length(names)};
dio{:} = struct('names', [], 'shock', [], 'raw', []);

for ani = 1:length(names)
    %load(names{ani});
    dio{ani}.name = names{ani};
    dio{ani}.shock = shocks(ani);
    dio{ani}.raw = load(names{ani});  % dio.raw includes extra zero's in
    % all columns (ie reward, error etc) when a photobeam broke even if
    % nothing happened.  For only a stream of correct or error trails as
    % 1 or 0 use dio{ani}.all(:,REW) (or .inb .outb)
    dio{ani}.raw = dio{ani}.raw.(names{ani});
    
    
    % eliminate rows that are not attempts at goals
    dio{ani}.all = sortrows(dio{ani}.raw, ATM);
    i = find(floor(dio{ani}.all(:,ATM)), 1, 'first');
    dio{ani}.all = dio{ani}.all(i:end,:);
    
    % assign column 11 the value of outbound or inbound trial
    dio{ani}.all(:,OUT) = 0; %set all outbound =0 because first is inbound for all sessions
    dio{ani}.all(2:end,OUT) = dio{ani}.all(1:end-1,GL2) & (dio{ani}.all(1:end-1,10)-dio{ani}.all(2:end,10))==0 ; % if previously in middle, current trial is outbound, unless first of session (determined by change in run/epoch)
    dio{ani}.outb = sortrows(dio{ani}.all, 11);
    i = find(dio{ani}.outb(:,11), 1, 'first');
    dio{ani}.inb = dio{ani}.outb(1:i-1,:); % inbound is only where sort found outbound=0;
    dio{ani}.outb = dio{ani}.outb(i:end,:); % outbound is only where sort found outbound=1;
    
    % plot running average of correct
    dio{ani}.avg.runavg = RUNAVG;
    dio{ani}.avg.all = conv(h, dio{ani}.all(:,REW));
    dio{ani}.avg.inb = conv(h, dio{ani}.inb(:,REW));
    dio{ani}.avg.outb = conv(h, dio{ani}.outb(:,REW));
    
    for d = 1:DAYS
        for r = 1:EPOCHS
            events = dio{ani}.raw(:,REW)==1 & dio{ani}.raw(:,DAY)==d & dio{ani}.raw(:,RUN)==r;
            dio{ani}.stats.all.rew(r,d) = sum(events);
            events = dio{ani}.raw(:,ERR)==1 & dio{ani}.raw(:,DAY)==d & dio{ani}.raw(:,RUN)==r;
            dio{ani}.stats.all.err(r,d) = sum(events);
            events = dio{ani}.raw(:,ATM)==1 & dio{ani}.raw(:,DAY)==d & dio{ani}.raw(:,RUN)==r;
            dio{ani}.stats.all.atm(r,d) = sum(events);
            
            events = dio{ani}.inb(:,REW)==1 & dio{ani}.inb(:,DAY)==d & dio{ani}.inb(:,RUN)==r;
            dio{ani}.stats.inb.rew(r,d) = sum(events);
            events = dio{ani}.inb(:,ERR)==1 & dio{ani}.inb(:,DAY)==d & dio{ani}.inb(:,RUN)==r;
            dio{ani}.stats.inb.err(r,d) = sum(events);
            events = dio{ani}.inb(:,ATM)==1 & dio{ani}.inb(:,DAY)==d & dio{ani}.inb(:,RUN)==r;
            dio{ani}.stats.inb.atm(r,d) = sum(events);
            
            events = dio{ani}.outb(:,REW)==1 & dio{ani}.outb(:,DAY)==d & dio{ani}.outb(:,RUN)==r;
            dio{ani}.stats.outb.rew(r,d) = sum(events);
            events = dio{ani}.outb(:,ERR)==1 & dio{ani}.outb(:,DAY)==d & dio{ani}.outb(:,RUN)==r;
            dio{ani}.stats.outb.err(r,d) = sum(events);
            events = dio{ani}.outb(:,ATM)==1 & dio{ani}.outb(:,DAY)==d & dio{ani}.outb(:,RUN)==r;
            dio{ani}.stats.outb.atm(r,d) = sum(events);
        end
    end
    dio{ani}.stats.all.acc = dio{ani}.stats.all.rew./dio{ani}.stats.all.atm;
    dio{ani}.stats.inb.acc = dio{ani}.stats.inb.rew./dio{ani}.stats.inb.atm;
    dio{ani}.stats.outb.acc = dio{ani}.stats.outb.rew./dio{ani}.stats.outb.atm;
end


% EPOCH PAIRED T-TEST
% dio{ani}.stats.inb.acc(:,1:3)
epoch.all.acc.shock.e123 = [];
epoch.all.acc.sham.e123 = [];
epoch.all.acc.shock.e456 = [];
epoch.all.acc.sham.e456 = [];

epoch.inb.acc.shock.e123 = [];
epoch.inb.acc.sham.e123 = [];
epoch.inb.acc.shock.e456 = [];
epoch.inb.acc.sham.e456 = [];

epoch.outb.acc.shock.e123 = [];
epoch.outb.acc.sham.e123 = [];
epoch.outb.acc.shock.e456 = [];
epoch.outb.acc.sham.e456 = [];


for ani = 1:length(names)
    if dio{ani}.shock % shock(ani) true
        epoch.all.acc.shock.e123 = [epoch.all.acc.shock.e123; dio{ani}.stats.all.acc(:,1:3)'];
        epoch.all.acc.shock.e456 = [epoch.all.acc.shock.e456; dio{ani}.stats.all.acc(:,4:6)'];
        epoch.inb.acc.shock.e123 = [epoch.inb.acc.shock.e123; dio{ani}.stats.inb.acc(:,1:3)'];
        epoch.inb.acc.shock.e456 = [epoch.inb.acc.shock.e456; dio{ani}.stats.inb.acc(:,4:6)'];
        epoch.outb.acc.shock.e123 = [epoch.outb.acc.shock.e123; dio{ani}.stats.outb.acc(:,1:3)'];
        epoch.outb.acc.shock.e456 = [epoch.outb.acc.shock.e456; dio{ani}.stats.outb.acc(:,4:6)'];
        
    else
        epoch.all.acc.sham.e123 = [epoch.all.acc.sham.e123; dio{ani}.stats.all.acc(:,1:3)'];
        epoch.all.acc.sham.e456 = [epoch.all.acc.sham.e456; dio{ani}.stats.all.acc(:,4:6)'];
        epoch.inb.acc.sham.e123 = [epoch.inb.acc.sham.e123; dio{ani}.stats.inb.acc(:,1:3)'];
        epoch.inb.acc.sham.e456 = [epoch.inb.acc.sham.e456; dio{ani}.stats.inb.acc(:,4:6)'];
        epoch.outb.acc.sham.e123 = [epoch.outb.acc.sham.e123; dio{ani}.stats.outb.acc(:,1:3)'];
        epoch.outb.acc.sham.e456 = [epoch.outb.acc.sham.e456; dio{ani}.stats.outb.acc(:,4:6)'];
    end
end
[hyp(1,1), p(1,1)] = ttest(epoch.all.acc.shock.e123(:,1), epoch.all.acc.shock.e123(:,2));
[hyp(1,2), p(1,2)] = ttest(epoch.all.acc.sham.e123(:,1), epoch.all.acc.sham.e123(:,2));
[hyp(1,3), p(1,3)] = ttest(epoch.all.acc.shock.e456(:,1), epoch.all.acc.shock.e456(:,2));
[hyp(1,4), p(1,4)] = ttest(epoch.all.acc.sham.e456(:,1), epoch.all.acc.sham.e456(:,2));

[hyp(2,1), p(2,1)] = ttest(epoch.inb.acc.shock.e123(:,1), epoch.inb.acc.shock.e123(:,2));
[hyp(2,2), p(2,2)] = ttest(epoch.inb.acc.sham.e123(:,1), epoch.inb.acc.sham.e123(:,2));
[hyp(2,3), p(2,3)] = ttest(epoch.inb.acc.shock.e456(:,1), epoch.inb.acc.shock.e456(:,2));
[hyp(2,4), p(2,4)] = ttest(epoch.inb.acc.sham.e456(:,1), epoch.inb.acc.sham.e456(:,2));

[hyp(3,1), p(3,1)] = ttest(epoch.outb.acc.shock.e123(:,1), epoch.outb.acc.shock.e123(:,2));
[hyp(3,2), p(3,2)] = ttest(epoch.outb.acc.sham.e123(:,1), epoch.outb.acc.sham.e123(:,2));
[hyp(3,3), p(3,3)] = ttest(epoch.outb.acc.shock.e456(:,1), epoch.outb.acc.shock.e456(:,2));
[hyp(3,4), p(3,4)] = ttest(epoch.outb.acc.sham.e456(:,1), epoch.outb.acc.sham.e456(:,2));


% create linear arrays of daily attempts for each animal
shock.all.atm = [];
sham.all.atm = [];
shock.inb.atm = [];
sham.inb.atm = [];
shock.outb.atm = [];
sham.outb.atm = [];

% create linear arrays of daily rewards for each animal
shock.all.rew = [];
sham.all.rew = [];
shock.inb.rew = [];
sham.inb.rew = [];
shock.outb.rew = [];
sham.outb.rew = [];

% create linear arrays of daily accuracy for each animal
shock.all.acc = [];
sham.all.acc = [];
shock.inb.acc = [];
sham.inb.acc = [];
shock.outb.acc = [];
sham.outb.acc = [];

for ani = 1:length(names)
    if dio{ani}.shock % shock(ani) true
        shock.all.atm = [shock.all.atm ; dio{ani}.stats.all.atm(:)'];
        shock.inb.atm = [shock.inb.atm ; dio{ani}.stats.inb.atm(:)'];
        shock.outb.atm = [shock.outb.atm ; dio{ani}.stats.outb.atm(:)'];
        % reward
        shock.all.rew = [shock.all.rew ; dio{ani}.stats.all.rew(:)'];
        shock.inb.rew = [shock.inb.rew ; dio{ani}.stats.inb.rew(:)'];
        shock.outb.rew = [shock.outb.rew ; dio{ani}.stats.outb.rew(:)'];
        % accuracy
        shock.all.acc = [shock.all.acc ; dio{ani}.stats.all.acc(:)'];
        shock.inb.acc = [shock.inb.acc ; dio{ani}.stats.inb.acc(:)'];
        shock.outb.acc = [shock.outb.acc ; dio{ani}.stats.outb.acc(:)'];
    else
        sham.all.atm = [sham.all.atm ; dio{ani}.stats.all.atm(:)'];
        sham.inb.atm = [sham.inb.atm ; dio{ani}.stats.inb.atm(:)'];
        sham.outb.atm = [sham.outb.atm ; dio{ani}.stats.outb.atm(:)'];
        % reward
        sham.all.rew = [sham.all.rew ; dio{ani}.stats.all.rew(:)'];
        sham.inb.rew = [sham.inb.rew ; dio{ani}.stats.inb.rew(:)'];
        sham.outb.rew = [sham.outb.rew ; dio{ani}.stats.outb.rew(:)'];
        % accuracy
        sham.all.acc = [sham.all.acc ; dio{ani}.stats.all.acc(:)'];
        sham.inb.acc = [sham.inb.acc ; dio{ani}.stats.inb.acc(:)'];
        sham.outb.acc = [sham.outb.acc ; dio{ani}.stats.outb.acc(:)'];
    end
end

% weighted average of daily accuracy to prevent animals with few trials from
% skewing results (ie one animal had 100% but only 4 trials)
% create linear arrays of daily accuracy weighted by number of attempts by
% each animal
shock.all.accw = sum(shock.all.rew)./sum(shock.all.atm);
sham.all.accw = sum(sham.all.rew)./sum(sham.all.atm);
shock.inb.accw = sum(shock.inb.rew)./sum(shock.inb.atm);
sham.inb.accw = sum(sham.inb.rew)./sum(sham.inb.atm);
shock.outb.accw = sum(shock.outb.rew)./sum(shock.outb.atm);
sham.outb.accw = sum(sham.outb.rew)./sum(sham.outb.atm);


% CALCULATE RUNNING AVERAGES WITH SHOCK/SHAM GROUPS AVERAGED TOGETHER
% first find number of trials for each animal, then crop each animal to sam
% length as shortest so each array is equal length when finding mean.
numTrials.shock.all = [];
numTrials.shock.inb = [];
numTrials.shock.outb = [];
numTrials.sham.all = [];
numTrials.sham.inb = [];
numTrials.sham.outb = [];

for ani = 1:length(names)
    if dio{ani}.shock % shock(ani) true
        numTrials.shock.all = [numTrials.shock.all length(dio{ani}.avg.all)];
        numTrials.shock.inb = [numTrials.shock.inb length(dio{ani}.avg.inb)];
        numTrials.shock.outb = [numTrials.shock.outb length(dio{ani}.avg.outb)];
        
    else
        numTrials.sham.all = [numTrials.sham.all length(dio{ani}.avg.all)];
        numTrials.sham.inb = [numTrials.sham.inb length(dio{ani}.avg.inb)];
        numTrials.sham.outb = [numTrials.sham.outb length(dio{ani}.avg.outb)];
    end
end

shock.all.runAvg = [];
sham.all.runAvg = [];
shock.inb.runAvg = [];
sham.inb.runAvg = [];
shock.outb.runAvg = [];
sham.outb.runAvg = [];
for ani = 1:length(names)
    if dio{ani}.shock % shock(ani) true
        shock.all.runAvg = [shock.all.runAvg ; dio{ani}.avg.all(1:min(numTrials.shock.all))'];   %dio{ani}.stats.all.acc(:)'];
        shock.inb.runAvg = [shock.inb.runAvg ; dio{ani}.avg.inb(1:min(numTrials.shock.inb))'];
        shock.outb.runAvg = [shock.outb.runAvg ; dio{ani}.avg.outb(1:min(numTrials.shock.outb))'];
    else
        sham.all.runAvg = [sham.all.runAvg ; dio{ani}.avg.all(1:min(numTrials.sham.all))'];
        sham.inb.runAvg = [sham.inb.runAvg ; dio{ani}.avg.inb(1:min(numTrials.sham.inb))'];
        sham.outb.runAvg = [sham.outb.runAvg ; dio{ani}.avg.outb(1:min(numTrials.sham.outb))'];
    end
end


% DISTRIBUTION OF TIMES BETWEEN TRIALS
% Calculations for fig_time_distr, fig_interleave_epochs, fig_interleave_animals
times = cell(length(names), DAYS, EPOCHS);
allTimes = [];
ybins = 60:60:1500; % time from start of in current epoch
epochTimes = cell(length(ybins),1);
for ani = 1:length(names)
    for i = 1:length(dio{ani}.all(:,TIM))
        
        % use this if to find inter-reward interval
        %if ~dio{ani}.all(i,REW)
        times{ani, dio{ani}.all(i,DAY), dio{ani}.all(i,RUN)} = ...
            [times{ani, dio{ani}.all(i,DAY), dio{ani}.all(i,RUN)}; dio{ani}.all(i,REW) dio{ani}.all(i,TIM) dio{ani}.all(i,OUT)];
        %end
        %events = dio{ani}.all(:,TIM)  ==1 ;
        %& dio{ani}.all(:,DAY)==d & dio{ani}.all(:,RUN)==r;
        
        % eliminate rows that are not attempts at goals
        %dio{ani}.all = sortrows(dio{ani}.raw, ATM);
        %i = find(floor(dio{ani}.all(:,ATM)), 1, 'first');
        %dio{ani}.all = dio{ani}.all(i:end,:);
    end
    for d = 1:DAYS
        for r = 1:EPOCHS % or choose one epoch at a time
            
            times{ani,d,r}(:,4:5) = NaN(length(times{ani,d,r}(:,1)), 2); % allocate new column for epoch time elapsed
            times{ani,d,r}(:,5) = times{ani,d,r}(:,3); % shift oubound from column 3 to 5
            times{ani,d,r}(:,3) = NaN(length(times{ani,d,r}(:,1)), 1); % clear column for iti
            times{ani,d,r}(1:end-1,3) = diff(times{ani,d,r}(:,2)); % calculate within epoch inter trial interval
            times{ani,d,r}(:,4) = times{ani,d,r}(:,2) - times{ani,d,r}(1,2); % calculate time since beginning of epoch
            for i = 1:length(times{ani,d,r}(:,3))-1
                if 1 %times{ani,d,r}(i,1) % if rewarded attempt, "~" for error, and "1" for all
                    allTimes = [allTimes; times{ani,d,r}(i,3)];
                    %for et = 1:length(ybins)
                    et = int8(ceil((times{ani,d,r}(i,4)+1)/600000)); % 25 one min bins from start of epoch
                    if et > 25
                        et = 25;
                    end
                    epochTimes{et} = [epochTimes{et}; times{ani,d,r}(i,3)];
                end
            end
        end
    end
end % animal for loop
% End calculations for fig_time_distr, fig_interleave_epochs, fig_interleave_animals



% DAILY ATTEMPTS
%
% SUPPRESS OUTPUT with if statement
if fig_count
    
    barHeight = 40; % determine after plotting lines to see best fit
    h=figure('DefaultAxesFontSize', AFSZ,'paperpositionmode','auto', 'color','white','InvertHardcopy','off');
    hold; % positon of hold changes appearance of graph
    hBar = bar(.25:.5:6.75,(rem(2:DAYS*2+1, 2)*barHeight),'FaceColor',[RGBL RGBL RGBL],'EdgeColor', 'none', 'BarWidth', 1);
    set(get(get(hBar,'Annotation'),'LegendInformation'),...
        'IconDisplayStyle','off'); % Exclude lines of bar graph from the legend
    plot(.25:.5:6.75, mean(sham.all.atm),'LineWidth',LINW);
    plot(.25:.5:6.75, mean(shock.all.atm),'r','LineWidth',LINW);
    title('All Trials Daily Count','FontName',FONT, 'FontSize', TFSZ);
    axis([0 7 XaxisMIN 1]);
    axis('auto y');
    %axes('AxesFontSize', 14); %'FontName',FONT, 'FontSize', AFSZ);
    legend('sham', 'shock', 'Location', 'SouthEast');
    xlabel('Day','FontName',FONT, 'FontSize', AFSZ);
    ylabel('Trial Count','FontName',FONT, 'FontSize', AFSZ);
    %set(gcf,'DefaultLineLineWidth',4);
    print(h,'-r600','-depsc2','-painters', [FigName '_Count_All.eps']); % save figure to .eps file for ai (resave as .jpg for best ppt)
    
    
    barHeight = 20; % determine after plotting lines to see best fit
    h=figure('DefaultAxesFontSize', AFSZ,'paperpositionmode','auto', 'color','white','InvertHardcopy','off');
    hold; % positon of hold changes appearance of graph
    hBar = bar(.25:.5:6.75,(rem(2:DAYS*2+1, 2)*barHeight),'FaceColor',[RGBL RGBL RGBL],'EdgeColor', 'none', 'BarWidth', 1);
    set(get(get(hBar,'Annotation'),'LegendInformation'),...
        'IconDisplayStyle','off'); % Exclude lines of bar graph from the legend
    plot(.25:.5:6.75, mean(sham.inb.atm),'LineWidth',LINW);
    plot(.25:.5:6.75, mean(shock.inb.atm),'r','LineWidth',LINW);
    title('Inbound Trials Daily Count','FontName',FONT, 'FontSize', TFSZ);
    axis([0 7 XaxisMIN 1]);
    axis('auto y');
    %axes('AxesFontSize', 14); %'FontName',FONT, 'FontSize', AFSZ);
    legend('sham', 'shock', 'Location', 'SouthEast');
    xlabel('Day','FontName',FONT, 'FontSize', AFSZ);
    ylabel('Trial Count','FontName',FONT, 'FontSize', AFSZ);
    %set(gcf,'DefaultLineLineWidth',4);
    print(h,'-r600','-depsc2','-painters', [FigName '_Count_Inb.eps']); % save figure to .eps file for ai (resave as .jpg for best ppt)
    
    
    barHeight = 20; % determine after plotting lines to see best fit
    h=figure('DefaultAxesFontSize', AFSZ,'paperpositionmode','auto', 'color','white','InvertHardcopy','off');
    hold; % positon of hold changes appearance of graph
    hBar = bar(.25:.5:6.75,(rem(2:DAYS*2+1, 2)*barHeight),'FaceColor',[RGBL RGBL RGBL],'EdgeColor', 'none', 'BarWidth', 1);
    set(get(get(hBar,'Annotation'),'LegendInformation'),...
        'IconDisplayStyle','off'); % Exclude lines of bar graph from the legend
    plot(.25:.5:6.75, mean(sham.outb.atm),'LineWidth',LINW);
    plot(.25:.5:6.75, mean(shock.outb.atm),'r','LineWidth',LINW);
    title('Outbound Trials Daily Count','FontName',FONT, 'FontSize', TFSZ);
    axis([0 7 XaxisMIN 1]);
    axis('auto y');
    %axes('AxesFontSize', 14); %'FontName',FONT, 'FontSize', AFSZ);
    legend('sham', 'shock', 'Location', 'SouthEast');
    xlabel('Day','FontName',FONT, 'FontSize', AFSZ);
    ylabel('Trial Count','FontName',FONT, 'FontSize', AFSZ);
    %set(gcf,'DefaultLineLineWidth',4);
    print(h,'-r600','-depsc2','-painters', [FigName '_Count_Outb.eps']); % save figure to .eps file for ai (resave as .jpg for best ppt)
    
end % end suppress figures



% PLOT WEIGHTED DAILY AVERAGES WITH SHOCK/SHAM GROUPS AVERAGED TOGETHER
%
if fig_daily_weight
    
    h=figure('DefaultAxesFontSize', AFSZ,'paperpositionmode','auto', 'color','white','InvertHardcopy','off');
    hold; % positon of hold changes appearance of graph
    hBar = bar(.25:.5:6.75,rem(2:DAYS*2+1, 2),'FaceColor',[RGBL RGBL RGBL],'EdgeColor', 'none', 'BaseValue', XaxisMIN, 'BarWidth', 1);
    set(get(get(hBar,'Annotation'),'LegendInformation'),...
        'IconDisplayStyle','off'); % Exclude lines of bar graph from the legend
    %hold; % positon of hold changes appearance of graph
    %alpha(.1)
    plot(.25:.5:6.75, sham.all.accw,'LineWidth',LINW);
    plot(.25:.5:6.75, shock.all.accw,'r','LineWidth',LINW);
    title('All Trials Daily Weighted Average','FontName',FONT, 'FontSize', TFSZ);
    axis([0 7 XaxisMIN 1]);
    %axes('AxesFontSize', 14); %'FontName',FONT, 'FontSize', AFSZ);
    legend('sham','shock', 'Location', 'SouthEast');
    xlabel('Day','FontName',FONT, 'FontSize', AFSZ);
    ylabel('Probability Correct','FontName',FONT, 'FontSize', AFSZ);
    %set(gcf,'DefaultLineLineWidth',4);
    print(h,'-r600','-depsc2','-painters', [FigName '_DailyW_All.eps']); % save figure to .eps file for ai (resave as .jpg for best ppt)
    
    
    h=figure('DefaultAxesFontSize', AFSZ,'paperpositionmode','auto', 'color','white','InvertHardcopy','off');
    hold;
    hBar= bar(.25:.5:6.75,rem(2:DAYS*2+1, 2),'FaceColor',[RGBL RGBL RGBL],'EdgeColor', 'none','BaseValue', XaxisMIN, 'BarWidth', 1);
    set(get(get(hBar,'Annotation'),'LegendInformation'),...
        'IconDisplayStyle','off'); % Exclude lines of bar graph from the legend
    %alpha(.1)
    plot(.25:.5:6.75, sham.inb.accw,'LineWidth',LINW);
    plot(.25:.5:6.75, shock.inb.accw,'r','LineWidth',LINW);
    title('Inbound Daily Weighted Average','FontName',FONT, 'FontSize', TFSZ);
    axis([0 7 XaxisMIN 1]);
    legend('sham','shock', 'Location', 'SouthEast');
    xlabel('Day','FontName',FONT, 'FontSize', AFSZ);
    ylabel('Probability Correct','FontName',FONT, 'FontSize', AFSZ);
    print(h,'-r600','-depsc2','-painters', [FigName '_DailyW_Inb.eps']); % save figure to .eps file for ai (resave as .jpg for best ppt)
    
    
    h=figure('DefaultAxesFontSize', AFSZ,'paperpositionmode','auto', 'color','white','InvertHardcopy','off');
    hold;
    hBar= bar(.25:.5:6.75,rem(2:DAYS*2+1, 2),'FaceColor',[RGBL RGBL RGBL],'EdgeColor', 'none', 'BaseValue', XaxisMIN, 'BarWidth', 1);
    set(get(get(hBar,'Annotation'),'LegendInformation'),...
        'IconDisplayStyle','off'); % Exclude lines of bar graph from the legend
    %alpha(.1)
    plot(.25:.5:6.75, sham.outb.accw,'LineWidth',LINW);
    plot(.25:.5:6.75, shock.outb.accw,'r','LineWidth',LINW);
    title('Outbound Daily Weighted Average','FontName',FONT, 'FontSize', TFSZ);
    axis([0 7 XaxisMIN 1]);
    legend('sham','shock', 'Location', 'SouthEast');
    xlabel('Day','FontName',FONT, 'FontSize', AFSZ);
    ylabel('Probability Correct','FontName',FONT, 'FontSize', AFSZ);
    print(h,'-r600','-depsc2','-painters', [FigName '_DailyW_Outb.eps']); % save figure to .eps file for ai (resave as .jpg for best ppt)
    
end % suppress printing

% *********************
%
% GENERATE FIGURES
%
% ********************

% **************
% SUPPRESS OUTPUT with if statement
if fig_daily
    
    % PLOT DAILY AVERAGES WITH SHOCK/SHAM GROUPS AVERAGED TOGETHER
    h=figure('DefaultAxesFontSize', AFSZ,'paperpositionmode','auto', 'color','white','InvertHardcopy','off');
    hold; % positon of hold changes appearance of graph
    hBar = bar(.25:.5:6.75,rem(2:DAYS*2+1, 2),'FaceColor',[RGBL RGBL RGBL],'EdgeColor', 'none', 'BaseValue', XaxisMIN, 'BarWidth', 1);
    set(get(get(hBar,'Annotation'),'LegendInformation'),...
        'IconDisplayStyle','off'); % Exclude lines of bar graph from the legend
    %hold; % positon of hold changes appearance of graph
    %alpha(.1)
    plot(.25:.5:6.75, mean(sham.all.acc),'LineWidth',LINW);
    plot(.25:.5:6.75, mean(shock.all.acc),'r','LineWidth',LINW);
    title('All Trials Daily Average','FontName',FONT, 'FontSize', TFSZ);
    axis([0 7 XaxisMIN 1]);
    %axes('AxesFontSize', 14); %'FontName',FONT, 'FontSize', AFSZ);
    legend('sham','shock', 'Location', 'SouthEast');
    xlabel('Day','FontName',FONT, 'FontSize', AFSZ);
    ylabel('Probability Correct','FontName',FONT, 'FontSize', AFSZ);
    %set(gcf,'DefaultLineLineWidth',4);
    print(h,'-r600','-depsc2','-painters', [FigName '_Daily_All.eps']); % save figure to .eps file for ai (resave as .jpg for best ppt)
    
    
    h=figure('DefaultAxesFontSize', AFSZ,'paperpositionmode','auto', 'color','white','InvertHardcopy','off');
    hold;
    hBar= bar(.25:.5:6.75,rem(2:DAYS*2+1, 2),'FaceColor',[RGBL RGBL RGBL],'EdgeColor', 'none','BaseValue', XaxisMIN, 'BarWidth', 1);
    set(get(get(hBar,'Annotation'),'LegendInformation'),...
        'IconDisplayStyle','off'); % Exclude lines of bar graph from the legend
    %alpha(.1)
    plot(.25:.5:6.75, mean(sham.inb.acc),'LineWidth',LINW);
    plot(.25:.5:6.75, mean(shock.inb.acc),'r','LineWidth',LINW);
    title('Inbound Daily Average','FontName',FONT, 'FontSize', TFSZ);
    axis([0 7 XaxisMIN 1]);
    legend('sham','shock', 'Location', 'SouthEast');
    xlabel('Day','FontName',FONT, 'FontSize', AFSZ);
    ylabel('Probability Correct','FontName',FONT, 'FontSize', AFSZ);
    print(h,'-r600','-depsc2','-painters', [FigName '_Daily_Inb.eps']); % save figure to .eps file for ai (resave as .jpg for best ppt)
    
    
    h=figure('DefaultAxesFontSize', AFSZ,'paperpositionmode','auto', 'color','white','InvertHardcopy','off');
    hold;
    hBar= bar(.25:.5:6.75,rem(2:DAYS*2+1, 2),'FaceColor',[RGBL RGBL RGBL],'EdgeColor', 'none', 'BaseValue', XaxisMIN, 'BarWidth', 1);
    set(get(get(hBar,'Annotation'),'LegendInformation'),...
        'IconDisplayStyle','off'); % Exclude lines of bar graph from the legend
    %alpha(.1)
    plot(.25:.5:6.75, mean(sham.outb.acc),'LineWidth',LINW);
    plot(.25:.5:6.75, mean(shock.outb.acc),'r','LineWidth',LINW);
    title('Outbound Daily Average','FontName',FONT, 'FontSize', TFSZ);
    axis([0 7 XaxisMIN 1]);
    legend('sham','shock', 'Location', 'SouthEast');
    xlabel('Day','FontName',FONT, 'FontSize', AFSZ);
    ylabel('Probability Correct','FontName',FONT, 'FontSize', AFSZ);
    print(h,'-r600','-depsc2','-painters', [FigName '_Daily_Outb.eps']); % save figure to .eps file for ai (resave as .jpg for best ppt)
    
end % end suppress figures


% **************
% PLOT RUNNING AVERAGES WITH SHOCK/SHAM GROUPS AVERAGED TOGETHER

% SUPPRESS OUTPUT with if statement
if fig_runavg
    
    h=figure('DefaultAxesFontSize', AFSZ,'paperpositionmode','auto', 'color','white','InvertHardcopy','off');
    hold;
    plot(mean(sham.all.runAvg(:,RUNAVG:end-RUNAVG)),'LineWidth',LINW);
    plot(mean(shock.all.runAvg(:,RUNAVG:end-RUNAVG)),'r','LineWidth',LINW); %shift by RUNAVG so Avg reflects session
    title(['All Trials Running ', num2str(RUNAVG), ' Block Average'],'FontName',FONT, 'FontSize', TFSZ);
    axis([0 length(shock.all.runAvg) .3 1]);
    axis('auto x');
    legend('sham','shock', 'Location', 'SouthEast');
    xlabel('Trials','FontName',FONT, 'FontSize', AFSZ);
    ylabel('Probability Correct','FontName',FONT, 'FontSize', AFSZ);
    print(h,'-r600','-depsc2','-painters', [FigName '_RunAvg_All.eps']); % save figure to .eps file for ai (resave as .jpg for best ppt)
    
    
    h=figure('DefaultAxesFontSize', AFSZ,'paperpositionmode','auto', 'color','white','InvertHardcopy','off');
    hold;
    plot(mean(sham.inb.runAvg(:,RUNAVG:end-RUNAVG)),'LineWidth',LINW);
    plot(mean(shock.inb.runAvg(:,RUNAVG:end-RUNAVG)),'r','LineWidth',LINW); %shift by RUNAVG so Avg reflects session
    title(['Inbound Running ', num2str(RUNAVG), ' Block Average'],'FontName',FONT, 'FontSize', TFSZ);
    axis([0 length(shock.inb.runAvg)-RUNAVG .3 1]);
    axis('auto x');
    legend('sham','shock', 'Location', 'SouthEast');
    xlabel('Trials','FontName',FONT, 'FontSize', AFSZ);
    ylabel('Probability Correct','FontName',FONT, 'FontSize', AFSZ);
    print(h,'-r600','-depsc2','-painters', [FigName '_RunAvg_Inb.eps']); % save figure to .eps file for ai (resave as .jpg for best ppt)
    
    
    h=figure('DefaultAxesFontSize', AFSZ,'paperpositionmode','auto', 'color','white','InvertHardcopy','off'); %figure('DefaultAxesFontSize', AFSZ);
    hold;
    plot(mean(sham.outb.runAvg(:,RUNAVG:end-RUNAVG)),'LineWidth',LINW);
    plot(mean(shock.outb.runAvg(:,RUNAVG:end-RUNAVG)),'r','LineWidth',LINW); %shift by RUNAVG so Avg reflects session
    title(['Outbound Running ', num2str(RUNAVG), ' Block Average'],'FontName',FONT, 'FontSize', TFSZ);
    axis([0 length(shock.outb.runAvg) .3 1]);
    axis('auto x');
    legend('sham','shock', 'Location', 'SouthEast');
    xlabel('Trials','FontName',FONT, 'FontSize', AFSZ);
    ylabel('Probability Correct','FontName',FONT, 'FontSize', AFSZ);
    print(h,'-r600','-depsc2','-painters', [FigName '_RunAvg_Outb.eps']); % save figure to .eps file for ai (resave as .jpg for best ppt)
    
end % end suppress figure


% PLOT DAILY AVERAGES WITH SHOCK/SHAM INDIVIDUALS BY COLOR
%
% SUPPRESS OUTPUT with if statement
if fig_daily_indiv
    
    h=figure('DefaultAxesFontSize', AFSZ,'paperpositionmode','auto', 'color','white','InvertHardcopy','off'); %'position',[100 0 1100 1100]
    % plot something...  'color' 'none' for transparency
    %figure('DefaultAxesFontSize', AFSZ, 'color','white','Renderer', 'Painter'); % 'Position',[1 scrsz(4)/2 600 450]);
    hold;
    hBar = bar(.25:.5:6.75,rem(2:DAYS*2+1, 2),'FaceColor',[RGBL RGBL RGBL],'EdgeColor', 'none','BaseValue', XaxisMIN, 'BarWidth', 1); %'FaceColor',[.8 .8 .8], 'EdgeColor', [.8 .8 .8]);
    %alpha(.1)
    set(get(get(hBar,'Annotation'),'LegendInformation'),...
        'IconDisplayStyle','off'); % Exclude lines of bar graph from the legend
    for ani = 1:length(names)
        if dio{ani}.shock % shock(ani) true
            plot(.25:.5:6.75,dio{ani}.stats.all.acc(:),'r','LineWidth',LINW);
        else
            plot(.25:.5:6.75,dio{ani}.stats.all.acc(:),'LineWidth',LINW);
        end
    end
    title('Individual Daily Averages','FontName',FONT, 'FontSize', TFSZ); %, 'FontWeight', FNTW);%[{'Individual Daily Averages'};{'shock=red, sham=blue'}]
    legend('sham','shock', 'Location', 'SouthEast');
    axis([0 7 XaxisMIN 1]);
    xlabel('Day','FontName',FONT, 'FontSize', AFSZ); %, 'FontWeight', FNTW);%[{'Day'}; {'run1 = white, run2 = shaded'}]
    ylabel('Probability Correct','FontName',FONT, 'FontSize', AFSZ); %, 'FontWeight', FNTW);
    print(h,'-r600','-depsc2','-painters', [FigName '_DailyInd_All.eps']); % save figure to .eps file for ai (resave as .jpg for best ppt)
    
    
    
    h=figure('DefaultAxesFontSize', AFSZ,'paperpositionmode','auto', 'color','white','InvertHardcopy','off'); %'position',[100 0 1100 1100]
    % plot something...  'color' 'none' for transparency
    %figure('DefaultAxesFontSize', AFSZ, 'color','white','Renderer', 'Painter'); % 'Position',[1 scrsz(4)/2 600 450]);
    hold;
    hBar = bar(.25:.5:6.75,rem(2:DAYS*2+1, 2),'FaceColor',[RGBL RGBL RGBL],'EdgeColor', 'none','BaseValue', XaxisMIN, 'BarWidth', 1); %'FaceColor',[.8 .8 .8], 'EdgeColor', [.8 .8 .8]);
    %alpha(.1)
    set(get(get(hBar,'Annotation'),'LegendInformation'),...
        'IconDisplayStyle','off'); % Exclude lines of bar graph from the legend
    for ani = 1:length(names)
        if dio{ani}.shock % shock(ani) true
            plot(.25:.5:6.75,dio{ani}.stats.inb.acc(:),'r','LineWidth',LINW);
        else
            plot(.25:.5:6.75,dio{ani}.stats.inb.acc(:),'LineWidth',LINW);
        end
    end
    title('Individual Inbound Daily Averages','FontName',FONT, 'FontSize', TFSZ); %, 'FontWeight', FNTW);%[{'Individual Daily Averages'};{'shock=red, sham=blue'}]
    legend('sham','shock', 'Location', 'SouthEast');
    axis([0 7 XaxisMIN 1]);
    xlabel('Day','FontName',FONT, 'FontSize', AFSZ); %, 'FontWeight', FNTW);%[{'Day'}; {'run1 = white, run2 = shaded'}]
    ylabel('Probability Correct','FontName',FONT, 'FontSize', AFSZ); %, 'FontWeight', FNTW);
    print(h,'-r600','-depsc2','-painters', [FigName '_DailyInd_Inb.eps']); % save figure to .eps file for ai (resave as .jpg for best ppt)
    
    
    h=figure('DefaultAxesFontSize', AFSZ,'paperpositionmode','auto', 'color','white','InvertHardcopy','off'); %'position',[100 0 1100 1100]
    % plot something...  'color' 'none' for transparency
    %figure('DefaultAxesFontSize', AFSZ, 'color','white','Renderer', 'Painter'); % 'Position',[1 scrsz(4)/2 600 450]);
    hold;
    hBar = bar(.25:.5:6.75,rem(2:DAYS*2+1, 2),'FaceColor',[RGBL RGBL RGBL],'EdgeColor', 'none','BaseValue', XaxisMIN, 'BarWidth', 1); %'FaceColor',[.8 .8 .8], 'EdgeColor', [.8 .8 .8]);
    %alpha(.1)
    set(get(get(hBar,'Annotation'),'LegendInformation'),...
        'IconDisplayStyle','off'); % Exclude lines of bar graph from the legend
    for ani = 1:length(names)
        if dio{ani}.shock % shock(ani) true
            plot(.25:.5:6.75,dio{ani}.stats.outb.acc(:),'r','LineWidth',LINW);
        else
            plot(.25:.5:6.75,dio{ani}.stats.outb.acc(:),'LineWidth',LINW);
        end
    end
    title('Individual Outbound Daily Averages','FontName',FONT, 'FontSize', TFSZ); %, 'FontWeight', FNTW);%[{'Individual Daily Averages'};{'shock=red, sham=blue'}]
    legend('sham','shock', 'Location', 'SouthEast');
    axis([0 7 XaxisMIN 1]);
    xlabel('Day','FontName',FONT, 'FontSize', AFSZ); %, 'FontWeight', FNTW);%[{'Day'}; {'run1 = white, run2 = shaded'}]
    ylabel('Probability Correct','FontName',FONT, 'FontSize', AFSZ); %, 'FontWeight', FNTW);
    print(h,'-r600','-depsc2','-painters', [FigName '_DailyInd_Outb.eps']); % save figure to .eps file for ai (resave as .jpg for best ppt)
    
    
end % end suppress figure

%
% PLOT EPOCHS SUPERIMPOSED
%
if fig_epochs
    
    h=figure('DefaultAxesFontSize', AFSZ,'paperpositionmode','auto', 'color','white','InvertHardcopy','off'); %'position',[100 0 1100 1100]
    hold;
    hBar = bar(0.25:.5:.75,rem(2:3, 2),'FaceColor',[RGBL RGBL RGBL],'EdgeColor', 'none','BaseValue', XaxisMIN, 'BarWidth', 1); %'FaceColor',[.8 .8 .8], 'EdgeColor', [.8 .8 .8]);
    %alpha(.1)
    set(get(get(hBar,'Annotation'),'LegendInformation'),...
        'IconDisplayStyle','off'); % Exclude lines of bar graph from the legend
    for ani = 1:length(names)
        if dio{ani}.shock % shock(ani) true
            plot(.25:.5:.75,dio{ani}.stats.all.acc(:,1:3),'r','LineWidth',LINW);
        else
            plot(.25:.5:.75,dio{ani}.stats.all.acc(:,1:3),'b','LineWidth',LINW);
        end
    end
    title('Individual Accuracy by Epoch (Days 1-3)','FontName',FONT, 'FontSize', TFSZ); %, 'FontWeight', FNTW);%[{'Individual Daily Averages'};{'shock=red, sham=blue'}]
    % legend('sham','shock', 'Location', 'SouthEast');
    axis([0 1 XaxisMIN 1]);
    set(gca,'XTick',[0.25 .75]);
    set(gca,'XTickLabel','1|2');
    xlabel('Epoch','FontName',FONT, 'FontSize', AFSZ); %, 'FontWeight', FNTW);%[{'Day'}; {'run1 = white, run2 = shaded'}]
    ylabel('Probability Correct','FontName',FONT, 'FontSize', AFSZ); %, 'FontWeight', FNTW);
    print(h,'-r600','-depsc2','-painters', [FigName '_Epochs_All.eps']); % save figure to .eps file for ai (resave as .jpg for best ppt)
    
    
    %
    h=figure('DefaultAxesFontSize', AFSZ,'paperpositionmode','auto', 'color','white','InvertHardcopy','off'); %'position',[100 0 1100 1100]
    hold;
    hBar = bar(0.25:.5:.75,rem(2:3, 2),'FaceColor',[RGBL RGBL RGBL],'EdgeColor', 'none','BaseValue', XaxisMIN, 'BarWidth', 1); %'FaceColor',[.8 .8 .8], 'EdgeColor', [.8 .8 .8]);
    %alpha(.1)
    set(get(get(hBar,'Annotation'),'LegendInformation'),...
        'IconDisplayStyle','off'); % Exclude lines of bar graph from the legend
    for ani = 1:length(names)
        if dio{ani}.shock % shock(ani) true
            plot(.25:.5:.75,dio{ani}.stats.inb.acc(:,1:3),'r','LineWidth',LINW);
        else
            plot(.25:.5:.75,dio{ani}.stats.inb.acc(:,1:3),'b','LineWidth',LINW);
        end
    end
    title('Individual Inbound Accuracy by Epoch (Days 1-3)','FontName',FONT, 'FontSize', TFSZ); %, 'FontWeight', FNTW);%[{'Individual Daily Averages'};{'shock=red, sham=blue'}]
    % legend('sham','shock', 'Location', 'SouthEast');
    axis([0 1 XaxisMIN 1]);
    set(gca,'XTick',[0.25 .75]);
    set(gca,'XTickLabel','1|2');
    xlabel('Epoch','FontName',FONT, 'FontSize', AFSZ); %, 'FontWeight', FNTW);%[{'Day'}; {'run1 = white, run2 = shaded'}]
    ylabel('Probability Correct','FontName',FONT, 'FontSize', AFSZ); %, 'FontWeight', FNTW);
    print(h,'-r600','-depsc2','-painters', [FigName '_Epochs_Inb.eps']); % save figure to .eps file for ai (resave as .jpg for best ppt)
    
    %
    h=figure('DefaultAxesFontSize', AFSZ,'paperpositionmode','auto', 'color','white','InvertHardcopy','off'); %'position',[100 0 1100 1100]
    hold;
    hBar = bar(0.25:.5:.75,rem(2:3, 2),'FaceColor',[RGBL RGBL RGBL],'EdgeColor', 'none','BaseValue', XaxisMIN, 'BarWidth', 1); %'FaceColor',[.8 .8 .8], 'EdgeColor', [.8 .8 .8]);
    %alpha(.1)
    set(get(get(hBar,'Annotation'),'LegendInformation'),...
        'IconDisplayStyle','off'); % Exclude lines of bar graph from the legend
    for ani = 1:length(names)
        if dio{ani}.shock % shock(ani) true
            plot(.25:.5:.75,dio{ani}.stats.outb.acc(:,1:3),'r','LineWidth',LINW);
        else
            plot(.25:.5:.75,dio{ani}.stats.outb.acc(:,1:3),'b','LineWidth',LINW);
        end
    end
    title('Individual Outbound Accuracy by Epoch (Days 1-3)','FontName',FONT, 'FontSize', TFSZ); %, 'FontWeight', FNTW);%[{'Individual Daily Averages'};{'shock=red, sham=blue'}]
    % legend('sham','shock', 'Location', 'SouthEast');
    axis([0 1 XaxisMIN 1]);
    set(gca,'XTick',[0.25 .75]);
    set(gca,'XTickLabel','1|2');
    xlabel('Epoch','FontName',FONT, 'FontSize', AFSZ); %, 'FontWeight', FNTW);%[{'Day'}; {'run1 = white, run2 = shaded'}]
    ylabel('Probability Correct','FontName',FONT, 'FontSize', AFSZ); %, 'FontWeight', FNTW);
    print(h,'-r600','-depsc2','-painters', [FigName '_Epochs_Outb.eps']); % save figure to .eps file for ai (resave as .jpg for best ppt)
    
    % separate Shock and Sham on Inbound Epoch
    %
    h=figure('DefaultAxesFontSize', AFSZ,'paperpositionmode','auto', 'color','white','InvertHardcopy','off'); %'position',[100 0 1100 1100]
    hold;
    hBar = bar(0.25:.5:.75,rem(2:3, 2),'FaceColor',[RGBL RGBL RGBL],'EdgeColor', 'none','BaseValue', XaxisMIN, 'BarWidth', 1); %'FaceColor',[.8 .8 .8], 'EdgeColor', [.8 .8 .8]);
    %alpha(.1)
    set(get(get(hBar,'Annotation'),'LegendInformation'),...
        'IconDisplayStyle','off'); % Exclude lines of bar graph from the legend
    for ani = 1:length(names)
        if dio{ani}.shock % shock(ani) true
            plot(.25:.5:.75,dio{ani}.stats.inb.acc(:,1:3),'r','LineWidth',LINW);
        else
            % plot(.25:.5:.75,dio{ani}.stats.inb.acc(:,1:3),'b','LineWidth',LINW);
        end
    end
    title('Individual Inbound Accuracy by Epoch (Days 1-3)','FontName',FONT, 'FontSize', TFSZ); %, 'FontWeight', FNTW);%[{'Individual Daily Averages'};{'shock=red, sham=blue'}]
    legend('shock', 'Location', 'SouthEast');
    axis([0 1 XaxisMIN 1]);
    set(gca,'XTick',[0.25 .75]);
    set(gca,'XTickLabel','1|2');
    xlabel('Epoch','FontName',FONT, 'FontSize', AFSZ); %, 'FontWeight', FNTW);%[{'Day'}; {'run1 = white, run2 = shaded'}]
    ylabel('Probability Correct','FontName',FONT, 'FontSize', AFSZ); %, 'FontWeight', FNTW);
    print(h,'-r600','-depsc2','-painters', [FigName '_Epochs_Inb_Shock.eps']); % save figure to .eps file for ai (resave as .jpg for best ppt)
    
    h=figure('DefaultAxesFontSize', AFSZ,'paperpositionmode','auto', 'color','white','InvertHardcopy','off'); %'position',[100 0 1100 1100]
    hold;
    hBar = bar(0.25:.5:.75,rem(2:3, 2),'FaceColor',[RGBL RGBL RGBL],'EdgeColor', 'none','BaseValue', XaxisMIN, 'BarWidth', 1); %'FaceColor',[.8 .8 .8], 'EdgeColor', [.8 .8 .8]);
    %alpha(.1)
    set(get(get(hBar,'Annotation'),'LegendInformation'),...
        'IconDisplayStyle','off'); % Exclude lines of bar graph from the legend
    for ani = 1:length(names)
        if dio{ani}.shock % shock(ani) true
            % plot(.25:.5:.75,dio{ani}.stats.inb.acc(:,1:3),'r','LineWidth',LINW);
        else
            plot(.25:.5:.75,dio{ani}.stats.inb.acc(:,1:3),'b','LineWidth',LINW);
        end
    end
    title('Individual Inbound Accuracy by Epoch (Days 1-3)','FontName',FONT, 'FontSize', TFSZ); %, 'FontWeight', FNTW);%[{'Individual Daily Averages'};{'shock=red, sham=blue'}]
    legend('sham', 'Location', 'SouthEast');
    axis([0 1 XaxisMIN 1]);
    set(gca,'XTick',[0.25 .75]);
    set(gca,'XTickLabel','1|2');
    xlabel('Epoch','FontName',FONT, 'FontSize', AFSZ); %, 'FontWeight', FNTW);%[{'Day'}; {'run1 = white, run2 = shaded'}]
    ylabel('Probability Correct','FontName',FONT, 'FontSize', AFSZ); %, 'FontWeight', FNTW);
    print(h,'-r600','-depsc2','-painters', [FigName '_Epochs_Inb_Sham.eps']); % save figure to .eps file for ai (resave as .jpg for best ppt)
    
end % end suppression of printing


%
% SCATTER PLOT ACCURACY VS ATTEMPTS
%
if fig_scatter
    
    figure
    scatter(shock.all.atm(:), shock.all.acc(:), 'r', 'filled');
    hold;
    scatter(sham.all.atm(:), sham.all.acc(:), 'filled', 'b');
    scatter(mean(shock.all.atm(:)), mean(shock.all.acc(:)), 200, 'r');
    scatter(mean(sham.all.atm(:)), mean(sham.all.acc(:)), 200, 'b');
    
    x1 = shock.all.atm(:);
    X1 = [ones(size(x1)) x1];
    [b,bint,r,rint,regstats1] = regress(shock.all.acc(:),X1);
    x1fit = min(x1):.1:max(x1);
    y1fit = b(1) + b(2)*x1fit;
    plot(x1fit,y1fit, 'r');
    x2 = sham.all.atm(:);
    X2 = [ones(size(x2)) x2];
    [b,bint,r,rint,regstats2] = regress(sham.all.acc(:),X2);
    x2fit = min(x2):.1:max(x2);
    y2fit = b(1) + b(2)*x2fit;
    plot(x2fit,y2fit);
    title(['SHOCK: R^2=' num2str(regstats1(1), 2) ,' p=' num2str(regstats1(3), 2) ...
        '  SHAM: R^2 =' num2str(regstats2(1), 2) ,' p=', num2str(regstats2(3), 2)]);
    xlabel('Same Epoch Trials','FontName',FONT, 'FontSize', AFSZ); %, 'FontWeight', FNTW);%[{'Day'}; {'run1 = white, run2 = shaded'}]
    ylabel('Probability Correct','FontName',FONT, 'FontSize', AFSZ); %, 'FontWeight', FNTW);
    
    
    figure;
    scatter(shock.inb.atm(:), shock.inb.acc(:), 'r', 'filled');
    hold;
    scatter(sham.inb.atm(:), sham.inb.acc(:), 'filled', 'b');
    scatter(mean(shock.inb.atm(:)), mean(shock.inb.acc(:)), 200, 'r');
    scatter(mean(sham.inb.atm(:)), mean(sham.inb.acc(:)), 200, 'b');
    
    x1 = shock.inb.atm(:);
    X1 = [ones(size(x1)) x1];
    [b,bint,r,rint,regstats1] = regress(shock.inb.acc(:),X1);
    x1fit = min(x1):.1:max(x1);
    y1fit = b(1) + b(2)*x1fit;
    plot(x1fit,y1fit, 'r');
    x2 = sham.inb.atm(:);
    X2 = [ones(size(x2)) x2];
    [b,bint,r,rint,regstats2] = regress(sham.inb.acc(:),X2);
    x2fit = min(x2):.1:max(x2);
    y2fit = b(1) + b(2)*x2fit;
    plot(x2fit,y2fit);
    title(['Inbound SHOCK: R^2=' num2str(regstats1(1), 2) ,' p=' num2str(regstats1(3), 2) ...
        '  SHAM: R^2 =' num2str(regstats2(1), 2) ,' p=', num2str(regstats2(3), 2)]);
    
    
    figure;
    scatter(shock.outb.atm(:), shock.outb.acc(:), 'r', 'filled');
    hold;
    scatter(sham.outb.atm(:), sham.outb.acc(:), 'filled', 'b');
    scatter(mean(shock.outb.atm(:)), mean(shock.outb.acc(:)), 200, 'r');
    scatter(mean(sham.outb.atm(:)), mean(sham.outb.acc(:)), 200, 'b');
    
    x1 = shock.outb.atm(:);
    X1 = [ones(size(x1)) x1];
    [b,bint,r,rint,regstats1] = regress(shock.outb.acc(:),X1);
    x1fit = min(x1):.1:max(x1);
    y1fit = b(1) + b(2)*x1fit;
    plot(x1fit,y1fit, 'r');
    x2 = sham.outb.atm(:);
    X2 = [ones(size(x2)) x2];
    [b,bint,r,rint,regstats2] = regress(sham.outb.acc(:),X2);
    x2fit = min(x2):.1:max(x2);
    y2fit = b(1) + b(2)*x2fit;
    plot(x2fit,y2fit);
    title(['Outbound SHOCK: R^2=' num2str(regstats1(1), 2) ,' p=' num2str(regstats1(3), 2) ...
        '  SHAM: R^2 =' num2str(regstats2(1), 2) ,' p=', num2str(regstats2(3), 2)]);
    
    
    
    % calculate cumulative number of attempts
    shock.all.atmc = [];
    sham.all.atmc = [];
    shock.inb.atmc = [];
    sham.inb.atmc = [];   %initialcond
    shock.outb.atmc = [];
    sham.outb.atmc = [];
    
    for i= 1:length(shock.all.atm)
        shock.all.atmc = [shock.all.atmc sum(shock.all.atm(:,1:i),2)];
        sham.all.atmc = [sham.all.atmc sum(sham.all.atm(:,1:i),2)];
        shock.inb.atmc = [shock.inb.atmc sum(shock.inb.atm(:,1:i),2)];
        sham.inb.atmc = [sham.inb.atmc sum(sham.inb.atm(:,1:i),2)];
        shock.outb.atmc = [shock.outb.atmc sum(shock.outb.atm(:,1:i),2)];
        sham.outb.atmc = [sham.outb.atmc sum(sham.outb.atm(:,1:i),2)];
        
    end
    
    figure
    scatter(shock.all.atmc(:), shock.all.acc(:), 'r', 'filled');
    hold;
    scatter(sham.all.atmc(:), sham.all.acc(:), 'filled', 'b');
    scatter(mean(shock.all.atmc(:)), mean(shock.all.acc(:)), 200, 'r');
    scatter(mean(sham.all.atmc(:)), mean(sham.all.acc(:)), 200, 'b');
    
    x1 = shock.all.atmc(:);
    X1 = [ones(size(x1)) x1];
    [b,bint,r,rint,regstats1] = regress(shock.all.acc(:),X1);
    x1fit = min(x1):.1:max(x1);
    y1fit = b(1) + b(2)*x1fit;
    plot(x1fit,y1fit, 'r');
    x2 = sham.all.atmc(:);
    X2 = [ones(size(x2)) x2];
    [b,bint,r,rint,regstats2] = regress(sham.all.acc(:),X2);
    x2fit = min(x2):.1:max(x2);
    y2fit = b(1) + b(2)*x2fit;
    plot(x2fit,y2fit);
    title(['SHOCK: R^2=' num2str(regstats1(1), 2) ,' p=' num2str(regstats1(3), 2) ...
        '  SHAM: R^2 =' num2str(regstats2(1), 2) ,' p=', num2str(regstats2(3), 2)]);
    xlabel('Cumulative Trials','FontName',FONT, 'FontSize', AFSZ); %, 'FontWeight', FNTW);%[{'Day'}; {'run1 = white, run2 = shaded'}]
    ylabel('Probability Correct','FontName',FONT, 'FontSize', AFSZ); %, 'FontWeight', FNTW);
    
    
    
    figure
    scatter(shock.inb.atmc(:), shock.inb.acc(:), 'r', 'filled');
    hold;
    scatter(sham.inb.atmc(:), sham.inb.acc(:), 'filled', 'b');
    scatter(mean(shock.inb.atmc(:)), mean(shock.inb.acc(:)), 200, 'r');
    scatter(mean(sham.inb.atmc(:)), mean(sham.inb.acc(:)), 200, 'b');
    
    x1 = shock.inb.atmc(:);
    X1 = [ones(size(x1)) x1];
    [b,bint,r,rint,regstats1] = regress(shock.inb.acc(:),X1);
    x1fit = min(x1):.1:max(x1);
    y1fit = b(1) + b(2)*x1fit;
    plot(x1fit,y1fit, 'r');
    x2 = sham.inb.atmc(:);
    X2 = [ones(size(x2)) x2];
    [b,bint,r,rint,regstats2] = regress(sham.inb.acc(:),X2);
    x2fit = min(x2):.1:max(x2);
    y2fit = b(1) + b(2)*x2fit;
    plot(x2fit,y2fit);
    title(['Inbound SHOCK: R^2=' num2str(regstats1(1), 2) ,' p=' num2str(regstats1(3), 2) ...
        '  SHAM: R^2 =' num2str(regstats2(1), 2) ,' p=', num2str(regstats2(3), 2)]);
    
    
    %figureinitialcond
    scatter(shock.outb.atmc(:), shock.outb.acc(:), 'r', 'filled');
    hold;
    scatter(sham.outb.atmc(:), sham.outb.acc(:), 'filled', 'b');
    scatter(mean(shock.outb.atmc(:)), mean(shock.outb.acc(:)), 200, 'r');
    scatter(mean(sham.outb.atmc(:)), mean(sham.outb.acc(:)), 200, 'b');
    
    x1 = shock.outb.atmc(:);
    X1 = [ones(size(x1)) x1];
    [b,bint,r,rint,regstats1] = regress(shock.outb.acc(:),X1);
    x1fit = min(x1):.1:max(x1);
    y1fit = b(1) + b(2)*x1fit;
    plot(x1fit,y1fit, 'r');
    x2 = sham.outb.atmc(:);
    X2 = [ones(size(x2)) x2];
    [b,bint,r,rint,regstats2] = regress(sham.outb.acc(:),X2);
    x2fit = min(x2):.1:max(x2);
    y2fit = b(1) + b(2)*x2fit;
    plot(x2fit,y2fit);
    title(['Outbound SHOCK: R^2=' num2str(regstats1(1), 2) ,' p=' num2str(regstats1(3), 2) ...
        '  SHAM: R^2 =' num2str(regstats2(1), 2) ,' p=', num2str(regstats2(3), 2)]);
    
    % linear fit and cor1relation coef / coefficient of determination
    % ??? glmfit() function gives similar values except corrcoef are wrong [glmf devf statfit]= glmfit(shock.all.atm(:), shock.all.acc(:));
    
end % end suppression of printing

%
% SMITH(2003) ESTIMATED PROBABILITY CORRECT
%
% use supporting functions from Shantanu
%
% SUPPRESS OUTPUT with if statement
if fig_estprob
    
    % all trials
    for ani=1:length(names)
        all_alltrials_logic = dio{ani}.all(:,REW);
        
        [pc, lt] = getestprobcorrect(all_alltrials_logic, 0.5, 2, 0);
        alltrials_curve_witherr = pc(2:end,:);
        alltrials_curve = pc(2:end,1);
        alltrials_lowerr = pc(2:end,2);
        alltrials_uperr = pc(2:end,3);
        alltrials_learningtrial = lt;
        
        figure; hold on; %redimscreen_figforppt1;
        %redimscreen;
        orient(gcf,'portrait'); hold on; set(gcf, 'PaperPositionMode', 'auto');
        set(0,'defaultaxesfontsize',20);set(0,'defaultaxesfontweight','normal');
        set(0,'defaultaxeslinewidth',2);
        
        % Get time (day) axis
        t = 1:size(pc,1)-1;
        %%% Plot data %%
        plot(t', pc(2:end,1),'r-', 'Linewidth', 2);
        taxis = t';
        data=[pc(2:end,2),pc(2:end,3)];
        % plot(t', pc(2:end,2),'m--', 'Linewidth', 2);
        % plot(t', pc(2:end,3),'m--', 'Linewidth', 2);
        jbfill(taxis',pc(2:end,3)',pc(2:end,2)','r','r',1, JBA);
        axis tight;
        ylim([.3 1]);
        %axis([0 300 .4 1]);
        %axis('auto-x');
        
        title(['All Trials Learning Curve, ' names(ani)]);
    end
    
end % end suppression of printing

if fig_estprob_inb
    % inbound
    for ani=1:length(names)
        all_inbound_logic = dio{ani}.inb(:,REW);
        
        [pc, lt] = getestprobcorrect(all_inbound_logic, 0.5, 2, 0);
        inbound_curve_witherr = pc(2:end,:);
        inbound_curve = pc(2:end,1);
        inbound_lowerr = pc(2:end,2);
        inbound_uperr = pc(2:end,3);
        inbound_learningtrial = lt;
        
        figure; hold on; %redimscreen_figforppt1;
        %redimscreen;
        orient(gcf,'portrait'); hold on; set(gcf, 'PaperPositionMode', 'auto');
        set(0,'defaultaxesfontsize',20);set(0,'defaultaxesfontweight','normal');
        set(0,'defaultaxeslinewidth',2);
        
        % Get time (day) axis
        t = 1:size(pc,1)-1;
        %%% Plot data %%
        plot(t', pc(2:end,1),'r-', 'Linewidth', 2);
        taxis = t';
        data=[pc(2:end,2),pc(2:end,3)];
        % plot(t', pc(2:end,2),'m--', 'Linewidth', 2);
        % plot(t', pc(2:end,3),'m--', 'Linewidth', 2);
        jbfill(taxis',pc(2:end,3)',pc(2:end,2)','r','r',1, JBA);
        axis tight;
        ylim([.3 1]);
        %axis([0 300 .4 1]);
        %axis('auto-x');
        title(['Inbound Learning Curve, ' names(ani)]);
    end
end % end suppression of printing

if fig_estprob_outb
    % outbound
    for ani=1:length(names)
        all_outbound_logic = dio{ani}.outb(:,REW);
        
        [pc, lt] = getestprobcorrect(all_outbound_logic, 0.5, 2, 0);
        outbound_curve_witherr = pc(2:end,:);
        outbound_curve = pc(2:end,1);
        outbound_lowerr = pc(2:end,2);
        outbound_uperr = pc(2:end,3);
        outbound_learningtrial = lt;
        
        figure; hold on; %redimscreen_figforppt1;
        %redimscreen;
        orient(gcf,'portrait'); hold on; set(gcf, 'PaperPositionMode', 'auto');
        set(0,'defaultaxesfontsize',20);set(0,'defaultaxesfontweight','normal');
        set(0,'defaultaxeslinewidth',2);
        
        % Get time (day) axis
        t = 1:size(pc,1)-1;
        %%% Plot data %%
        plot(t', pc(2:end,1),'r-', 'Linewidth', 2);
        taxis = t';
        data=[pc(2:end,2),pc(2:end,3)];
        % plot(t', pc(2:end,2),'m--', 'Linewidth', 2);
        % plot(t', pc(2:end,3),'m--', 'Linewidth', 2);
        jbfill(taxis',pc(2:end,3)',pc(2:end,2)','r','r',1, JBA);
        axis tight;
        ylim([.3 1]);
        %axis([0 300 .4 1]);
        %axis('auto-x');
        title(['Outbound Learning Curve, ' names(ani)]);
    end
end % end suppression of printing



%
% DISTRIBUTION OF TIMES BETWEEN TRIALS
%
if fig_time_distr
    % dio{ani}.all(:,TIM)
    %
    % REW =1;
    % columns of array times{} are 'reward' 'time' 'diff adjacent time'...
    % 'times since epoch start' 'outbound'
    %
    
    
    
    xbins = 5:10:295; % inter-trial interval
    
    figure;
    hist(allTimes/10000, xbins);
    axis([0 300 0 500]);
    axis('auto-y');
    %hold;
    % plot(ones(mean(allTimes/10000),
    
    % 3D surface of within epoch time
    nhist3 = [];
    for i =1:length(ybins)
        nhist3(i,:) = hist(epochTimes{i}/10000, xbins);
    end
    [X,Y] = meshgrid(1:30,1:25);
    figure;
    surf(X,Y,nhist3)%,'EdgeColor','black')
    load abef_ColorMap2;
    colormap(abef_ColorMap2);
    
end % end suppression of printing


%
% VISUALIZE SLOW CHANGE IN ACCURACY ACROSS EPOCHS
%
% shock/sham, epoch1/2, days3/6 (all epochs & days), all/inb/outb
%
%
%
if fig_interleave_epochs
    
    
    interleave.shock.d1_3.all = cell(EPOCHS,1);
    interleave.shock.d1_3.inb = cell(EPOCHS,1);
    interleave.sham.d1_3.all = cell(EPOCHS,1);
    interleave.sham.d1_3.inb = cell(EPOCHS,1);
    
    
    
    for r = 1:EPOCHS
        for ani = 1:length(names)
            for d = 1:3 % DAYS
                if shocks(ani)
                    interleave.shock.d1_3.all{r} = [interleave.shock.d1_3.all{r} ...
                        ;times{ani,d,r}(:,1) times{ani,d,r}(:,4) times{ani,d,r}(:,5)]; % 'reward' 'time since epoch start' 'outbound'
                else
                    interleave.sham.d1_3.all{r} = [interleave.sham.d1_3.all{r} ...
                        ;times{ani,d,r}(:,1) times{ani,d,r}(:,4) times{ani,d,r}(:,5)]; % 'reward' 'time since epoch start' 'outbound'
                end % if shock
            end % days
        end % ani
        inter_sort = sortrows(interleave.shock.d1_3.all{r}, 3);
        i = find(inter_sort(:,3), 1, 'first');
        interleave.shock.d1_3.inb{r} =  inter_sort(1:i-1,:);
        interleave.shock.d1_3.outb{r} =  inter_sort(i:end,:);
        % sham x2
        inter_sort = sortrows(interleave.sham.d1_3.all{r}, 3);
        i = find(inter_sort(:,3), 1, 'first');
        interleave.sham.d1_3.inb{r} =  inter_sort(1:i-1,:);
        interleave.sham.d1_3.outb{r} =  inter_sort(i:end,:);
        %
        % SORT INTERLEAVED TIMES FOR CHRONOLOGY
        interleave.shock.d1_3.inb{r} = sortrows(interleave.shock.d1_3.inb{r}, 2);
        interleave.sham.d1_3.inb{r} = sortrows(interleave.sham.d1_3.inb{r}, 2);
        %
        % RUNNING AVERAGE
        h = ones(1, RUNAVG)/RUNAVG; % filter
        interleave.shock.d1_3.inb{r}(:,4) = NaN(length(interleave.shock.d1_3.inb{r}(:,1)),1); % allocate array with NaN padding for cropped running average
        interleave_avg = conv(h, interleave.shock.d1_3.inb{r}(:,1));
        interleave.shock.d1_3.inb{r}(:,4) = interleave_avg(1:end-RUNAVG+1);
        interleave.sham.d1_3.inb{r}(:,4) = NaN(length(interleave.sham.d1_3.inb{r}(:,1)),1); % allocate array with NaN padding for cropped running average
        interleave_avg = conv(h, interleave.sham.d1_3.inb{r}(:,1));
        interleave.sham.d1_3.inb{r}(:,4) = interleave_avg(1:end-RUNAVG+1);
    end
    
    
    for r=1:EPOCHS
        %figure;
        %scatter(interleave.shock.d1_3.inb{r}(:,2)/10000, interleave.shock.d1_3.inb{r}(:,1));
        %axis([0 max(interleave.shock.d1_3.inb{r}(:,2)/10000) -1 2]);
        
        figure;
        x = interleave.shock.d1_3.inb{r}(RUNAVG:end,2)/10000;
        y = (interleave.shock.d1_3.inb{r}(RUNAVG:end,4));
        scatter(x,y, 'r');
        hold on;
        plot(1:max(x), mean(interleave.shock.d1_3.inb{r}(:,1)), 'b');
        plot(x,y,'r');
        axis([0 1500 .3 1]);
        
        figure;
        x = interleave.sham.d1_3.inb{r}(RUNAVG:end,2)/10000;
        y = (interleave.sham.d1_3.inb{r}(RUNAVG:end,4));
        scatter(x,y, 'r');
        hold on;
        plot(1:max(x), mean(interleave.sham.d1_3.inb{r}(:,1)), 'b');
        plot(x,y,'r');
        axis([0 1500 .3 1]);
    end
    
end % end suppression of printing

%dio{ani}.outb = sortrows(dio{ani}.all, 11);
%i = find(dio{ani}.outb(:,11), 1, 'first');
%dio{ani}.inb = dio{ani}.outb(1:i-1,:); % inbound is only where sort found outbound=0;
%dio{ani}.outb = dio{ani}.outb(i:end,:); % outbound is only where sort found outbound=1;



%
% CALCULATE CORRECT TRIALS FOR GROUPS OF ANIMALS WITH ABSOLUTE TIMES
% INTERLEAVED
%
% names = {'a1','a2','b1','b2','e1','e2','f1','f2'};
%if calculate_interleave_animals  % estimate probability for groups of animals
if fig_interleave_animals  % estimate probability for groups of animals    
 
    % grani is index for differect collections of struct animals
    AB = 1;
    EF = 2;
    ABEF = 3;
    % CREATE STRUCT: interleave.shock(grani).all{EPOCHS,DAYS}
    for grani = 1:3 % animal structs
        interleave.shock{grani} = struct('all',{cell(EPOCHS, DAYS)},'inb',{cell(EPOCHS, DAYS)},'outb',{cell(EPOCHS, DAYS)});
        interleave.sham{grani} = struct('all',{cell(EPOCHS, DAYS)},'inb',{cell(EPOCHS, DAYS)},'outb',{cell(EPOCHS, DAYS)});
        interleave.shock{grani}.concat.all = []; % concatenate all epochs and days
        interleave.sham{grani}.concat.all = [];
        interleave.shock{grani}.trials.all = []; % list trials for each epoch and day
        interleave.sham{grani}.trials.all = [];
    end
    %interleave.shock{AB}.concat.all = [];
    %interleave.shock.ab.all = cell(EPOCHS, DAYS); % for 2 animals groups A,B
    %interleave.shock.ef.all = cell(EPOCHS, DAYS);
    %interleave.sham.ab.all = cell(EPOCHS, DAYS);
    %interleave.sham.ef.all = cell(EPOCHS, DAYS);
    
    %interleave.shock.abef.all = cell(EPOCHS, DAYS); % for 4 animals groups A,B,C,D
    %interleave.sham.abef.all = cell(EPOCHS, DAYS);
    
    for d = 1:DAYS % DAYS
        for r = 1:EPOCHS  % replace with both epoch and day to keep both separate for appending in order
            for ani = 1:length(names)
                if shocks(ani)
                    interleave.shock{ABEF}.all{r,d} = [interleave.shock{ABEF}.all{r,d} ...
                        ;times{ani,d,r}(:,1) times{ani,d,r}(:,4) times{ani,d,r}(:,5)]; % 'reward' 'time since epoch start' 'outbound'
                    
                    switch names{ani}
                        case {'a1','a2','b1','b2'}
                            interleave.shock{AB}.all{r,d} = [interleave.shock{AB}.all{r,d} ...
                                ;times{ani,d,r}(:,1) times{ani,d,r}(:,4) times{ani,d,r}(:,5)]; % 'reward' 'time since epoch start' 'outbound'
                        case {'e1','e2','f1','f2'}
                            interleave.shock{EF}.all{r,d} = [interleave.shock{EF}.all{r,d} ...
                                ;times{ani,d,r}(:,1) times{ani,d,r}(:,4) times{ani,d,r}(:,5)]; % 'reward' 'time since epoch start' 'outbound'
                        otherwise
                            % nothing here
                    end
                else % no shock
                    interleave.sham{ABEF}.all{r,d} = [interleave.sham{ABEF}.all{r,d} ...
                        ;times{ani,d,r}(:,1) times{ani,d,r}(:,4) times{ani,d,r}(:,5)]; % 'reward' 'time since epoch start' 'outbound'
                    
                    switch names{ani}
                        case {'a1','a2','b1','b2'}
                            interleave.sham{AB}.all{r,d} = [interleave.sham{AB}.all{r,d} ...
                                ;times{ani,d,r}(:,1) times{ani,d,r}(:,4) times{ani,d,r}(:,5)]; % 'reward' 'time since epoch start' 'outbound'
                        case {'e1','e2','f1','f2'}
                            interleave.sham{EF}.all{r,d} = [interleave.sham{EF}.all{r,d} ...
                                ;times{ani,d,r}(:,1) times{ani,d,r}(:,4) times{ani,d,r}(:,5)]; % 'reward' 'time since epoch start' 'outbound'
                        otherwise
                            % nothing here
                    end
                end % if shock
                
            end % ani TRY FOR LOOP WITH N= [{'INB', 'OUTB'}] WHEN CALLING STRUCTS
            for grani = 1:3 % different animal groups
                inter_sort = sortrows(interleave.shock{grani}.all{r,d}, 3);
                i = find(inter_sort(:,3), 1, 'first');
                interleave.shock{grani}.inb{r,d} =  inter_sort(1:i-1,:);
                interleave.shock{grani}.outb{r,d} =  inter_sort(i:end,:);
                % sham x2
                inter_sort = sortrows(interleave.sham{grani}.all{r,d}, 3);
                i = find(inter_sort(:,3), 1, 'first');
                interleave.sham{grani}.inb{r,d} =  inter_sort(1:i-1,:);
                interleave.sham{grani}.outb{r,d} =  inter_sort(i:end,:);
                %
                % SORT INTERLEAVED TIMES FOR CHRONOLOGY
                interleave.shock{grani}.all{r,d} = sortrows(interleave.shock{grani}.all{r,d}, 2);
                interleave.sham{grani}.all{r,d} = sortrows(interleave.sham{grani}.all{r,d}, 2);
                %
                % SCALE TIMES SO DAYS AND EPOCHS ALIGN IN FIGURES
                interleave.shock{grani}.all{r,d}(:,4) = 1:length(interleave.shock{grani}.all{r,d});
                interleave.sham{grani}.all{r,d}(:,4) = 1:length(interleave.sham{grani}.all{r,d});
                
                basetime = (d-1) + (r-1)/2; % day 1 epoch 1 = 0-0.5; day 2 epoch 2 = 1.5-2
                scaletime = (interleave.shock{grani}.all{r,d}(:,4))/ max(interleave.shock{grani}.all{r,d}(:,4)) /2;
                interleave.shock{grani}.all{r,d}(:,5) = basetime + scaletime;
                
                scaletime = (interleave.sham{grani}.all{r,d}(:,4))/ max(interleave.sham{grani}.all{r,d}(:,4)) /2;
                interleave.sham{grani}.all{r,d}(:,5) = basetime + scaletime;

                % CONCATENATE ALL EPOCHS AND DAYS
                interleave.shock{grani}.concat.all  = [interleave.shock{grani}.concat.all; interleave.shock{grani}.all{r,d}];
                interleave.sham{grani}.concat.all  = [interleave.sham{grani}.concat.all; interleave.sham{grani}.all{r,d}];
            end % grani - struct animal groups
        end % epochs
    end % days
    
    tpc = cell(2,3);    % for est prob correct t-axis
    for grani = 1:3
        tpc{1, grani} = interleave.shock{grani}.concat.all(:,5)'; 
        tpc{2, grani} = interleave.sham{grani}.concat.all(:,5)';
    end
    
    
    %save('interleave', 'interleave');
%end % calculate interleave


    
    %load('interleave')
    
    if ~calculate_est_prob_correct  % time intensive calculation
        load('pc_abef');
    end %load saved calculation
    % ESTIMATE PROBABILITY GRAPHS FOR GROUPS OF ANIMALS
    % all trials
    
    shName = [{'shock' 'sham'}];
    graniName = [{'AB' 'EF' 'ABEF'}];
    
    for sh=1:2 % shock and sham
        % all_alltrials_logic = interleave.shock{AB}.all{1,1}(:,1);
        for grani = 1:3 % animal groups
            if sh == 1
                all_alltrials_logic = interleave.shock{grani}.concat.all(:,1);
            else
                all_alltrials_logic = interleave.sham{grani}.concat.all(:,1);
            end
            
            if calculate_est_prob_correct
                [pc{sh,grani}, lt{sh,grani}] = getestprobcorrect(all_alltrials_logic, 0.5, 2, 0);
                alltrials_curve_witherr = pc{sh,grani}(2:end,:);
                alltrials_curve = pc{sh,grani}(2:end,1);
                alltrials_lowerr = pc{sh,grani}(2:end,2);
                alltrials_uperr = pc{sh,grani}(2:end,3);
                alltrials_learningtrial = lt;
                
            end % calculate_est_prob_correct
            
            if fig_interleave_set1
                
                figure; hold on; %redimscreen_figforppt1;
                %redimscreen;
                orient(gcf,'portrait'); hold on; set(gcf, 'PaperPositionMode', 'auto');
                set(0,'defaultaxesfontsize',20);set(0,'defaultaxesfontweight','normal');
                set(0,'defaultaxeslinewidth',2);
                
                % Get time (day) axis
                t = 1:size(pc{sh,grani},1)-1;
                %%% Plot data %%
                plot(t', pc{sh,grani}(2:end,1),'r-', 'Linewidth', 2);
                taxis = t';
                data=[pc{sh,grani}(2:end,2),pc{sh,grani}(2:end,3)];
                % plot(t', pc(2:end,2),'m--', 'Linewidth', 2);
                % plot(t', pc(2:end,3),'m--', 'Linewidth', 2);
                jbfill(taxis',pc{sh,grani}(2:end,3)',pc{sh,grani}(2:end,2)','r','r',1, JBA);
                axis tight;
                ylim([.3 1]);
                %axis([0 300 .4 1]);
                %axis('auto-x');
                
                title(['All Trials Learning Curve ',graniName{grani},' ' shName{sh} ]);
            end %fig_interleave_set1
        end % grani
    end % shock and sham
    if calculate_est_prob_correct
        save('pc_abef', 'pc');
    end % save prob correct
    
    % compare shock and sham (blue)
     figure; hold on; %redimscreen_figforppt1;
            %redimscreen;
            orient(gcf,'portrait'); hold on; set(gcf, 'PaperPositionMode', 'auto');
            set(0,'defaultaxesfontsize',20);set(0,'defaultaxesfontweight','normal');
            set(0,'defaultaxeslinewidth',2);
            
            % Get time (day) axis
            t = 1:size(pc{sh,grani},1)-1;
            
            
            %%% Plot Shock data %%
            % plot(t', pc{sh,grani}(2:end,1),'r-', 'Linewidth', 2);
            sh = 1; % shock
            grani = 3; % ABEF
            t = 1:size(pc{sh,grani},1)-1;
            lgd(1) = plot(t', pc{sh,grani}(2:end,1),'r-', 'Linewidth', 2);
            %            plot(pc{sh,grani}(2:end,1),'r-', 'Linewidth', 2);

            taxis = t';
            %data=[pc{sh,grani}(2:end,2),pc{sh,grani}(2:end,3)];
            jbfill(taxis',pc{sh,grani}(2:end,3)',pc{sh,grani}(2:end,2)','r','r',1, JBA);
            hold on;
            %%% Plot Sham data %%
            sh = 2; % sham
            t = 1:size(pc{sh,grani},1)-1;
            lgd(2) = plot(t', pc{sh,grani}(2:end,1),'b-', 'Linewidth', 2);
            %plot(pc{sh,grani}(2:end,1),'b-', 'Linewidth', 2);
            taxis = t';
            jbfill(taxis',pc{sh,grani}(2:end,3)',pc{sh,grani}(2:end,2)','b','b',1, JBA);
            
            
            axis tight;
            ylim([.3 1]);
            title([{'Est Prob Correct'}; {'sham(blue), shock(red)'}]);
            xlabel(['trial']);
            ylabel(['prob. correct']);
            legend(lgd,'ABEF shock', 'ABEF sham' ,'location', 'SouthEast');
            legend('boxoff');
            
            
            
            % compare AB sham (blue) and EF sham (red)
            %
            figure; hold on; %redimscreen_figforppt1;
            orient(gcf,'portrait'); hold on; set(gcf, 'PaperPositionMode', 'auto');
            set(0,'defaultaxesfontsize',20);set(0,'defaultaxesfontweight','normal');
            set(0,'defaultaxeslinewidth',2);
            
            % Get time (day) axis
            t = 1:size(pc{sh,grani},1)-1;
            
            %%% Plot EF Sham data %%
            sh = 2; % sham
            grani = 2; % EF
            t = 1:size(pc{sh,grani},1)-1;
            lgd(1) = plot(t', pc{sh,grani}(2:end,1),'r-', 'Linewidth', 2);
            taxis = t';
            jbfill(taxis',pc{sh,grani}(2:end,3)',pc{sh,grani}(2:end,2)','r','r',1, JBA);
            hold on;
            
            %%% Plot AB Sham data %%
            sh = 2; % sham
            grani = 1; % AB
            t = 1:size(pc{sh,grani},1)-1;
            lgd(2) = plot(t', pc{sh,grani}(2:end,1),'b-', 'Linewidth', 2);
            taxis = t';
            jbfill(taxis',pc{sh,grani}(2:end,3)',pc{sh,grani}(2:end,2)','b','b',1, JBA);            
            
            axis tight;
            ylim([.3 1]);
            title([{'Est Prob Correct'} ; {'AB sham(blue), EF sham(red)'}]);
            xlabel(['trial']);
            ylabel(['prob. correct']);
            legend(lgd,'EF sham', 'AB sham' ,'location', 'SouthEast');
            legend('boxoff');
            
            
            % compare AB shock (blue) and EF shock (red)
            %
            figure; hold on; %redimscreen_figforppt1;
            orient(gcf,'portrait'); hold on; set(gcf, 'PaperPositionMode', 'auto');
            set(0,'defaultaxesfontsize',20);set(0,'defaultaxesfontweight','normal');
            set(0,'defaultaxeslinewidth',2);
            
            % Get time (day) axis
            t = 1:size(pc{sh,grani},1)-1;
            
            %%% Plot Shock data %%
            sh = 1; % shock
            grani = 2; % EF
            t = 1:size(pc{sh,grani},1)-1;
            lgd(1) = plot(t', pc{sh,grani}(2:end,1),'r-', 'Linewidth', 2);
            taxis = t';
            jbfill(taxis',pc{sh,grani}(2:end,3)',pc{sh,grani}(2:end,2)','r','r',1, JBA);
            hold on;
            
            %%% Plot Sham data %%
            sh = 1; % shock
            grani = 1; % AB
            t = 1:size(pc{sh,grani},1)-1;
            lgd(2) = plot(t', pc{sh,grani}(2:end,1),'b-', 'Linewidth', 2);
            taxis = t';
            jbfill(taxis',pc{sh,grani}(2:end,3)',pc{sh,grani}(2:end,2)','b','b',1, JBA);            
            
            axis tight;
            ylim([.3 1]);
            title([{'Est Prob Correct'} ; {'AB shock(blue), EF shock(red)'}]);
            xlabel(['trial']);
            ylabel(['prob. correct']);
            legend(lgd,'EF shock', 'AB shock' ,'location', 'SouthEast');
            legend('boxoff');
            
            
            % compare EF sham (blue) and EF shock (red)
            %
            figure; hold on; %redimscreen_figforppt1;
            orient(gcf,'portrait'); hold on; set(gcf, 'PaperPositionMode', 'auto');
            set(0,'defaultaxesfontsize',20);set(0,'defaultaxesfontweight','normal');
            set(0,'defaultaxeslinewidth',2);
            
            % Get time (day) axis
            t = 1:size(pc{sh,grani},1)-1;
            
            %%% Plot Shock data %%
            sh = 2; % sham
            grani = 2; % EF
            t = 1:size(pc{sh,grani},1)-1;
            lgd(1) = plot(t', pc{sh,grani}(2:end,1),'b-', 'Linewidth', 2);
            taxis = t';
            jbfill(taxis',pc{sh,grani}(2:end,3)',pc{sh,grani}(2:end,2)','b','b',1, JBA);
            hold on;
            
            %%% Plot Sham data %%
            sh = 1; % shock
            grani = 2; % EF
            t = 1:size(pc{sh,grani},1)-1;
            lgd(2) = plot(t', pc{sh,grani}(2:end,1),'r-', 'Linewidth', 2);
            taxis = t';
            jbfill(taxis',pc{sh,grani}(2:end,3)',pc{sh,grani}(2:end,2)','r','r',1, JBA);            
            
            axis tight;
            ylim([.3 1]);
            title([{'Est Prob Correct'} ; {'EF sham(blue), EF shock(red)'}]);
            xlabel(['trial']);
            ylabel(['prob. correct']);
            legend(lgd,'EF sham', 'EF shock' ,'location', 'SouthEast');
            legend('boxoff');

            
            
            % compare AB sham (blue) and AB shock (red)
            %
            figure; hold on; %redimscreen_figforppt1;
            orient(gcf,'portrait'); hold on; set(gcf, 'PaperPositionMode', 'auto');
            set(0,'defaultaxesfontsize',20);set(0,'defaultaxesfontweight','normal');
            set(0,'defaultaxeslinewidth',2);
            
            % Get time (day) axis
            t = 1:size(pc{sh,grani},1)-1;
            
            %%% Plot AB Sham data %%
            sh = 2; % sham
            grani = 1; % AB
            t = 1:size(pc{sh,grani},1)-1;
            lgd(1) = plot(t', pc{sh,grani}(2:end,1),'b-', 'Linewidth', 2);
            taxis = t';
            jbfill(taxis',pc{sh,grani}(2:end,3)',pc{sh,grani}(2:end,2)','b','b',1, JBA);
            hold on;
            
            %%% Plot AB Shok data %%
            sh = 1; % shock
            grani = 1; % AB
            t = 1:size(pc{sh,grani},1)-1;
            lgd(2) = plot(t', pc{sh,grani}(2:end,1),'r-', 'Linewidth', 2);
            taxis = t';
            jbfill(taxis',pc{sh,grani}(2:end,3)',pc{sh,grani}(2:end,2)','r','r',1, JBA);            
            
            axis tight;
            ylim([.3 1]);
            title([{'Est Prob Correct'} ; {'AB sham(blue), AB shock(red)'}]);
            xlabel(['trial']);
            ylabel(['prob. correct']);
            legend(lgd,'AB sham', 'AB shock' ,'location', 'SouthEast');
            legend('boxoff');

            
            % compare AB sham (blue) and ABEF shock (red)
            %
            figure; hold on; %redimscreen_figforppt1;
            orient(gcf,'portrait'); hold on; set(gcf, 'PaperPositionMode', 'auto');
            set(0,'defaultaxesfontsize',20);set(0,'defaultaxesfontweight','normal');
            set(0,'defaultaxeslinewidth',2);
            set(gca,'XGrid','on', 'LineWidth', 1);
            
            % Get time (day) axis
            t = 1:size(pc{sh,grani},1)-1;
            
            %%% Plot AB Sham data %%
            sh = 2; % sham
            grani = 1; % AB
            % t = interleave.sham{grani}.concat.all(:,5)';
            % t = 1:size(pc{sh,grani},1)-1;
            t = tpc{sh, grani};
            lgd(1) = plot(t', pc{sh,grani}(2:end,1),'b-', 'Linewidth', 2);
            taxis = t';
            jbfill(taxis',pc{sh,grani}(2:end,3)',pc{sh,grani}(2:end,2)','b','b',1, JBA);
            hold on;
            
            %%% Plot ABEF Shock data %%
            sh = 1; % shock
            grani = 3; % ABEF
            %t = 1:size(pc{sh,grani},1)-1;
            %t = interleave.shock{grani}.concat.all(:,5)';
            t = tpc{sh, grani};
            lgd(2) = plot(t', pc{sh,grani}(2:end,1),'r-', 'Linewidth', 2);
            taxis = t';
            jbfill(taxis',pc{sh,grani}(2:end,3)',pc{sh,grani}(2:end,2)','r','r',1, JBA);            
            
            axis tight;
            ylim([.3 1]);
            title([{'Est Prob Correct'} ; {'AB sham(blue), ABEF shock(red)'}]);
            xlabel(['day']);
            ylabel(['prob. correct']);
            legend(lgd,'AB sham', 'ABEF shock' ,'location', 'SouthEast');
            % legend('boxoff');
            
            
end % end suppression of printing





% SUPPRESS OUTPUT with if statement
%________INDIVIDUAL ANIMAL PLOTS DAILY AVERAGES________
if 0
    
    for ani = 1:length(names)
        figure;
        bar(.25:.5:6.75,rem(2:DAYS*2+1, 2),'g','EdgeColor', 'none');
        alpha(.1)
        hold;
        plot(.25:.5:6.75,dio{ani}.stats.all.acc(:));
        %axis([0 7 0 1])
    end
    
    for ani = 1:length(names)
        figure;
        bar(.25:.5:6.75,rem(2:DAYS*2+1, 2),'g','EdgeColor', 'none');
        alpha(.1)
        hold;
        plot(.25:.5:6.75,dio{ani}.stats.inb.acc(:));
        %axis([0 7 0 1])
    end
    
    for ani = 1:length(names)
        figure;
        bar(.25:.5:6.75,rem(2:DAYS*2+1, 2),'g','EdgeColor', 'none');
        alpha(.1);
        hold;
        plot(.25:.5:6.75,dio{ani}.stats.outb.acc(:));
        %axis([0 7 0 1])
    end
end % end Suppress figures


% SUPPRESS OUTPUT with if statement
%________INDIVIDUAL ANIMAL PLOTS RUNNING AVERAGES FOR ALL DAYS________
if fig_runavg_indiv
    for ani = 1:length(names)
        figure;
        bar(dio{ani}.all(11:end,RUN)-1, 'FaceColor',[.9 .9 .9], 'EdgeColor', [.9 .9 .9]);
        hold;
        plot(dio{ani}.avg.all(RUNAVG:end-RUNAVG)); %shift by RUNAVG so Avg reflects session
        title('animal, XX trial running average ALL trials');
    end
end % suppress printing
if fig_runavg_indiv_inb
    for ani = 1:length(names)
        figure;
        bar(dio{ani}.inb(11:end,RUN)-1, 'FaceColor',[.9 .9 .9], 'EdgeColor', [.9 .9 .9]);
        hold;
        plot(dio{ani}.avg.inb(RUNAVG:end-RUNAVG)); %shift by RUNAVG so Avg reflects session
        title('animal, XX trial running average INbound');
    end
end % suppress printing
if fig_runavg_indiv_outb
    for ani = 1:length(names)
        figure;
        bar(dio{ani}.outb(11:end,RUN)-1, 'FaceColor',[.9 .9 .9], 'EdgeColor', [.9 .9 .9]);
        hold;
        plot(dio{ani}.avg.outb(RUNAVG:end-RUNAVG)); %shift by RUNAVG so Avg reflects session
        title('animal, XX trial running average OUTbound');
    end
end % suppress printing





