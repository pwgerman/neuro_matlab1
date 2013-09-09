

function fearscore = behav_input_fear_read(readfile)

% fearscore = behav_input_fear_read('freezing_behav_input.csv');
%{ 
readfile = [{'freezing_behav_input.csv'},{'feces_behav_input.csv'},...
    {'rest-count_behav_input.csv'}];
%}

%[behd,varnames,casenames] = tblread('feces_behav_input.csv', ',');
%[behd,varnames,casenames] = tblread('rest-count_behav_input.csv', ',');
[fdata,varnames,casenames] = tblread(readfile, ',');

%fearscore = fdata;


% fmetric define values
frzS =1; % freezing time (seconds) in shock context (or practice)
frzC =2; % freezing time (seconds) in control context
fcsS =3; % feces
fcsC =4;
rcS =5; % rest counts
rcC =6;

% define data columns
shock_first =1; % experienced shock track first on day 1 (1 = TRUE)
shock_linear  =2; % experienced shock in linear track (1 = TRUE)
stress_track  =3; % data row is for shock track
control_track =4; % data row is for control track
practice_track =5; % data row is for practice track when substituted for shock track
rat_name      =6;
rat_number    =7;
record_1      =8; % recording day 1
record_2      =9;
record_3      =10;
record_4      =11;
record_5      =12;
record_6      =13;
record_7      =14;
rat_name      =15;
cond_1_2min   =16; % fear conditioning day 1at 2 minute time point
cond_2_2min   =17;
cond_3_2min   =18;
cond_4_2min   =19;
retrain_2min  =20; % fear re-conditioning between recording days 3 and 4
cond_1_10min  =21; % fear conditioning day 1 at 10 minutes time
cond_2_10min  =22;
cond_3_10min  =23;
cond_4_10min  =24;
retrain_10min =25;


%fearscore{rat}(day,fmetric)
numrats = size(fdata, 1)/2;
fearscore = cell(numrats,1);
fdata = fdata(:,record_1:record_7);
for rat = 1:numrats
    fearscore{rat}(:,1) = fdata(rat,:)';  %fearscore{rat}(day,fmetric)
    fearscore{rat}(:,2) = fdata(rat+numrats,:)'; % control context
end

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
%}
