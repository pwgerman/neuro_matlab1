function plotrasterbar(x1,x2,y,h,n, varargin)
%PLOTRASTERBAR(x,y,h,n, varargin)
% modified from plotraster(x,y,h,n, varargin)
%
% plots a vertical line of height h at each x, y coordinate in figure n.
% X & Y are Nx1 (column) vectors, h & n are scalars, suggest 0.8 for h.
%
%options: any plot properties like: 'color', 'k', 'LineWidth', 4, 

if isempty(varargin)
    options = {'color', 'k'};
else
    options = varargin;
end
 
if ~isempty(n)
    figure(n)
end
if length(x1) ~= length(x2)
    error('vectors x1 and x2 must be equal length')
end

xx = [x1 x2];
patches(xx, y, .8, options{1:end});
end