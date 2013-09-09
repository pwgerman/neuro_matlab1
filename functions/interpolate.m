function out = interpolate(array)

% by Walter German 2011 - 11 - 8
% interpolate takes an n*1 array, detects zero values and replaces them
% with the average of the closest non-zero values on either side.

% this version assumes first and last values of array are non-zero
% later add an automatic check for first and last values and fix if found.

% first iteration isolates single zeros and replaces them.  multiple
% contiguous zeros are ignored (for now).


single_zeros = logical(~array(2:end-1) .* array(1:end-2) .* array(3:end));

array(2:end-1) = array(2:end-1) + single_zeros.*( (array(1:end-2) + array(3:end))./2 );

out = array;
    

