function [item, count] = sumreps(vector)
%SUMREPS sum of repeated elements
%   [item, count] = SUMREPS(vector)
%   VECTOR is a vector, ITEM is a row vector of unique items.
%   COUNT is the number of each corresponding item in VECTOR
%
%   item    the sorted list of unique inputs
%   count   the number of such entries in the input vector

tmplist = sort(vector);
[count, item]=hist(tmplist, unique(tmplist));
count = count';


