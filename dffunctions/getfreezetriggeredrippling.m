function [out] = getfreezetriggeredrippling(index, excludeperiods, ripples, estpos, varargin)
% [out] = GETFREEZETRIGGEREDRIPPLING(index, excludeperiods, ripples, spikes, varargin)
%
%   This function creates a freeze triggered rippling average. The ripples
%   are defined by the first group of cells and ### the second group of
%   cells is ignored. ####
%
%   index [day epoch tetrode cell tetrode cell]  ###
%
%   options are
%	'minthresh',
%		     specifies the minimum threshold of a valid ripple event
%   'window', 1x2 vector specifies the window before and after each included ripple.
%                   Default is 100 mseconds before and 15 seconds after
%                   ripple start time.
%   out = out.out   An R x C sized matrix where each entry is the number of
%                   spikes cell C fired during ripple R
%         out.index [D E T C], gives the identity of the cells for each
%                   column in out.out
%         out.times [starttime endtime], givest the starttime and endtime
%                   of the ripples for each row in out.out

% assign the options
minthresh = 0;
window = [0.1 0.1];
binsize = 0.001;

for option = 1:2:length(varargin)-1
    switch varargin{option}
        case 'minthresh'
            minthresh = varargin{option+1};
        case 'window'
            window = varargin{option+1};
        case 'binsize'
            binsize = varargin{option+1};
        otherwise
            error(['Option ''', varargin{option}, ''' not defined']);
    end
end


%Create times of all ripples using the first group of tetrodes
tetlist = index(:,3);
tetlist = unique(tetlist);
r = ripples{index(1,1)}{index(1,2)}{tetlist(1)};

times = r.timerange(1):0.001:r.timerange(end);
nrip = zeros(size(times));
for t = 1:length(tetlist)
    tmprip = ripples{index(1,1)}{index(1,2)}{tetlist(t)};
    if (minthresh == 0)
        % get all the times
        rtimes = [tmprip.starttime tmprip.endtime];
    else
        % get the indeces for the ripples with energy above minthreshold
        rvalid = find(tmprip.maxthresh > minthresh);
        rtimes = [tmprip.starttime(rvalid) tmprip.endtime(rvalid)];
    end
    % create another parallel vector with bordering times for zeros
    nrtimes = [(rtimes(:,1) - 0.00001) (rtimes(:,2) + 0.00001)];
    rtimes = reshape(rtimes', length(rtimes(:)), 1);
    rtimes(:,2) = 1;
    nrtimes = [r.timerange(1) ; reshape(nrtimes', ...
        length(nrtimes(:)), 1) ; r.timerange(2)];
    nrtimes(:,2) = 0;
    % create a new list with all of the times in it
    tlist = sortrows([rtimes ; nrtimes]);
    % use interp to create a set of ones and zeros for each time
    % and add to nrip to get a cumulative count of the number of
    % ripples per timestep
    try
        nrip = nrip + interp1(tlist(:,1), tlist(:,2), times, 'nearest');
    catch
        keyboard
    end
end

rip.times = times;  %same sampling as pos, spikes, etc
clear times;
rip.nripples = nrip; %number of ripples on each tetrode

%apply excludetimes
includetimes = ~isExcluded(rip.times, excludeperiods); %list of ones and zeros sampled every millisecond, ones = included, zeros = excluded
if size(rip.nripples) ~= size(includetimes)
    includetimes = includetimes';
end
includerips = rip.nripples .* includetimes;

%make a list of ripple start times
a = zeros(1, length(includerips));
a(find(includerips >= 1)) = 1;
ripstart = rip.times(diff(a)==1);

%Calculate the xcorrelation between ripples starttimes and freeze starttimes.
if ~isempty(estpos{index(1,1)}{index(1,2)}.data) 
    postime = estpos{index(1,1)}{index(1,2)}.data(:,1);
    posfreeze = estpos{index(1,1)}{index(1,2)}.data(:,10);
    [freezestart freezeend] = state2event(postime, posfreeze);
    freezetimes = freezestart;
    xcorrstruct = spikexcorr(ripstart, freezetimes, binsize, window(2));
    c1vsc2 = xcorrstruct.c1vsc2/sqrt(xcorrstruct.nspikes1*xcorrstruct.nspikes2);
end

out.c1vsc2 = c1vsc2;
out.time = xcorrstruct.time;
end