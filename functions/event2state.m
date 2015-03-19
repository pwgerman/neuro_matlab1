function [times state] = event2state(starttimes, endtimes, rate)
%[times state] = EVENT2STATE(starttimes, endtimes, rate)
%   STARTTIMES is a vector of times when a state transition occurs.  ENDTIMES
%   must be a vector of equal length to STARTTIMES.  RATE is the frequency
%   of samples that will be generated for the output vector TIMES.  The
%   output vector STATE is a boolean vector with equal length to TIMES and
%   values of 1 for times between startimes and endtimes and values of 0
%   elsewhere.  If STARTTIME and ENDTIME are equal, then only the state
%   indexed closest to STARTTIME will be 1.  
%
%   Example
%       starttimes = [ 1 4 6 7];
%       [times out] = event2state(starttimes, startimes, 1)
%
%   Note: When transitioning back and forth between event2state and
%   state2event, there will be a small expansion of time equal to the
%   sampling rate.  Thus 100 such back and forth transitions will add
%   100*rate to the end of each state occurance.  This might be avoided
%   with some recoding of this function such that end state occurs during
%   the sample BEFORE the endtime.  Doing so will also require a new way to
%   require a way to resolve simultaneous start and end times.
%   (Basic algorithm from getriptriggeredspiking.m)

buf = 0.00001;

% test starttime and endtime are row vectors
if ~isvector(starttimes) | ~isvector(endtimes)
    error('starttime and endtime must be vectors');
end
starttimes = starttimes(:);
endtimes = endtimes(:);

% test buffer and rate
timedif = diff(sort([starttimes(:); endtimes(:)]));
timedif = timedif(timedif>0);
if buf >= (min(timedif)/2)
    warning(['Buffer is greater than sampling rate. Recommend buffer < '...
        num2str(min(timedif)/2)]);
end
if rate >= (min(timedif)/2)
    warning('Sampling rate is greater than event time difference.  Events may be lost')
end

% create time index
ratemin = min([starttimes(:); endtimes(:)])-2*buf;
ratemin = ratemin - mod(ratemin,rate); % round to nearest even value of rate
ratemax = max([starttimes(:); endtimes(:)])+2*buf;
ratemax = ratemax - mod(ratemax,rate) + rate;
times = (ratemin:rate:(ratemax+rate))';

% check if startimes and endtimes are same length
switch length(starttimes) - length(endtimes)
    case 0
        ;
    case 1 % one extra starttime, assumed to be at end
        endtimes = [endtimes; (ratemax+2*rate)];
    case -1 % one extra endtime; assumed to be at beginning
        starttimes = [(ratemin-2*rate); starttimes];
    otherwise
        error(['startimes and endtimes may not differ in length '...
            'by more than one']);
end

% create state vector from events
rtimes = [starttimes endtimes];
nrtimes = [(rtimes(:,1) - buf) (rtimes(:,2) + buf)];
rtimes = reshape(rtimes', length(rtimes(:)), 1);
rtimes(:,2) = 1;
nrtimes = [ratemin ; reshape(nrtimes', ...
    length(nrtimes(:)), 1) ; ratemax];
nrtimes(:,2) = 0;

% create a new list with all of the times in it
tlist = sortrows([rtimes ; nrtimes]);
tlist = unique(tlist,'rows');

% use interp to create a set of ones and zeros for each time
state = interp1(tlist(:,1), tlist(:,2), times, 'nearest');

% trim final NaN before returning output
times = times(1:end-1);
state = state(1:end-1);

        