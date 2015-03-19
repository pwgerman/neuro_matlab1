function times = eegtimes(eegstruct)
% times = EEGTIMES(eegstruct)
%   Takes an eeg struct and returns an array of times the same length as
%   eeg.data.  This is particularly useful for plotting eeg data with
%   corresponding times.
%   Example:
%       eeg = loadeegstruct(dir, pre, 'eeg', day, ep, tet);
%       eegx = eeg{day}{ep}{tet};
%       plot(EEGTIMES(eegx), eegx.data);
%
% Written by Walter German 2014-04-07

if isempty(eegstruct)
    times = [];
else
    eegstart = eegstruct.starttime;
    eegsrate = eegstruct.samprate;
    eegend = (length(eegstruct.data))/eegsrate + eegstart;
    tmptimes = eegstart:(1/eegsrate):eegend;
    times = tmptimes(1:end-1);
end

