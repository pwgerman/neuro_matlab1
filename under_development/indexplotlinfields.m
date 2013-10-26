function indexplotlinfields(animalname, index, varargin)
% script that plots lin fields of targetted index
% example:
%   index = [1 2 2 4; 1 2 18 4; 1 2 18 8];
%   indexplotlinfields('Eliot', index);
%
% currently set to only work on linear tracks with two trajectories
% Assumes that there is a linear track in epochs 2 and 3 and plots them
% both for comparison, with similar y=axis values.

index2 = [];
unused = procOptions(varargin);

% translate numbers to animal names
if isnumeric(animalname)
    switch animalname
        case 1
            animalname = 'Bukowski';
        case 2
            animalname = 'Cummings';
        case 3
            animalname = 'Dickinson';
        case 4
            animalname = 'Eliot';
        case 5
            animalname = 'Jigsaw';
    end
end

animal = animaldef(animalname, 'outputstruct', 1);
linpos = loaddatastruct(animal.dir, animal.pre, 'linpos');
spikes = loaddatastruct(animal.dir, animal.pre, 'spikes');

if isempty(index2)
    trajnum = 2; % 4 for wtrack 
    figure
    for i= 1 : size(index,1)
        try
            trajdata = filtercalclinfields(index(i,:), [], spikes, linpos);
        catch
            %warning(['filtercalclinfields failed on ', animal.name, num2str(index(i,:))]);
            disp(['filtercalclinfields failed on ', animal.name, '  ', num2str(index(i,:))]);
        end
        r = trajdata;
        ymax = [];
        for s = 1:trajnum
            ymax(s) = max(r.trajdata{s}(:,5));
            subplot(trajnum,1,s);
            plot(r.trajdata{s}(:,1), r.trajdata{s}(:,5));
        end
        subplot(trajnum,1,1);
        title(sprintf('%s %d %d %d %d', animal.name,r.index));
        for s = 1:trajnum
            subplot(trajnum,1,s);
            axis([0 1 0 ceil(max(ymax)+.01)])
            axis 'auto x';
        end
        pause
        clf
    end
    close(gcf);

else % plot two epochs together
    if size(index)~=size(index2)
        error('the two indicies must be the same dimension');
    end
    trajnum = 2; % 4 for wtrack 
    figure
    for i= 1 : size(index,1)
        try
            trajdata = filtercalclinfields(index(i,:), [], spikes, linpos);
        catch
            %warning(['filtercalclinfields failed on ', animal.name, num2str(index(i,:))]);
            disp(['trajdata: filtercalclinfields failed on ', animal.name, '  ', num2str(index(i,:))]);
        end
        try
            trajdata2 = filtercalclinfields(index2(i,:), [], spikes, linpos);
        catch
            % this happens when the cell is not defined in this epoch
            disp(['trajdata2: filtercalclinfields failed on ', animal.name, '  ', num2str(index(i,:))]);
            trajdata2 = [];
        end
        r = trajdata;
        r2 = trajdata2;
        ymax = [];
        for s = 1:trajnum
            ymax(s) = max(r.trajdata{s}(:,5));
            subplot(trajnum,2,s);
            plot(r.trajdata{s}(:,1), r.trajdata{s}(:,5));
            subplot(trajnum,2,s+2);
            try
                plot(r2.trajdata{s}(:,1), r2.trajdata{s}(:,5));
                ymax(s+2) = max(r2.trajdata{s}(:,5));
            catch
                % there is not trajdata in r2 if failure above
            end
        end
        subplot(trajnum,2,1);
        title(sprintf('%s %d %d %d %d', animal.name,r.index));
        subplot(trajnum,2,3);
        try
            title(sprintf('%s %d %d %d %d', animal.name,r2.index));
        catch
            title(['cell not defined in this epoch']);
        end
        for s = 1:trajnum
            subplot(trajnum,2,s);
            axis([0 1 0 ceil(max(ymax)+.01)])
            axis 'auto x';
            subplot(trajnum,2,s+2);
            axis([0 1 0 ceil(max(ymax)+.01)])
            axis 'auto x';
        end
        pause
        clf
    end
    close(gcf);
end
