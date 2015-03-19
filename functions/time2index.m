function index=time2index(time, starttime, samprate)
% index=time2index(starttime, samprate)
%   returns the index that corresponds to a particular time in an array.
%   starttime is the time of array element 1.  samprate is the number of
%   samples per second.  Output index is the index corresponding to the
%   time argument.

index = ceil((time - startime)/samprate);