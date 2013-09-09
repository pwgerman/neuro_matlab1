function out = removetestrows(matrix, testcolumn, limit)
% out = REMOVETESTROWS(tmpcout, testcolumns, limit)
% tests the values of a column in a matrix.  Entire rows that excede the limit
% in that column are removed from the matrix.
% written for script runrunriprate and function runriprate

include = matrix(:,testcolumn)>=limit;
out = matrix(include,:);