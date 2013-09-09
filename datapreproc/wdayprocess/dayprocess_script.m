% script for dayprocess

% find cm/pixel for each track. create array with a cmpixpix value for each epoch.
% example
% cmpx_lin = [0.623 0.765 0.456 0.623 0.644 0.623 0.644 0.623];
% cmpx_c = [0.623 0.456 0.765 0.623 0.644 0.623 0.644 0.623];
% use cmpx_lin for days when linear track is first and cmpx_c when c-track is first
% wdayprocess is a modification of dayprocess that take a vector of
% different values for each epoch.

clear cmperpix;

%{
cd /data18/walter/Bukowski/;
ANIMPREFIX = 'Buk';
ANIMDIRECT = '/data18/walter/Buk';
ANIMAL = 'Bukowski';
DAYLIST =  1:8;


cd /data18/walter/Cummings/;
ANIMPREFIX = 'Cum';
ANIMDIRECT = '/data18/walter/Cum';
ANIMAL = 'Cummings';
DAYLIST =  2:10;


cd /data18/walter/Dickinson/;
ANIMPREFIX = 'Dic';
ANIMDIRECT = '/data18/walter/Dic';
ANIMAL = 'Dickinson';
DAYLIST =  1:4;

%}
% for Eliot first make times files
cd '/mnt/backup/walter/walter/phys/Cummings'  
ANIMPREFIX = 'Cum';
ANIMDIRECT = '/mnt/backup/walter/walter/phys/Cum'; 
ANIMAL = 'Cummings';
DAYLIST =  4;


%{
% for Eliot first make times files
cd '/mnt/backup/walter/walter/phys/Eliot'  % /data18/walter/Eliot/;
ANIMPREFIX = 'Eli';
ANIMDIRECT = '/mnt/backup/walter/walter/phys/Eli'; % '/data18/walter/Eli';
ANIMAL = 'Eliot';
DAYLIST =  1:5;

cd /data18/walter/Jigsaw/;
ANIMPREFIX = 'Jig';
ANIMDIRECT = '/data18/walter/Jig';
ANIMAL = 'Jigsaw';
DAYLIST =  1:5;
%}

for day = DAYLIST
DAYDIRECT = [ANIMAL, '_0', num2str(day)];

load([ANIMDIRECT, '/' ,ANIMPREFIX, 'cmperpix.mat']);
wdayprocess2(DAYDIRECT, ANIMDIRECT, ANIMPREFIX, day, 'cmperpix', cmperpix{day}, 'diodepos', 1 );
end


