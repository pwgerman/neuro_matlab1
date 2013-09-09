% read_behav_script.m

%{
readfile = [{'Bukowski_behav_input'},{'Cummings_behav_input'},...
    {'Eliot_behav_input'},{'Jigsaw_behav_input'},{'P1_behav_input'},...
    {'P2_behav_input'},{'Q2_behav_input'},{'R2_behav_input'},...
    {'S2_behav_input'},{'S3_behav_input'},{'T3_behav_input'}];

%task list
inb = 1;
outb = 2;
allb = 3;

for task = 1:2
    for rat = 1:length(readfile)
        [pc{rat}{task}, lt{rat}{task}] = behav_input_read(readfile{rat});
    end
end
%}

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

%plot gpc group averages
background_prob = 0.5;
conf = .95;
ltmean = NaN;
for rat = [p2 r2 s3 t3]
    for task = 1:2
        bmode = pc{rat}{task}(:,1);
        blower = pc{rat}{task}(:,2);
        bupper = pc{rat}{task}(:,3);
        t=(1:size(bmode,1)-1)';
        
        figure; % clf;
        
        plot(t, bmode(2:end),'r-');
        hold on;
        plot(t, blower(2:end),'k', t, bupper(2:end), 'k');
        axis([1 t(end)  0 1.05]);
line([1 t(end)], [background_prob  background_prob ]);
title(['rat ' num2str(rat) '  task ' num2str(task) '  IO(' num2str(conf) ') Learning Trial = ' num2str(ltmean) ]);
xlabel('Trial Number')
ylabel('Probability of a Correct Response')
    end
end

%{
% subgroups
shock =1;
non_shock = 2;
phys = 3;
C = 4;
linear = 5;
first = 6;
second = 7;

%group{subgroup} = [{'P1'}, {'Q2'}, {'S2'}];  % group{subgroup}{rat}
group{shock} = [p1 q2 s2];
group{non_shock} = [p2 r2 s3 t3];
group{phys} = [buk cum eli jig];
group{C} = [p1 q2 r2 s3 cum jig];
group{linear} = [p2 s2 t3 buk eli];
group{first} = [p1 r2 s2 s3 eli jig];
group{second} = [p2 q2 t3 buk cum];

gpc = cell(1,3,3);
for grp = 1: 7
    for task = 1:3
        size_chk = [];
        for rat = 1:length(group{grp})
            size_chk = [size_chk size(pc{group{grp}(rat)}{task},1)];
        end
        trialmax = min(size_chk);
        for rat = 1:length(group{grp})
            for err = 1:3  % the two 95 confidence intervals and mean
                gpc{grp}{task}{err}(:,rat+1) = pc{group{grp}(rat)}{task}(1:trialmax, err);
            end
        end
        % find mean of all rats in group
        for err = 1:3  % the two 95 confidence intervals and mean
            gpc{grp}{task}{err}(:,1) = mean(gpc{grp}{task}{err}(:,2:end),2);
            %mean(gpc{grp}{task}{err}([10:10:100],2:end),2)
        end
    end
end

%}
%{

%plot gpc group averages
background_prob = 0.5;
conf = .95;
ltmean = NaN;
for grp = 1: 3
    for task = 1:2
        bmode = gpc{grp}{task}{1}(:,1);
        blower = gpc{grp}{task}{2}(:,1);
        bupper = gpc{grp}{task}{3}(:,1);
        t=(1:size(bmode,1)-1)';
        
        figure; % clf;
        
        plot(t, bmode(2:end),'r-');
        hold on;
        plot(t, blower(2:end),'k', t, bupper(2:end), 'k');
        axis([1 t(end)  0 1.05]);
line([1 t(end)], [background_prob  background_prob ]);
title(['group ' num2str(grp) '  task ' num2str(task) '  IO(' num2str(conf) ') Learning Trial = ' num2str(ltmean) ]);
xlabel('Trial Number')
ylabel('Probability of a Correct Response')
    end
end
%}
