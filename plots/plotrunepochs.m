function plotrunepochs(animalname, index)
% PLOTRUNEPOCHS(animalname, index)
% view linear and 2d track plots.  It plots both the linearfields and the 2d
% fields for both trajactories.  A pause waits for input before the next
% cell is displayed.  Currently only works with linear tracks.  This code
% does not make use of the filter framework.  For similar functionality
% within the filter framework, use plotlinfields.
%
% Profiling note: This function calls getbehavestate, which is much slower
% than the rest of the operations.  If running this on the same epoch
% multiple times, it will help to cache the output from getbehavestate.

animal = animaldef(animalname, 'outputstruct', 1);
cd(animal.dir);
includeStates =1;
%index = [1 2 2 1]; % [day epoch tetrode cell]
%animal.pre = 'Eli'; %

% load spikes, pos, linpos, task for day
eval(['load ',animal.pre,'spikes','0',num2str(index(1)), '.mat']);
eval(['load ',animal.pre,'pos','0',num2str(index(1)), '.mat']);
eval(['load ',animal.pre,'linpos','0',num2str(index(1)), '.mat']);
eval(['load ',animal.pre,'task','0',num2str(index(1)), '.mat']);
fighandle = figure;


%run getbehave state, calclinfields, and twodoccupancy maps
[state lindist] = getbehavestate(linpos, index(1), index(2), includeStates); % slow function

if length(index)==4
    trajdata = calclinfields(spikes, state, lindist, linpos, [index(1) index(2) index(3) index(4)]);
    [output] = twodoccupancy(spikes, state, linpos, pos, [index(1) index(2) index(3) index(4)]);
    drawfigure(fighandle, trajdata, output);
    subplot(2,2,1); % align title
    title([animal.name '  tet# ' num2str(index(3)) '  cell# ' num2str(index(4))]);
elseif length(index)==2
    for tet = 1: size(spikes{index(1)}{index(2)}, 2)
        if ~isempty(spikes{index(1)}{index(2)}{tet})
            for cell = 1: size(spikes{index(1)}{index(2)}{tet}, 2)
                if ~isempty(spikes{index(1)}{index(2)}{tet}{cell})
                    trajdata = calclinfields(spikes, state, lindist, linpos, [index(1) index(2) tet cell]);
                    [output] = twodoccupancy(spikes,state, linpos, pos, [index(1) index(2) tet cell]);
                    drawfigure(fighandle, trajdata, output);
                    subplot(2,2,1); % align title
                    title([animal.name '  tet# ' num2str(tet) '  cell# ' num2str(cell)]);
                    pause;
                end
            end
        end
    end
end

%---------------------------------------------
function drawfigure(fighandle, trajdata, output)
% plot the trajdata linearized firing rates and the twodoccupancy pictures
figure(fighandle);

subplot(2,2,1); plot(trajdata{1}(:,5)); % smoothed occupancy normalized linear firing rates
try
    subplot(2,2,2); imagesc(output(1).smoothedspikerate);
catch
    subplot(2,2,2); imagesc([]);
end

subplot(2,2,3); plot(trajdata{2}(:,5));
try
    subplot(2,2,4); imagesc(output(2).smoothedspikerate);
catch
    subplot(2,2,4); imagesc([]);
end
%{
% trajectories 3 and 4 (w-track)
subplot(2,4,5); plot(trajdata{3}(:,5))
subplot(2,4,6); imagesc(output(3).smoothedspikerate)
subplot(2,4,7); plot(trajdata{4}(:,5))
subplot(2,4,8); imagesc(output(4).smoothedspikerate)

% plot spike locations
figure;
subplot(1,1,1); plot(pos{index(1)}{index(2)}.data(:,2), pos{index(1)}{index(2)}.data(:,3), 'x')
hold on; plot(spikes{index(1)}{index(2)}{index(3)}{index(4)}.data(:,2), spikes{index(1)}{index(2)}{index(3)}{index(4)}.data(:,3), 'rx')
%}


