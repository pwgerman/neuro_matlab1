function [status, out] =system(input)
%function [status, out] =system_kludge(input)
% work around for bug where matclust call of system() doesn't work for my
% Ubuntu install

if strcmp(input, 'rm -r -f M_dataopen')
    [status, out] = unix(input);
    if status ~=0
        warning('system() call unsuccessful');
        if rmdir('M_dataopen', 's');
            disp('system kludge (rmdir) OK') %
            status = 0;
            out = [];
        else
            warning('system kludge failed rmdir M_dataopen');
        end
    end
    
elseif strcmp(input(1:8), 'rm -r -f')
        [status, out] = unix(input);
        disp('warn2');
        
        if status ~=0
            warning('system() call unsuccessful');
            %filename = input(9:end);
            curfile = evalin('caller', 'figattrib.openfiles{figattrib.currentopenfile}');
            if rmdir(curfile, 's'); %(filename);
                disp(['system kludge (delete) OK', curfile]) %
                status = 0;
                out = [];
            else
                warning(['system kludge failed delete', curfile]);
            end
        end   
 
else
    disp('pass through system() kludge')
    disp(input);
    [status, out] = unix(input);
end
%end


% system(['rm -r -f "' figattrib.openfiles{figattrib.currentopenfile} '"']);
% system(['mv "',figattrib.openfiles{figattrib.currentopenfile},'" "',filename,'"']);
