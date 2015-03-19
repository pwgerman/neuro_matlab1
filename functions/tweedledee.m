function out = tweedledee(iname, oname)
%checks in folder $HOME/.matlabcache/ for a file of the name
%'iname.mat'  If the variables contained in iname match those in the
%calling workspace, it loads the variables from oname.mat into the
%calling workspace.
%
%   tweedledum checks for the same input variables being present,
%   tweedledee loads the output variables if already cached, or creates a
%   new cache of output variables if they are not currently cached.
%
%   This version requires that the workspace variables in the calling
%   function/script are cleared before the script is begun.  Otherwise, the
%   extra variables either during the previous run or during the current
%   run will make it appear as though the input variables have changed.

newvars = evalin('caller','whos');
%mkdir('~/.matlabcache')
cachevars = load(iname);
%evalin('caller',['save(''', iname,''', ''PFcells'')']);


for jj=1:length(newvars)
    newvalues{jj} = evalin('caller', newvars(jj).name); %may contain extra variables
 
    %cachevalues{jj} = eval(['cachevars.', newvars(jj).name]);
    try
    cachevalues{jj} =  getfield(cachevars, newvars(jj).name);
    catch
        disp([newvars(jj).name, '  not in cache check']);
    end %try
    %isequal(newvalues{jj}, cachevalues{jj});
    %{
    if strcmpi(args{i}, vars(jj).name)
        assignin('caller', vars(jj).name, args{i + 1});
        found = 1;
        break;
    end
    %}
end

end %function