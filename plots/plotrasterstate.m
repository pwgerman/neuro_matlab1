function h = plotrasterstate(animaldir, animalprefix, cellindex, times, varargin);
%h = PLOTRASTERSTATE(animaldir, animalprefix, celllist, times);
%   plots, in order, the spikes from the cell list between the given times
%
%   This is totally different from mcarr plotrasters.  mcarr/plotrasters is
%   for plotting all the cells that fire simultaneously during a single
%   ripple event.
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
%
%   Example Options:
%       'color', 'r'
%       'FaceAlpha', .2     % transparency

% defaults and options
datatype = 'spikes';
colorstr = 'k';
unused = procOptions(varargin);
winsize = times(1,2) - times(1,1);
winstart = 0;

% load data
points = loaddatastruct(animaldir, animalprefix, datatype);
scoord = [];
scoord2 = [];

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
elseif strcmp(datatype, 'estpos')
    try
        tmps = points{cellindex(1)}{cellindex(2)}.data(:,[1 10]);
        [frzstart frzend]= state2event(tmps(:,1), tmps(:,2));
        tmps =[];
        tmps = frzstart'; % tmps must be row vector
        tmpe = frzend';
    catch
        warning('unable to load points')
        tmps = [];
    end
else
    error('datatype not recognized');
end

% align start and end times
if tmps(1) > tmpe(1)  % first event is end
    tmps = [NaN; tmps]; % pad tmps so aligned
end
if length(tmps) == (length(tmpe)+1) % extra start without an end
    tmpe = [tmpe; NaN]; % pad tmpe so aligned
end
if length(tmps) ~= length(tmpe)
    error('start and stop events do not align');
end


% cut the tmps-vector at window start and end times
% stack the result into a new matrix of repeats aligned by event times
for rr = 1:size(times,1) % for each raster row
    sind{rr} = find((tmps >= times(rr,1)) & (tmps <= times(rr,2))); % sind is spike/point index
    sinde{rr} = find((tmpe >= times(rr,1)) & (tmpe <= times(rr,2))); % sinde is spike/point stop index
    if (~isempty(sind{rr}))
        pairind{rr} = intersect(sind{rr}, sinde{rr}); % matching pairs of star and end in window
        if ~isempty(pairind{rr})
            centeredspikes{rr} = tmps(pairind{rr}) - times(rr,1); % center times to common window
            centeredspikese{rr} = tmpe(pairind{rr}) - times(rr,1); % center end times to common window
            scoord = [scoord ; centeredspikes{rr} centeredspikese{rr} ones(size(pairind{rr}))*rr]; % tmps(sind{rr})
        end
        
        startind{rr} = setdiff(sind{rr}, sinde{rr}); % starts with no end in window
        if ~isempty(startind{rr})
            centeredspikesstart{rr} = tmps(startind{rr}) - times(rr,1); % center times to common window
            scoord = [scoord ; centeredspikesstart{rr} winsize ones(size(startind{rr}))*rr]; % add end of window in place of end time
        end
        
        endind{rr} = setdiff(sinde{rr}, sind{rr}); % ends without a start in window
        if ~isempty(endind{rr})
            centeredspikesend{rr} = tmpe(endind{rr}) - times(rr,1); % center times to common window
            scoord = [scoord ; winstart centeredspikesend{rr} ones(size(endind{rr}))*rr]; % add start of window in place of start time
        end
    end
end

% end times for same windows in "times"
%{
for rr = 1:size(times,1) % for each raster row
    sind2{rr} = find((tmpe >= times(rr,1)) & (tmpe <= times(rr,2)));
    if (~isempty(sind2{rr}))
        centeredspikes{rr} = tmpe(sind2{rr}) - times(rr,1); % center times to common window
        scoord2 = [scoord2 ; centeredspikes{rr} ones(size(sind2{rr}))*rr]; % tmpe(sind2{rr})
    end
end
%}
% find end to the starts, which include both triggering starts and other
% starts in triggered windows, if no end in window then = end of window.


% find other start and end times relative to the trigger start times above



h = scoord;
scoord = scoord;
% plot raster
if ~isempty(scoord)
    scoord(:,3) = scoord(:,3) - 0.4;
    plotrasterbar(scoord(:,1), scoord(:,2), scoord(:,3), .8, [],...
        'color', colorstr, unused{:});
    %set(gca, 'XLim', [x1 x2]);
    set(gca, 'YLim', [0 ceil(max(scoord(:,3)))+1]);
    title(['animal ', animalprefix, '  ', num2str(cellindex)]);
end


