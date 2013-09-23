function f = excludecellsf2(f, includecells, varargin)
% f = EXCLUDECELLSF2(f, includecells)
% only includes cells in includecells, can apply to single cells or cell
% pairs
% 
% Include options 'refepoch' and reference epoch number to include cells
% based on a cross epoch criteria, such as for remote replay.  omitting the
% 'refepoch' option, or specifying a value of 0 will default to only
% including cells that are in the same epoch as the rest of the comparison.
%
% Examples:
%   f = EXCLUDECELLSF2(f, includecells)
%   f = EXCLUDECELLSF2(f, includecells, 'includeepoch', 3)

includeepochfilter = [];
action = 'all'; % default process any includefilterepochs independently
% action options: all, first, second
procOptions(varargin);

if ~iscell(includeepochfilter)
    includeepoch{1} = getfilterepochs(f, includeepochfilter);
else
    for i = 1:length(includeepochfilter)
        includeepoch{i} = getfilterepochs(f, includeepochfilter{i});
    end
    switch action
        case 'all'
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

% includeepoch{i}{an}{g}

%iterate through all animals
for an = 1:length(f)
    %if strcmp(action, 'all')
    oldsize = length(f(an).epochs);
    repsize = length(includeepoch);
    
    f(an).epochs = repmat(f(an).epochs, 1, repsize);
    f(an).data = repmat(f(an).data, 1, repsize);
    f(an).excludetime = repmat(f(an).excludetime, 1, repsize);
    f(an).excludeepoch = repmat(f(an).excludeepoch, 1, repsize);
    
    
    %iterate through the epochs within each data group
    for g = 1:oldsize
        for i = 1:repsize
            gi = ((i-1)*oldsize +g); % new index for repmat(f)
            for e = 1:size(f(an).epochs{gi},1) %for each epoch [day epoch]
                day = f(an).epochs{gi}(e,1);
                epoch = f(an).epochs{gi}(e,2);
                if ~isempty(includeepoch{i})
                    tmprefepoch = includeepoch{i}{an}{g}(includeepoch{i}{an}{g}(:,1)==day, 2);
                    
                    includetetcell{i}{e} = includecells(includecells(:,1)==an & includecells(:,2)==day & includecells(:,3)==tmprefepoch, 4:5);
                else % refepoch is empty, use within epoch cells for inclusion
                    includetetcell{i}{e} = includecells(includecells(:,1)==an & includecells(:,2)==day & includecells(:,3)==epoch, 4:5);
                end
            end % e
        end % i
        
        % compare if union or only condition
        for i = 1:repsize
            gi = ((i-1)*oldsize +g); % new index for repmat(f)
            for e = 1:size(f(an).epochs{gi},1) %for each epoch [day epoch]
                if length(includetetcell) == 1
                    continue;
                else
                    if (isempty(includetetcell{1}{e}) || isempty(includetetcell{2}{e}))
                        includetetcell{i}{e} = [];
                        continue;
                    else
                        switch action
                            case 'intersect'
                                tmptetcell{i}{e} = intersect(includetetcell{1}{e}, includetetcell{2}{e}, 'rows');
                                includetetcell{i}{e} = tmptetcell{i}{e};
                            case 'firstonly'
                                tmptetcell{i}{e} = includetetcell{1}{1}(~ismember(includetetcell{1}{1}, includetetcell{2}{1}, 'rows'), :)
                                includetetcell{i}{e} = tmptetcell{i}{e};
                            case 'secondonly'
                                tmptetcell{i}{e} = includetetcell{2}{1}(~ismember(includetetcell{2}{1}, includetetcell{1}{1}, 'rows'), :)
                                includetetcell{i}{e} = tmptetcell{i}{e};
                            otherwise
                                includetetcell{i}{e} = includetetcell{i}{e};
                        end
                    end
                end
            end % e
        end % i
        
        
        for i = 1:repsize
            gi = ((i-1)*oldsize +g); % new index for repmat(f)
            for e = 1:size(f(an).epochs{gi},1) %for each epoch [day epoch]
                tmpdata = f(an).data{gi}{e};
                if size(tmpdata, 2) ==2
                    newtmpdata = tmpdata(ismember(tmpdata, includetetcell{i}{e}, 'rows'),:);
                elseif size(tmpdata, 2) ==4
                    newtmpdata = tmpdata(ismember(tmpdata(:,1:2), includetetcell{i}{e}, 'rows') & ismember(tmpdata(:,3:4), includetetcell{i}{e}, 'rows'), :);
                end
                f(an).data{gi}{e} = newtmpdata;
            end
        end
    end
    
end

