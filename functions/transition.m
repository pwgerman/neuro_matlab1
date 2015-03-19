function [tstart tend]= state2event(times, state)
% [start,end] = state2event(times, state)
% times and state are Nx1 vectors of equal length.
% state is a binary state in 0 or 1 corresponding to each time
% start is a vector of times when state transitions from 0 to 1
% end is a vector of times when state transitions from 1 to 0

if ~(size(times) == size(state))
    error('times and state must be vectors of same size');
end
if ~isvector(state)
    error('Input must be vectors')
end
if size(state, 2) == 1
    state = state';
    times = times';
end

tmp = [0 diff(state)];
tstart = times(tmp==1);
tend = times(tmp==-1);

end

%% This code immediately below is taken from getriptriggeredspiking and
% it does the same thing as transition, but only gives the starttimes.
%
%make a list of ripple start times
%{
a = zeros(1, length(includerips));
a(find(includerips >= 1)) = 1;
ripstart = rip.times(diff(a)==1);
%}


