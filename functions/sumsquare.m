function c = sumsquare(a, b)
%SUMSQUARE(a,b) is a toy function I created to play with the syntax of
%which.  Specifically the command:
%    WHICH FUN1 IN FUN2
%See "help which" for more info
%
%   Example:
%       which sum;
%       which sum in sumsquare

c = sum(a^2, b^2);

function out= sum(a, b)
out = a+b;
