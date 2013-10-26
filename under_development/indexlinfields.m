function out = indexlinfields(animalname, index)
% script that calculates peak rate (etc) for linear place fields of
% targetted index 
% example:
%   index = [1 2 2 4; 1 2 18 4; 1 2 18 8];
%   indexplotlinfields('Eliot', index);
%
% currently set to only work on linear tracks with two trajectories
% called by script scatter_rungetripactivprob_multiday_stats


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


trajnum = 2; % 4 for wtrack
for i= 1 : size(index,1)
    try
        trajdata = filtercalclinfields(index(i,:), [], spikes, linpos);
    catch
        disp(['filtercalclinfields failed on ', animal.name, '  ', num2str(index(i,:))]);
    end
    r = trajdata;
    ymax = [];
    for s = 1:trajnum
        ymax(s) = max(r.trajdata{s}(:,5));
        %[(r.trajdata{s}(:,1) r.trajdata{s}(:,5))]; % location, firingrate
        lpf = r.trajdata{s}(:,5); %linear place field
        lpf(isnan(lpf))= 0; % make NaN into zero
        mu = mean(lpf);
        %pfsize(s) = sum((lpf-mu) > 0);
        pfsize(s) = sum(lpf((lpf-mu) > 0));
    end
    imax(i) = max(ymax);
    ipfsize(i) = sum(pfsize); % add place fields in both directions together
end
%out = imax;
out = ipfsize;
