function out = somefunction(riplist)
% somefunction will remove repeats and create a new colum listing the
% counts (count is one for unique values)
tmplist = sort(riplist);
[coact,time]=hist(tmplist, unique(tmplist));
out = [time coact'];

