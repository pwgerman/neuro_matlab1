% Unit test script for event2state

% create test inputs
xx = [1 5 6 9];
yy = xx+.3;

% test warnings
warning off;
[tmptimes tmpstate] = event2state(xx,xx,1);
warnstr1 = ['Sampling rate is greater than event time difference.'...
    '  Events may be lost'];
if ~isequal(lastwarn, warnstr1)
    disp('failure: warnstr1');
else
    disp('warnings OK');
end
clear tmptimes tmpstate warnstr1;
warning on;

% test values
load('unittest_event2state_values');
times = cell(1);
state = cell(1);
[times{1} state{1}] = event2state(xx,xx, .1);
[times{2} state{2}] = event2state(xx,yy, .1);

fails = 0;
for tt = 1:2
    if ~(times{tt} == ut_times{tt})
        disp(['failure: value test times ' num2str(tt)]);
        fails = fails +1;
    end
    if ~(state{tt} == ut_state{tt})
        disp(['failure: value test state ' num2str(tt)]);
        fails = fails +1;
    end
end
if ~fails
    disp('values OK');
end

testout = [times{2} state{2}];

% save testing values
%{
ut_times = times;
ut_state = state;
save('~/Src/matlab/walter/unittests/unittest_event2state_values.mat',...
    'ut_times', 'ut_state');
%}

clear times state;
clear xx yy;
clear ut_times ut_state;
clear testout fails tt;


