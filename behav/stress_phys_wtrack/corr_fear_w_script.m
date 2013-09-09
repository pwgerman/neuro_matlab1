% corr_fear_w_script.m

% first load in variables and calculations performed earlier with
% read_behav_day_script and related m-files and functions.

load('/home/walter/Analysis/saved-behav_input/read_behav_10_9_12.mat');

read_behav_day_script;
close all;

% task list - note that task 4-6 are with return errors
inb = 1;
outb = 2;
allb = 3;
task = allb;

%dayscore{rat}(day,task)

readfile = [{'freezing_behav_input.csv'},{'feces_behav_input.csv'},...
    {'rest-count_behav_input.csv'}];
fearscore = cell(length(readfile),1);
for file = 1: length(readfile)
    fearscore{file} = behav_input_fear_read(readfile{file});
end

% fearscore{fmetric}{rat}(day,shock/cntrl); fmetric =1 is freezing, 2 is
% feces, 3 is rest count

% fmetric define values
frzS =1; % freezing time (seconds) in shock context (or practice)
frzC =2; % freezing time (seconds) in control context
fcsS =3; % feces
fcsC =4;
rcS =5; % rest counts
rcC =6;

%{
%rat list (same list is repeated twice in input file so buk = 1 and 1+11;
%cum = 2 and 2+11; etc...
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
%}


%dayscore{rat}(day,task)

% fearscore{fmetric}{rat}(day,shock/cntrl); fmetric =1 is freezing, 2 is
% feces, 3 is rest count

numrat = size(fearscore{1},1);
numday = size(fearscore{1}{1},1);
freeze1 = cell(1);
for rat = 1:numrat
    for day = 1:numday
        for fmet = 1:size(fearscore,1) % fileread list
            freeze1{fmet}(rat,day) = fearscore{fmet}{rat}(day,1);
        end
            outb1(rat,day) = dayscore{rat}(day,2);
        
    end
end

scatter(freeze1{1}(:), outb1(:));
%scatter(fearscore{1}{1}(:,1),dayscore{1}(:,2));

