% read_behav_epoch_script.m

%{
readfile = [{'Bukowski_behav_input'},{'Cummings_behav_input'},...
    {'Eliot_behav_input'},{'Jigsaw_behav_input'},{'P1_behav_input'},...
    {'P2_behav_input'},{'Q2_behav_input'},{'R2_behav_input'},...
    {'S2_behav_input'},{'S3_behav_input'},{'T3_behav_input'}];

% subgroups
shock =1;
non_shock = 2;
phys = 3;
C = 4;
linear = 5;
first = 6;
second = 7;

%rat list
buk = 1;
cum = 2;
eli = 3;
jig = 4;
p1 = 5;
p2 = 6;
q2 = 7;
r2 = 8;
s2 = 9;
s3 = 10;
t3 = 11;



%group{subgroup} = [{'P1'}, {'Q2'}, {'S2'}];  % group{subgroup}{rat}
group{shock} = [p1 q2 s2];
group{non_shock} = [p2 r2 s3 t3];
group{phys} = [buk cum eli jig];
group{C} = [p1 q2 r2 s3 cum jig];
group{linear} = [p2 s2 t3 buk eli];
group{first} = [p1 r2 s2 s3 eli jig];
group{second} = [p2 q2 t3 buk cum];

%}

%{
%epochscore{rat}(epoch,task)
numepochs =14;

epochscore = cell(length(readfile),1);
for rat = 1:length(readfile)
    epochscore{rat} = behav_input_epoch_read(readfile{rat});  %d epochscore{rat}(epoch,task)
end

gepoch = cell(7,1);
for grp = 1:7
    for task = 1:3
        for rat = 1:length(group{grp})
            for epoch = 1:numepochs  
                gepoch{grp}{task}{1}(epoch,rat) = epochscore{group{grp}(rat)}(epoch,task); %pc{group{grp}(rat)}{task}(1:trialmax, err);
            end
        end
        % find mean and sem of all rats in group
            gepoch{grp}{task}{2} = mean(gepoch{grp}{task}{1},2); % mean
            gepoch{grp}{task}{3} = sem(gepoch{grp}{task}{1}')';     % sem
            %gday{grp}{task}{3} = std(gday{grp}{task}{1}')';
    end
end


%}
%

%plot gday group averages
background_prob = .5;
for grp = 6:7
    for task = 1:2
        
        bmode = gepoch{grp}{task}{2}';
        blower = gepoch{grp}{task}{2}' - gepoch{grp}{task}{3}';
        bupper = gepoch{grp}{task}{2}' + gepoch{grp}{task}{3}';
        
        t=1:numepochs;
        
        figure; % clf;
        
        plot(t, bmode,'k-');
        hold on;
        jbfill(t,bupper,blower,'b','b',1,.1);
        
        %plot(t, blower(2:end),'k', t, bupper(2:end), 'k');
        axis([0.5 t(end)+.5  0 1.05]);
        line([1 t(end)], [background_prob  background_prob ]);
        
        title(['group ' num2str(grp) '  task ' num2str(task) ]);
        xlabel('Epoch Number')
        ylabel('Correct Responses')
    end
end
%

%{
% plot comparisons
task = 2;
bmode = cell(1);
blower = cell(1);
bupper = cell(1);

grp = 2;
bmode{1} = gday{grp}{task}{2}';
blower{1} = gday{grp}{task}{2}' - gday{grp}{task}{3}';
bupper{1} = gday{grp}{task}{2}' + gday{grp}{task}{3}';

grp = 3;
bmode{2} = gday{grp}{task}{2}';
blower{2} = gday{grp}{task}{2}' - gday{grp}{task}{3}';
bupper{2} = gday{grp}{task}{2}' + gday{grp}{task}{3}';

t=1:7;

figure; % clf;

plot(t, bmode{1},'r-');
hold on;
jbfill(t,bupper{1},blower{1},'r','r');
hold on;
plot(t, bmode{2},'b-');
hold on;
jbfill(t,bupper{2},blower{2},'b','b');

%plot(t, blower(2:end),'k', t, bupper(2:end), 'k');
axis([0.5 t(end)+.5  0 1.05]);
line([1 t(end)], [background_prob  background_prob ]);

title(['group ' num2str(grp) '  task ' num2str(task) ]);
xlabel('Day Number')
ylabel('Correct Responses')

%}
        
        