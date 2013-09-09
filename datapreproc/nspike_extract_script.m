

nspike_extract -all Angelou_01_062911_fullexp.global.dat 
nspike_extract -pos64 Angelou_01_062911_fullexp.global.dat 

% Usage: nspike_extract [-spike] [-cont] [[-pos] [-pos64]] [-dio] [-diotext] [-event] [-all] [-toffset time_to_add] [-fixtime actualtime computedtime] datafile
%	-toffset will add the specified amount of time to each timestamp.  Use this if data collection was interrupted and you need to append data from one session to the end of another. 
%   -cont will generate lfp channels as well as possynctimes

nspike_extract -cont Angelou_01_062911_fullexp.global.dat 
nspike_extract -all Angelou_01_062911_fullexp.global.dat 

nspike_postimestamp64 -cd angelou01_1.cpudsptimecheck -cp angelou01_1.cpupostimestamp -ps possynctimes -o angelou01_1.postimestamp


nspike_fixpos64 -p angelou01_1.mpeg -t angelou01_1.postimestamp -o angelou01_1_2e.p -tstart 0:17:30 -tend 0:20:50 -skip 3 -f64 angelou01_1.mpegoffset 




nspike_fixpos64 -p angelou01_1.mpeg -t angelou01_1.postimestamp -o angelou01_1_2d.p -tstart 1:07:30 -tend 1:31:50 -skip 3 -f64 angelou01_1.mpegoffset 
nspike_fixpos64 -p angelou01_1.mpeg -t angelou01_1.postimestamp -o angelou01_1_2c.p -tstart 0:42:30 -tend 0:53:00 -skip 3 -f64 angelou01_1.mpegoffset 
nspike_fixpos64 -p angelou01_1.mpeg -t angelou01_1.postimestamp -o angelou01_1_2b.p -tstart 0:20:00 -tend 0:24:15 -skip 3 -f64 angelou01_1.mpegoffset 
nspike_fixpos64 -p angelou01_1.mpeg -t angelou01_1.postimestamp -o angelou01_1_2.p -tstart 0:14:00 -tend 0:24:15 -skip 3 -f64 angelou01_1.mpegoffset 
