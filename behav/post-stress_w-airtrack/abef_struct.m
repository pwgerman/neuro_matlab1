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

RUNAVG = 10;  % number of trials to include in running average
h = ones(1, RUNAVG)/RUNAVG; % filter
LINW = 3; % LineWidth for plots
FONT = 'Helvetica';
TFSZ = 18; % title font size
AFSZ = 16; % axes font size
%scrsz = get(0,'ScreenSize');
FNTW = 'Normal'; % font weight 'Normal'
FigName = '/home/walter/src/matlab/figures/shock_study';

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
OUT = 11;   % current trial is outbound =1; inbound=0

XaxisMIN = .3;

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
    dio{ani}.raw = load(names{ani});
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

shock.all.acc = [];
sham.all.acc = [];
shock.inb.acc = [];
sham.inb.acc = [];
shock.outb.acc = [];
sham.outb.acc = [];

for ani = 1:length(names)
    if dio{ani}.shock % shock(ani) true
        shock.all.acc = [shock.all.acc ; dio{ani}.stats.all.acc(:)'];
        shock.inb.acc = [shock.inb.acc ; dio{ani}.stats.inb.acc(:)'];
        shock.outb.acc = [shock.outb.acc ; dio{ani}.stats.outb.acc(:)'];
    else
        sham.all.acc = [sham.all.acc ; dio{ani}.stats.all.acc(:)'];
        sham.inb.acc = [sham.inb.acc ; dio{ani}.stats.inb.acc(:)'];
        sham.outb.acc = [sham.outb.acc ; dio{ani}.stats.outb.acc(:)'];
    end
end

% PLOT DAILY AVERAGES WITH SHOCK/SHAM GROUPS AVERAGED TOGETHER
h=figure('DefaultAxesFontSize', AFSZ,'paperpositionmode','auto', 'color','white','InvertHardcopy','off');
hold; % positon of hold changes appearance of graph
hBar = bar(.25:.5:6.75,rem(2:DAYS*2+1, 2),'FaceColor',[.95 .95 .95],'EdgeColor', 'none', 'BaseValue', XaxisMIN);
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
print(h,'-r600','-depsc2','-painters', [FigName '_1.eps']); % save figure to .eps file for ai (resave as .jpg for best ppt)


h=figure('DefaultAxesFontSize', AFSZ,'paperpositionmode','auto', 'color','white','InvertHardcopy','off');
hold;
hBar= bar(.25:.5:6.75,rem(2:DAYS*2+1, 2),'FaceColor',[.95 .95 .95],'EdgeColor', 'none','BaseValue', XaxisMIN);
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
print(h,'-r600','-depsc2','-painters', [FigName '_2.eps']); % save figure to .eps file for ai (resave as .jpg for best ppt)


h=figure('DefaultAxesFontSize', AFSZ,'paperpositionmode','auto', 'color','white','InvertHardcopy','off');
hold;
hBar= bar(.25:.5:6.75,rem(2:DAYS*2+1, 2),'FaceColor',[.95 .95 .95],'EdgeColor', 'none', 'BaseValue', XaxisMIN);
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
print(h,'-r600','-depsc2','-painters', [FigName '_3.eps']); % save figure to .eps file for ai (resave as .jpg for best ppt)





% CALCULATE RUNNING AVERAGES WITH SHOCK/SHAM GROUPS AVERAGED TOGETHER
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


% PLOT RUNNING AVERAGES WITH SHOCK/SHAM GROUPS AVERAGED TOGETHER
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
print(h,'-r600','-depsc2','-painters', [FigName '_4.eps']); % save figure to .eps file for ai (resave as .jpg for best ppt)


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
print(h,'-r600','-depsc2','-painters', [FigName '_5.eps']); % save figure to .eps file for ai (resave as .jpg for best ppt)


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
print(h,'-r600','-depsc2','-painters', [FigName '_6.eps']); % save figure to .eps file for ai (resave as .jpg for best ppt)



% PLOT DAILY AVERAGES WITH SHOCK/SHAM INDIVIDUALS BY COLOR

h=figure('DefaultAxesFontSize', AFSZ,'paperpositionmode','auto', 'color','white','InvertHardcopy','off'); %'position',[100 0 1100 1100]
% plot something...  'color' 'none' for transparency

%figure('DefaultAxesFontSize', AFSZ, 'color','white','Renderer', 'Painter'); % 'Position',[1 scrsz(4)/2 600 450]);
hold;

hBar = bar(.25:.5:6.75,rem(2:DAYS*2+1, 2),'FaceColor',[.95 .95 .95],'EdgeColor', 'none','BaseValue', XaxisMIN); %'FaceColor',[.8 .8 .8], 'EdgeColor', [.8 .8 .8]);
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
%text(.05,.1, 'shock = red');
legend('sham','shock', 'Location', 'SouthEast');
axis([0 7 XaxisMIN 1]);
%set(get(hBar,'BaseLine'),'LineWidth', 8); % 'LineStyle',':')
%axis square;
xlabel('Day','FontName',FONT, 'FontSize', AFSZ); %, 'FontWeight', FNTW);%[{'Day'}; {'run1 = white, run2 = shaded'}]
ylabel('Probability Correct','FontName',FONT, 'FontSize', AFSZ); %, 'FontWeight', FNTW);
print(h,'-r600','-depsc2','-painters', [FigName '_7.eps']); % save figure to .eps file for ai (resave as .jpg for best ppt)



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
end


% SUPPRESS OUTPUT with if statement
%________INDIVIDUAL ANIMAL PLOTS RUNNING AVERAGES FOR ALL DAYS________
if 0
    for ani = 1:length(names)
        figure;
        bar(dio{ani}.all(11:end,RUN)-1, 'FaceColor',[.9 .9 .9], 'EdgeColor', [.9 .9 .9]);
        hold;
        plot(dio{ani}.avg.all(RUNAVG:end-RUNAVG)); %shift by RUNAVG so Avg reflects session
        title('animal, XX trial running average ALL trials');
    end
    
    for ani = 1:length(names)
        figure;
        bar(dio{ani}.inb(11:end,RUN)-1, 'FaceColor',[.9 .9 .9], 'EdgeColor', [.9 .9 .9]);
        hold;
        plot(dio{ani}.avg.inb(RUNAVG:end-RUNAVG)); %shift by RUNAVG so Avg reflects session
        title('animal, XX trial running average INbound');
    end
    
    for ani = 1:length(names)
        figure;
        bar(dio{ani}.outb(11:end,RUN)-1, 'FaceColor',[.9 .9 .9], 'EdgeColor', [.9 .9 .9]);
        hold;
        plot(dio{ani}.avg.outb(RUNAVG:end-RUNAVG)); %shift by RUNAVG so Avg reflects session
        title('animal, XX trial running average OUTbound');
    end
end





