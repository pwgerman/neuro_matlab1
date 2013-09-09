% freezetimes.m
% This is an early attempt to create an gui for clicking on a movie in order 
% to choose times the rat is freezing.  The idea is that the video will play 
% in 2 second segments and the viewer will then input yes or no depending on 
% if the animal is freezing or not.  Didn't get far and currently don't need 
% this functionality.
%ftimes = [];
[h, w, p] = size(M(1).cdata);  % use 1st frame to get dimensions
hf = figure;
set(hf, 'position', [150 150 w h]); % resize figure based on frame's w x h, and place at (150, 150)

axis off;
%hp = uipanel();
%key = get(h, 'KeyPressFcn');
M = mpgread('/data18/walter/stress/Bukowski/bukowski_01/bukowski_01.mpeg' , 1:60, 'truecolor');
movie(hf, M,1,30, [0 0 0 0]); % tell movie command to place frames at bottom left
image(M(60).cdata);
image('Clipping', 'off');
%handle = uicontrol(h, 'style', 'frame');
[x,y,button] = ginput(1);
if button == 'f'
    ftimes = [ftimes 1]
elseif button == 'g'
    ftimes = [ftimes 0]
    warning('play next movie segment');
elseif button == 'q'
    close(h);
    return;
else
    movie(h, M,1,30, [50 50 0 0]);
end
close(h);


    
