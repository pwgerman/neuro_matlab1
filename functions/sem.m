function out = sem(varargin)
%sem returns the standard error of the mean
%   Takes input arrays in the same form as the function
%   mean() and returns output in same form as mean()
%   see std() and var() for info on code and args
%   written by Walter German Aug 16, 2011

n = size(varargin{:},1);
denom = sqrt(n-1);
out = std(varargin{:})./denom;

end
