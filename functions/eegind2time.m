function time = eegind2time(eegstruct, index)
% function time = EEGIND2TIME(eegstruct, index)
%   Takes an eeg struct as input and an array of index values for that
%   index.  Returns an array of times the same length of the index array
%   with the corresponding times for those index values.  Useful for
%   comparison with times of other variables.
%   Example:
%       eeg = loadeegstruct(dir, pre, 'eeg', day, ep, tet);
%       eegx = eeg{day}{ep}{tet};
%       index = find(eegx.data > thresh));
%       time = EEGIND2TIME(eegx, index);
%       % this example finds times when eeg is greater than a threshold
%       % value. 
%
% Written by Walter German 2014-04-07

eegstart = eegstruct.starttime;
eegsrate = eegstruct.samprate;
eegend = (length(eegstruct.data))/eegsrate + eegstart;
tmptimes = eegstart:(1/eegsrate):eegend;
times = tmptimes(1:end-1);
time = times(index);
end
