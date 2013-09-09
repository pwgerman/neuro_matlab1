function [x,y] = cmperpix(file, hour, minute, second)
%CMPERPIX Calculates cm per pixel for an mpeg frame
%
%   CMPERPIX Calculates cm per pixel for an mpeg frame.  First, the mpeg
%   frame is displayed as an image.  Click with the mouse on opposite
%   corners of the image to define x1,y1 and x2,y2 coordinates.  Then a 
%   dialog is opened which asks for the dimensions in cm of the image for
%   both x and y coordinates.  The output [x,y] is the cm per pixel
%   conversion factors for each dimension.

% inputdlg arguements
prompt={'Enter the x dimension in cm:',...
        'Enter the y dimension in cm:'};
name='Input for cmperpix';
numlines=1;
defaultanswer={'1','1'};
options.Resize='on';
options.WindowStyle='normal';
options.Interpreter='tex';

% mpg2pix input image
fprintf('%s \n', 'Please wait while I retrieve the video frame...');
[xpix , ypix] = mpg2pix(file, hour, minute, second);
dxpix = abs(xpix(1) - xpix(2));
dypix = abs(ypix(1) - ypix(2));
fprintf('%s %6.1f %6.1f %6.1f %6.1f \n', 'The values of x(1), x(2) and y(1) y(2) are (pixels):', xpix(1), xpix(2), ypix(1), ypix(2));
fprintf('%s %6.1f %6.1f \n', 'The measures of x and y are (pixels):', dxpix, dypix);

% cm input dialog
answer=inputdlg(prompt,name,numlines,defaultanswer,options);
xcm = str2num(answer{1});
ycm = str2num(answer{2}); 
fprintf('%s %6.0f %6.0f \n', 'The measures of x and y are (cm):', xcm, ycm);

x = xcm/dxpix;
y = ycm/dypix;
%disp([x,y]);
fprintf('%s %6.3f %6.3f \n', 'The conversion factors for x and y are (pix/cm):', x,y);

end