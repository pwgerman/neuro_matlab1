function patches(x, y, h, varargin)
%   x is a n by 2 matrix with pairs of x values for beginning and end of
%   bars
%   y is a vector of length n, spicifying the y coodinate of each bar in x.
%   h is the hight of bars. recommended = .8;
%   Example:
%       h = 0.8;
%       y = [1 1 2];
%       x = [1 2 ;3 4; 8 9];
%       patches(x, y, h, 'color', 'r')
%   Options:
%       'color', 'r'
%       'FaceAlpha', .2     % transparency

color = 'c';
unused = procOptions(varargin);

if size(x,2)~=2
    x = x';
    if size(x,2)~=2
        error('x must be paired coordinates for x1 and x2')
    end
end
if ~isvector(y)
    error('y must be vector');
end
if size(y, 1) < size(y,2)
    y = y';
end

yy = [y y+h];

X = [x(:,1) x(:,2) x(:,2) x(:,1)]'; % bl br ur ul
Y = [yy(:,1) yy(:,1) yy(:,2) yy(:,2)]'; 

patch(X,Y,color,'EdgeColor', 'none', unused{:});
