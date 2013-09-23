function f = excludecellsf(f, includecells, varargin)
% f = EXCLUDECELLSF(f, includecells)
% only includes cells in includecells, can apply to single cells or cell
% pairs
% 
% Include options 'refepoch' and reference epoch number to include cells
% based on a cross epoch criteria, such as for remote replay.  omitting the
% 'refepoch' option, or specifying a value of 0 will default to only
% including cells that are in the same epoch as the rest of the comparison.
%
% Examples:
%   f = EXCLUDECELLSF(f, includecells)
%   f = EXCLUDECELLSF(f, includecells, 'refepoch', 3)

refepoch = 0;
procOptions(varargin);

%iterate through all animals
for an = 1:length(f)

    %iterate through the epochs within each data group
    for g = 1:length(f(an).epochs)

        for e = 1:size(f(an).epochs{g},1) %for each epoch
            day = f(an).epochs{g}(e,1);
            epoch = f(an).epochs{g}(e,2);
            if refepoch > 0
            includetetcell = includecells(includecells(:,1)==an & includecells(:,2)==day & includecells(:,3)==refepoch, 4:5);
            elseif refepoch == 0
            includetetcell = includecells(includecells(:,1)==an & includecells(:,2)==day & includecells(:,3)==epoch, 4:5);
            end
            tmpdata = f(an).data{g}{e};
            if size(tmpdata, 2) ==2
                newtmpdata = tmpdata(ismember(tmpdata, includetetcell, 'rows'),:);
            elseif size(tmpdata, 2) ==4
                newtmpdata = tmpdata(ismember(tmpdata(:,1:2), includetetcell, 'rows') & ismember(tmpdata(:,3:4), includetetcell, 'rows'), :);
            end
           f(an).data{g}{e} = newtmpdata;
        end
    end
end



