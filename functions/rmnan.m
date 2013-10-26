function output = rmnan(input)
% output = RMNAN(input)
% returns a one dim output vector that is identical to an input vector, put
% all NaN values are removed.  Use with caution and note that this will
% change the size and indexing.

output = input(~isnan(input));

