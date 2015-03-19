function f = excludecellsfsubset2(f, includecells, varargin)
%f = EXCLUDECELLSFSUBSET2(f, includecells)
%   Modified from EXCLUDECELLSFSUBSET (no 2) to fix a bug in comparetetcell
%   subfunction.  The orginal is kept now for compatibility with earlier
%   scripts that call it (those scripts do not hit the bug).
%
% only includes cells in includecells, can apply to single cells or cell
% pairs
% 
% Include options 'refepoch' and reference epoch number to include cells
% based on a cross epoch criteria, such as for remote replay.  omitting the
% 'refepoch' option, or specifying a value of 0 will default to only
% including cells that are in the same epoch as the rest of the comparison.
%
% Examples:
%   f = EXCLUDECELLsfsubset(f, includecells)
%   f = EXCLUDECELLsfsubset(f, includecells, 'includeepoch', 3)
%   f = EXCLUDECELLsfsubset(f, includecells, 'includeepoch', 3)
%   f = EXCLUDECELLsfsubset(f, includecells, 'includeepoch',
%   includeepochfilter, 'subset', subset); 
%
%   includeepochfilter is in the form of a normal epochfilter for the
%   filter framework.  Subset is used to define a relationship between
%   multiple epochfilters. for example includeepochfilter can be a cell
%   array with two cells each defining a different epoch.  Subset will then
%   take different relations between these two epochs.  The values can be
%   'first'     => only cells in the first epochfilter cell are analyzed
%   'second'    => only cells in the second epochfilter cell are analyzed
%   'intersect' => the intersecion of cells in first and second
%   'firstonly' => cells in first & exclude cells also in second
%   'secondonly'=> cells in second & exclude cells also in first
%   'neither'   => cells in neither of includeepochfilter cells, but with
%   PFs in other epochs.
%

includeepochfilter = [];
subset = 'first'; % default process any includefilterepochs independently
% subset options: first, second, firstonly, secondonly, intersect
procOptions(varargin);

if ~iscell(includeepochfilter)
    includeepoch{1} = getfilterepochs(f, includeepochfilter);
else
    for i = 1:length(includeepochfilter)
        includeepoch{i} = getfilterepochs(f, includeepochfilter{i});
    end
    switch subset
        case 'neither'
            includeepoch = includeepoch;
        case 'first'
            tmpincludeepoch = includeepoch{1};
            includeepoch = [];
            includeepoch{1} = tmpincludeepoch;
        case 'second'
            tmpincludeepoch = includeepoch{2};
            includeepoch = [];
            includeepoch{1} = tmpincludeepoch;
        case 'intersect'
            includeepoch = includeepoch;
        case 'firstonly'
            includeepoch = includeepoch;
        case 'secondonly'
            includeepoch = includeepoch;
    end
end

%iterate through all animals
for an = 1:length(f)
    %if strcmp(subset, 'all')
    oldsize = length(f(an).epochs);
    repsize = length(includeepoch);
    
    %f(an).epochs = repmat(f(an).epochs, 1, repsize);
    %f(an).data = repmat(f(an).data, 1, repsize);
    %f(an).excludetime = repmat(f(an).excludetime, 1, repsize);
    %f(an).excludeepoch = repmat(f(an).excludeepoch, 1, repsize);
    
    
    %iterate through the epochs within each data group
    for g = 1:length(f(an).epochs);%oldsize
        for i = 1:length(includeepoch);%repsize
            for e = 1:size(f(an).epochs{g},1) %for each epoch [day epoch]
                day = f(an).epochs{g}(e,1);
                epoch = f(an).epochs{g}(e,2);
                if (~isempty(includeepoch{i}) & ~isempty(includecells))
                    tmprefepoch = includeepoch{i}{an}{g}(includeepoch{i}{an}{g}(:,1)==day, 2); % epoch that matches filter
                    
                    includetetcell{i}{e} = includecells(includecells(:,1)==an & includecells(:,2)==day & includecells(:,3)==tmprefepoch, 4:5);
                elseif ~isempty(includeepoch{i}) % includecells is empty
                    includetetcell{i}{e} = [];
                else % refepoch is empty, use within epoch cells for inclusion
                    includetetcell{i}{e} = includecells(includecells(:,1)==an & includecells(:,2)==day & includecells(:,3)==epoch, 4:5);
                end
            end % e
        end % i
        
        if ~isempty(f(an).epochs{g})
            includetetcell = comparetetcell(f, an, g, includetetcell, subset, repsize, oldsize);
        end
        
        for i = 1:repsize
            for e = 1:size(f(an).epochs{g},1) %for each epoch [day epoch]
                tmpdata = f(an).data{g}{e};
                if (~isempty(tmpdata) & ~isempty(includetetcell{i}{e}) )
                    if strcmp(subset, 'neither')
                        if size(tmpdata, 2) ==2
                            newtmpdata = tmpdata(~ismember(tmpdata, includetetcell{i}{e}, 'rows'),:);
                        elseif size(tmpdata, 2) ==4
                            newtmpdata = tmpdata(~ismember(tmpdata(:,1:2), includetetcell{i}{e}, 'rows') & ~ismember(tmpdata(:,3:4), includetetcell{i}{e}, 'rows'), :);
                        end
                    else
                        if size(tmpdata, 2) ==2
                            newtmpdata = tmpdata(ismember(tmpdata, includetetcell{i}{e}, 'rows'),:);
                        elseif size(tmpdata, 2) ==4
                            newtmpdata = tmpdata(ismember(tmpdata(:,1:2), includetetcell{i}{e}, 'rows') & ismember(tmpdata(:,3:4), includetetcell{i}{e}, 'rows'), :);
                        end
                    end
                    f(an).data{g}{e} = newtmpdata;
                end
            end
        end
    end
end

%-------------------------------
function out = comparetetcell(f, an, g, includetetcell, subset, repsize , oldsize)
% compare if union or only condition
% return includetetcell array that meets the condition in 'subset'
% options are: INTERSECT, FIRSTONLY, SECONDONLY.  Any other subset is
% ignored.
% an is the animal index and g is the epoch filter index.  For example, if
% the epoch of interest is described by f(an).epochs.{g}

tmptetcell = [];
for i = 1:repsize
    for e = 1:size(f(an).epochs{g},1) %for each epoch [day epoch]
        if length(includetetcell) == 1
            tmptetcell = includetetcell;
            continue;
        else
            if (isempty(includetetcell{1}{e}) || isempty(includetetcell{2}{e})) & ~strcmp(subset, 'all')
                tmptetcell{i}{e} = [];
                continue;
            else
                switch subset
                    case 'intersect'
                        tmptetcell{i}{e} = intersect(includetetcell{1}{e}, includetetcell{2}{e}, 'rows');
                    case 'neither' % actually 'both' until reversed with assignment to f.data
                        tmptetcell{i}{e} = union(includetetcell{1}{e}, includetetcell{2}{e}, 'rows'); 
                    case 'firstonly'
                        tmptetcell{i}{e} = includetetcell{1}{e}(~ismember(includetetcell{1}{e}, includetetcell{2}{e}, 'rows'), :);
                    case 'secondonly'
                        tmptetcell{i}{e} = includetetcell{2}{e}(~ismember(includetetcell{2}{e}, includetetcell{1}{e}, 'rows'), :);
                    otherwise
                        tmptetcell{i}{e} = includetetcell{i}{e};
                end
            end
        end
    end % e
end % i
out = tmptetcell;

