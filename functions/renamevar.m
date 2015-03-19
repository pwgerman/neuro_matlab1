function renamevar(oldstr, newstr)
% RENAMEVAR(oldstr, newstr)
%   Used for assigning a handle to a loaded variable when the name of the
%   variable is known as a string (oldstr).  This will assign that variable
%   to the name of another string (newstr). 
evalin('caller', [newstr ' = ', oldstr, ';']);
end