% calculate cmperpix script
%
%cm_measure = 
% measurements: sleep box = 33cm across
%               c-track = 56.5cm between center of track on each side
%               old linear box = 152cm from end to end: Angelou, Bukoski,
%               and Cummings
%               new linear box = 178cm from end to end: Dickinson Eliot, 
%               Jigsaw
% the w-track is .65 cm per pixel for all days.
% The c-track is 126 pixels across for all animals.  At 56.5 cm, it is .45
% cmperpixel for all rats
% The linear track was done on two different length boxes.  Bukowski and
% Cummings were on a 152cm long box, while the later animals were on a 178
% cm long box.  For this reason they have different cmperpix of .62 and .72
% respectively
%
% files and index numbers used for each measurement:
% linear:   Buk_01(90000)   pixels=250  cm=152
%           Cum_01(45000)   pixels=243  cm=152
%           Dic_01(85000)   pixels=245  cm=178
%           Eli_01(45000)   pixels=245  cm=178
%
% c-track:  Buk_01(54000)   pixels=128  cm=56.5
%           Cum_01(81000)   pixels=127  cm=56.5
%           Dic_01(63000)   pixels=126  cm=56.5
%           Eli_01(72000)   pixels=122  cm=56.5
%
% w-track   Eli_01(144000)  pixels=119  cm=76



time = [0 40 0]
time = [0 20 0]
frame = hms2sec(time)*30 % vector of hours, minute, seconds of frame

M =mpgread('bukowski_01.mpeg',frame,'truecolor');
M =mpgread('Cummings_01.mpeg',frame,'truecolor');
M =mpgread('Eliot_01.mpeg',frame,'truecolor');  % linear first

a = frame2im(M);
image(a);
points = ginput(2)
dist = points(1,:)-points(2,:)
pixels = abs(dist)


Cum{1} = [.65 .62 .45 .65 .65 .65 .65 .65]; % linear epoch 2  CumL-
Buk{1} = [.65 .45 .62 .65 .65 .65 .65 .65]; % c-track epoch 2  BukC-
Cum{2} = [.65 .45 .62 .65 .65 .65 .65 .65]; 
Buk{2} = [.65 .62 .45 .65 .65 .65 .65 .65]; 

Eli{1} = [.65 .72 .45 .65 .65 .65 .65 .65]; % linear epoch 2 EliL+1st
Dic{1} = [.65 .45 .72 .65 .65 .65 .65 .65]; % c-track epoch 2 DicC+1st JigC+1st
Jig{1} = [.65 .45 .72 .65 .65 .65 .65 .65]; % c-track epoch 2 DicC+1st JigC+1st
Eli{2} = [.65 .45 .72 .65 .65 .65 .65 .65]; 
Dic{2} = [.65 .72 .45 .65 .65 .65 .65 .65]; 
Jig{2} = [.65 .72 .45 .65 .65 .65 .65 .65]; 

% all tracks saved in cell arrays of cmperpix{day} for each animal
% in the ANIMDIR as 'Bukcmperpix.mat'



