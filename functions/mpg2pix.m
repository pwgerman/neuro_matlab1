function [x,y] = mpg2pix(file, hour, minute, second)
%MPG2PIX  Get image pixels from an mpeg frame (at time = hrs,min,sec).
%
%   MPG2PIX(FILE, HOUR, MINUTE, SECOND) Displays an image of a single 
%   frame (at time hours, minutes and seconds) from an mpeg file.  
%   Use the crosshairs to find exact pixels.  These pixels are output as 
%   arrays x and y. example:
%   mpg2pix('day1.mpeg', 1, 12, 45);
%   
%   Author:     Walter German
%   Date:       2012-03-21

numpix = 2; % default number of pixels to find

sec = hms2sec(hour, minute, second);
frame = sec*30;     % 30 frames per second
M = mpgread(file, frame, 'truecolor');
a = frame2im(M);

figure;
i = image(a);
title('cmperpix image calibration: click on two points that span both x and y axis')
[x, y] = ginput(numpix);
close;

end

