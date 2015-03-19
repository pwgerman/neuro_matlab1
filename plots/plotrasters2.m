function h = plotrasters2(points, times, varargin);
%h = PLOTRASTERS2(points, times, varargin);
%   plots, in order, the points between the given times
%
%   This is totally different from mcarr plotrasters.  mcarr/plotrasters is
%   for plotting all the cells that fire simultaneously during a single
%   ripple event.
%

%datatype = 'spikes';
colorstr = 'k';
alphaval = 1;
unused = procOptions(varargin);

%points = ;%loaddatastruct(animaldir, animalprefix, datatype);
scoord = [];

%{
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
%}

tmps = points;

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
    plotpatchraster(scoord(:,1), scoord(:,2), .8, [], 'color', colorstr, unused{:});
    %alpha(alphaval);
    %set(gca, 'XLim', [x1 x2]);
    set(gca, 'YLim', [0 ceil(max(scoord(:,2)))+1]);
    %title(['animal ', animalprefix, '  ', num2str(cellindex)]);
end


