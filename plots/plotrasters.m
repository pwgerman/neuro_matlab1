function h = plotrasters(animaldir, animalprefix, cellindex, times, varargin);
%h = PLOTRASTERS(animaldir, animalprefix, celllist, times);
%   plots, in order, the spikes from the cell list between the given times
%
%   This is totally different from mcarr plotrasters.  mcarr/plotrasters is
%   for plotting all the cells that fire simultaneously during a single
%   ripple event.
%
%   Options:
%       'datatype'  default 'spikes'
%                   'ripples'
%
%   SEPERATE CONCERNS and make CONCISE by allowing it to take any kind of
%   data, not just spikes.  Also focus on returning the scoord and let
%   separate function plot the scoord, possibly along with other variables.
%    One thing perhaps to add, is an additional output that identifies
%    properties of each row in the scoord, such as exact time; which could
%    then be combined in outside functions to form filters, so that only
%    subsets of the raster windows would be displayed based on other
%    arbitrary parameters that vary in time, such as animals position,
%    velocity, LFP power in a certain frequecy etc...

datatype = 'spikes';
colorstr = 'k';
unused = procOptions(varargin);

points = loaddatastruct(animaldir, animalprefix, datatype);
scoord = [];

if strcmp(datatype, 'spikes')
    try
        tmps = points{cellindex(1)}{cellindex(2)}{cellindex(3)}{cellindex(4)}.data(:,1);
    catch
        tmps = [];
    end
elseif strcmp(datatype, 'ripples')
    try
        tmps = points{cellindex(1)}{cellindex(2)}{cellindex(3)}.starttime;
    catch
        tmps = [];
    end
else
    error('datatype not recognized');
end
% convert tmps into a sparse vector of 0 and 1 for all times

% cut the tmps-vector at window start and end times
% stack the result into a new matrix of repeats aligned by event times
for rr = 1:size(times,1) % for each raster row
    sind{rr} = find((tmps >= times(rr,1)) & (tmps <= times(rr,2)));
    if (~isempty(sind{rr}))
        centeredspikes{rr} = tmps(sind{rr}) - times(rr,1); % center times to common window
        scoord = [scoord ; centeredspikes{rr} ones(size(sind{rr}))*rr]; % tmps(sind{rr})
    end
end

h = scoord;

% plot raster
if ~isempty(scoord)
    scoord(:,2) = scoord(:,2) - 0.4;
    %plotraster(scoord(:,1), scoord(:,2), .8, []);
    plotraster(scoord(:,1), scoord(:,2), .8, [], 'color', colorstr);
    %set(gca, 'XLim', [x1 x2]);
    set(gca, 'YLim', [0 ceil(max(scoord(:,2)))+1]);
    title(['animal ', animalprefix, '  ', num2str(cellindex)]);
end


