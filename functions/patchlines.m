function p = patchlines(plotx,ploty,varargin)
%patchlines(plotx,ploty,varargin)
%   Takes inputs where each column is a seperate line and plots them using
%   patchlines.  This is similar to lines, except it will accept arguements
%   for Face properties, in particular transparency.
%   output p is a cell array where each element is a handle to a seperate
%   line.
%   Example:
%       hp = patchlines(plotx,ploty,varargin);
%       set(hp, 'EdgeColor', 'r');
%       set(hp, 'EdgeAlpha', .1);
%       set(hp, 'LineWidth', 2)
%       set(hp, 'EdgeColor', 'r','EdgeAlpha', .1, 'LineWidth', 2)

for arg = 1:length(varargin)
    if isequal(varargin(1),{'color'}) % varargin{1}{arg} == 'color';
        varargin(1) = {'EdgeColor'};
    end
end

for cc = 1:size(plotx, 2)
    xs = plotx(:,cc);
    ys = ploty(:,cc);
    p(cc) = patchline(xs,ys, varargin{:});
end
p = p';
end
