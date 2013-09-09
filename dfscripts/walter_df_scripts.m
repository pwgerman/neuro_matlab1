% set paths
path('/home/walter/src/matlab/walter', path);
path('/home/walter/src/matlab/walter/df_analysis', path);
path('/home/walter/src/matlab/walter/df_scripts', path);
path('/home/walter/src/matlab/walter/datafilter', path);
path('/home/walter/src/matlab/walter/datafilter/iterators', path);
path('/home/walter/src/matlab/from_David_0420', path);
path('/home/walter/src/matlab/from_Maggie_0421', path);


path('/data18/walter/stress/Dic', path);
path('/data18/walter/stress/Cum', path);
path('/data18/walter/stress/Dickinson/Dickinson_02', path);


path('/data18/walter/stress/Dickinson/Dickinson_02_debug_pos_switch', path);

% dbstop if error % useful command


% script for starting to look at velocity and ripples in stress project
% 04-22-2012

load '/data18/walter/stress/Dic/Diclinpos01.mat'
velshock =linpos{1}{2}.statematrix.linearVelocity(:,1);
velctrl =linpos{1}{3}.statematrix.linearVelocity(:,1);
figure
hist(velshock);
figure
hist(velctrl);
figure
hist(abs(velshock(100:end-100)),100);
figure
hist(abs(velctrl(100:end-100)), 100);
load '/data18/walter/stress/Dic/Diclinpos04.mat'
figure
velshock4 =linpos{4}{3}.statematrix.linearVelocity(100:end-100);
velctrl4 =linpos{4}{2}.statematrix.linearVelocity(100:end-100);
plot(velshock4)
figure
plot(velctrl4)

hbins = 0:1:24;
figure
hvshock4 = histc(abs(velshock4),hbins);
bar(hbins,hvshock4)
figure
hvctrl4 = histc(abs(velctrl4),hbins);


% To look at task structure to see what epoch variables are available for
% filter
load '/data18/walter/stress/Dic/Dictask01.mat'


% 04-26-2012
% look at velocity of Dickinson day 4 when his freezing behavior was highest

load '/data18/walter/stress/Dic/Dicpos04.mat'
load '/data18/walter/stress/Dic/Diclinpos04.mat'
lvshx =linpos{4}{3}.statematrix.linearVelocity(:,1);
pvshx =pos{4}{3}.data(:,5);
pvshx10 = pvshx(301:18300);  % only the first 10 minutes of test. freezing = 4:15 (7650 samples at 30Hz)
[b,ix] = sort(pvshx10); % sample 7650 on sort is value = 1.031754809845313  So freeze threshold on unsmoothed data
sum(pvshx10(1:3600)<1.03)/30  % calculate the number of samples in first 2 min that are below freezing threshold  =21 which is close to 17 in notebook

% 04-28-12
% plot the linpos vs time and plot positon in red during freezing 
path('/data18/walter/stress/Cum', path);
runcalcfreezethresh
load '/data18/walter/stress/Dic/Diclinpos01.mat'
plot(linpos{1}{2}.statematrix.lindist);
figure
plot(linpos{1}{3}.statematrix.lindist);
load '/data18/walter/stress/Dic/Diclinpos04.mat'
figure
plot(linpos{1}{2}.statematrix.lindist);
plot(linpos{4}{2}.statematrix.lindist);
figure
plot(linpos{4}{3}.statematrix.lindist);
runcalcfreezethresh

track = linpos{4}{3}.statematrix.lindist;
freezetrack = [track (1:1:length(track))'];


% 04-29-12
% plot the linear position and color that position red everywhere that the
% rats velocity was below the 'freezing' threshold
% begin by including paths at top of script
runcalcfreezethresh
load '/data18/walter/stress/Dic/Diclinpos04.mat'
load '/data18/walter/stress/Cum/Cumlinpos01.mat'
track = linpos{4}{3}.statematrix.lindist;
freezetrack = [track (1:1:length(track))'];
tmp = f(1).output{1}(4).freezepostimes;  % output from runcalfreezethresh
%freezetrackX(:,1) = freezetrack(find(freezetrack(:,1)),1);
%freezetrackX(:,2) = freezetrack(find(freezetrack(:,1)),2);
freezetrack(:,1) = freezetrack(:,1).*tmp;
freezetrack(:,2) = freezetrack(:,2).*tmp;
plot(linpos{4}{3}.statematrix.lindist(1:18000));  % plot only first 10 min without extra time leading rat
hold
scatter(freezetrack(1:18000,2),freezetrack(1:18000,1),(tmp(1:18000)+.01),'r');
% modify for x axis in seconds (not samples)
timescale = 1/30:1/30:18000/30;
figure
plot(timescale, track(1:18000));
hold
scatter(freezetrack(1:18000,2)/30,freezetrack(1:18000,1),(tmp(1:18000)+.01),'r');
xlabel('time (s)');
ylabel('linear position (cm)');
title('C-track behavior; freezing in red');



load '/data18/walter/stress/Cum/Cumlinpos01.mat'


% 04-30-12
% creat task structs for Cummings
createtaskstruct('/data18/walter/stress/Cum/', 'Cum', [1 2], 'getcoord_lineartrack', 'overwrite', 0); % day 1 epoch 2
load '/data18/walter/stress/Cum/Cumtask01.mat';
createtaskstruct('/data18/walter/stress/Cum/', 'Cum', [1 3], 'getcoord_ctrack', 'overwrite', 0);  % day 1 epoch 3
lineardayprocess('/data18/walter/stress/Cum/', 'Cum', 1);  % create linpos for day 1 from task file
addtaskinfo('/data18/walter/stress/Cum/', 'Cum', [1], [2], 'environment', 'lineartrack', 'shock', 0); % 'Ctrack'
addtaskinfo('/data18/walter/stress/Cum/', 'Cum', [1], [2], 'freezetime', [nan 0]); % use NaN for unrecorded times
addtaskinfo('/data18/walter/stress/Cum/', 'Cum', [1], [3], 'environment', 'Ctrack', 'shock', 1); % 'Ctrack'
addtaskinfo('/data18/walter/stress/Cum/', 'Cum', [1], [3], 'freezetime', [nan 435]); % use NaN for unrecorded times
createtaskstruct('/data18/walter/stress/Cum/', 'Cum', [2 2], 'getcoord_ctrack', 'overwrite', 0); % day 1 epoch 3
createtaskstruct('/data18/walter/stress/Cum/', 'Cum', [2 3], 'getcoord_lineartrack', 'overwrite', 0); % day 1 epoch 3


% Automate creating task, linpos and adding task info to stress task
for d = 1:10 % cummings recording day
    if mod(d,2)
        createtaskstruct('/data18/walter/stress/Cum/', 'Cum', [d 3], 'getcoord_ctrack', 'overwrite', 0); % day 1 epoch 3
        createtaskstruct('/data18/walter/stress/Cum/', 'Cum', [d 2], 'getcoord_lineartrack', 'overwrite', 0); % day 1 epoch 3
    else % even days
        createtaskstruct('/data18/walter/stress/Cum/', 'Cum', [d 2], 'getcoord_ctrack', 'overwrite', 0); % day 1 epoch 3
        createtaskstruct('/data18/walter/stress/Cum/', 'Cum', [d 3], 'getcoord_lineartrack', 'overwrite', 0); % day 1 epoch 3
    end
end

lineardayprocess('/data18/walter/stress/Cum/', 'Cum', [1:10]);  % create linpos from task file

cftimes =[0	435
318	26
21	119
165	30
23	119
110	53
28	153
184	24
26	101
52	60
] % day x epoch  % these values can be quickly entered into a spreadsheet and then cut/pasted into matlab

for d = 1:10 % cummings recording day
    if mod(d,2)
        addtaskinfo('/data18/walter/stress/Cum/', 'Cum', [d], [2], 'environment', 'lineartrack', 'shock', 0); % 'Ctrack'
        addtaskinfo('/data18/walter/stress/Cum/', 'Cum', [d], [2], 'freezetime', [nan cftimes(d, 1)]); % use NaN for unrecorded times
        addtaskinfo('/data18/walter/stress/Cum/', 'Cum', [d], [3], 'environment', 'Ctrack', 'shock', 1); % 'Ctrack'
        addtaskinfo('/data18/walter/stress/Cum/', 'Cum', [d], [3], 'freezetime', [nan cftimes(d, 2)]); % use NaN for unrecorded times
    else % even days
        addtaskinfo('/data18/walter/stress/Cum/', 'Cum', [d], [3], 'environment', 'lineartrack', 'shock', 0); % 'Ctrack'
        addtaskinfo('/data18/walter/stress/Cum/', 'Cum', [d], [3], 'freezetime', [nan cftimes(d, 2)]); % use NaN for unrecorded times
        addtaskinfo('/data18/walter/stress/Cum/', 'Cum', [d], [2], 'environment', 'Ctrack', 'shock', 1); % 'Ctrack'
        addtaskinfo('/data18/walter/stress/Cum/', 'Cum', [d], [2], 'freezetime', [nan cftimes(d, 1)]); % use NaN for unrecorded times
    end
end

% quickly check that all task files look correct
for d = 1:9
    eval(['load(''/data18/walter/stress/Cum/Cumtask0' num2str(d) '.mat'');'])
    task{d}{2}
    task{d}{3}
end

% still need to modify...
%{
runcalcfreezethresh;
load '/data18/walter/stress/Cum/Cumlinpos01.mat'
track = linpos{1}{3}.statematrix.lindist;  % c shock track
freezetrack = [track (1:1:length(track))'];
tmp = f(1).output{1}(1).freezepostimes;  % output from runcalfreezethresh
freezetrack(:,1) = freezetrack(:,1).*tmp;
freezetrack(:,2) = freezetrack(:,2).*tmp;
%plot(track(1:18000));  % plot only first 10 min without extra time leading rat
%hold
scatter(freezetrack(1:18000,2),freezetrack(1:18000,1),(tmp(1:18000)+.01),'r');
% modify for x axis in seconds (not samples)
timescale = 1/30:1/30:18000/30;
figure
plot(timescale, track(1:18000));
hold
scatter(freezetrack(1:18000,2)/30,freezetrack(1:18000,1),(tmp(1:18000)+.01),'r');
xlabel('time (s)');
ylabel('linear position (cm)');
title('C-track behavior; freezing in red');
%}



