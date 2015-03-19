function M = outerfun(funhandle, A, B)
% M = OUTERFUN(funhandle, A, B)
% takes a function handle for a simple arithmetic operator and two vectors,
% A and B that can be of unequal length (n and m respectively)
% the output M is an m by n matrix where each element (m,n) is the output
% of function FUNHANDLE on input A(m) and B(n).
%
% example:
%           M = outerfun(@minus, [4 5 6], [1 2 3])
%M =
%      3     2     1
%      4     3     2
%      5     4     3

if ~isvector(A) | ~isvector(B)
    error('A and B must each be vectors');
end
if size(A, 1) == 1
    A = A';
end
if size(B,2) == 1
    B = B';
end

tmpA = A(:,ones(1, length(B)));
tmpB = B(ones(length(A),1), :);
M = arrayfun(funhandle,tmpA,tmpB);

% info on algorithm:
% http://www.mathworks.com/matlabcentral/newsreader/view_thread/69365
% http://mathforum.org/kb/message.jspa?messageID=803292
%
