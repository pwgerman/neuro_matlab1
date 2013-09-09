function ndh(varargin)
% function NDH(command)
% ndh() *NoDesktop History* executes whatever command is given to it,
% including any arguments and parameters as normal.  It adds the command
% to a history list in the preferences directory called 'ndhistory.m'.  The
% preferences directory can be found with the prefdir command. 
% Example:  ndh('out = sqrt(9)')
%           ndh('clean')
%           ndh(n)
% Some special commands will not be evaluated but will be acted on by
% ndhistory.  These commands are 'clean', which erases the ndhistory.m
% file.  ndh(n) will display the last n commands in ndhistory.
% The purpose of ndh() is to allow an easy way to write a history file
% when matlab does not by default.  This is the case when running matlab
% with the '-nodesktop' parameter at startup, as is often useful when
% running from a remote terminal. 

pdir = eval('prefdir');
filename = [pdir, '/ndhistory.m'];

if (nargin ~= 1)
    warning('ndh() requires one argument'); % not strictly necessary as function call specifies only one argument
end

if isnumeric(varargin{1})
    num = int8(varargin{1});
    if isunix
    eval(['!tail -n ' num2str(num) ' ' filename]);
    else
        warning(['Sorry, this option is only written for unix. Please '...
            'edit function file to add this functionality for your OS.']);
    end
    return;
end

if ischar(varargin{1})
    command = varargin{1};
    try
        fid = fopen(filename,'a+');
    catch
        warning(['unable to open file: ' filename]);
    end
    
    % special command for ndh to clear history, etc...
    if strcmp(command, 'clean')
        reply = input('Delete ndhistory? Y/N [Y]: ', 's');
        if isempty(reply)
            reply = 'N';
        elseif strcmpi(reply, 'Y')
            try
                fid = fopen(filename,'w');
            catch
                warning(['unable to open file: ' filename]);
            end
            fprintf(fid, '');
            fclose(fid);
            display('ndhistory cleared');
        end
        return
    end
    
    % commands not for ndh are evaluated
    fprintf(fid, [command '\n']);
    fclose(fid);
    evalin('caller', command);
    return
else
        warning('arguments cannot be processed');
end
