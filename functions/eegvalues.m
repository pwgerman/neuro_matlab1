function values=eegvalues(eeg, index, time)
% values=eegvalues(eeg, index, time)
%   Returns the values of an eegfile.  eeg is the eegdatastruct.  index
%   is an array with [day epoch tet].  time is an array with the window
%   times [starttime endtime].
%   Example:
%       eegvalues(eeg, [1 5 1], [7000 7400])
%       plot(eegvalues)

tmpeeg = eeg{index(1)}{index(2)}{index(3)};
dataindex = eegindex(tmpeeg, time);
values = tmpeeg.data(dataindex);
end

function index=eegindex(eeg, time)
% index=eegindex(eeg, time)
%   takes an eeg struct and a time and returns the index for that time in
%   the data field of that eeg.  The eeg must be for a specific
%   day-epoch-tetrode.  If time is an array of 2 or more values, it returns
%   the series of all indices between the first and last time.
%   Example:
%       index = eegindex(eeg.eeg{1}{5}{1}, [triggertime (triggertime+.5)]);

startindex = time2index(time(1), eeg.starttime, eeg.samprate);
endindex = time2index(time(end), eeg.starttime, eeg.samprate);
index = startindex:endindex;
end

function index=time2index(time, starttime, samprate)
% index=time2index(starttime, samprate)
%   returns the index that corresponds to a particular time in an array.
%   starttime is the time of array element 1.  samprate is the number of
%   samples per second.  Output index is the array index corresponding to
%   the time argument.

index = ceil((time - starttime)*samprate);
end

