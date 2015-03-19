function out = calcspeedeeg(index, excludetimes, eeg, pos, varargin)
%OUT = CALCEEGSPEEDEEG(INDEX,EXCLUDETIMES,EEG,POS,VARARGIN)
% computes the average envelope at a frequency band for each speed bin
% take an eeg and bin.  Calculate the average velocity of each bin (if it
% is fully, patially or non of freezing score),  Then plot histogram of
% outputs.  exclude times could be used to exclude freezing times.

% note that field names are different for different eeg types such as
% t2theta

% calculate t2theta envelope
fieldnum=3; % envelope
if ~isempty(eeg)
    eegtmp = eeg{index(1)}{index(2)}{index(3)};
    
    intimes = ~isExcluded(eegtimes(eegtmp), excludetimes);
    tmpout.eegenv = eegtmp.data(intimes,fieldnum);
    tmpout.includetimes = [eegtimes(eegtmp)' (+intimes)]; % the (+) before intimes turns logical to numeric
    tmpout.pos = pos{index(1)}{index(2)}.data(:,[1 5]);
    out = tmpout;
else
   tmpout.eegenv = [];
    tmpout.includetimes = []; % the (+) before intimes turns logical to numeric
    tmpout.pos = [];
    out = tmpout;
end
end


