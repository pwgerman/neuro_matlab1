function colorspec=hue(colorname)
% HUE(colorname)
%   returns a three number array that codes for the colorname
%   hue(list) will return a list of defined colors

% replace this code with an ordered list and an algorithm to use that
% also add a simple printing of each color next to each name
switch colorname
    case 'pink'
        colorspec = [1,0.4,0.6];
    case 'list'
        colorspec = 'pink';
    otherwise
        colorspec = 'pink';
end
end