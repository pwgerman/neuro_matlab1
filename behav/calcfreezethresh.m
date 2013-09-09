function out = calcfreezethresh(index, excludetimes, task,pos,varargin)

% Modified from maggie's code:
% function out = calcnovelobjectbehavior(index, excludetimes, task,pos,varargin)
%
%  Loads the task and pos structure for each epoch and computes
%   - percent time spent in each quadrant type for all time and for just
%   the first minute
%   - the preference for novel objects as compared to familiar objects
%   - the preference for novel objects as a function of time.
%
%   out is a structure with the following fields
%       totalpercenttime: 4 X 1 vector with % time for all minutes spent in: 
%               novel object quadrants
%               familiar object quadrants
%               novel empty quadrants
%               familiar empty quadrants
%       if there was no novel quadrants (familiar session) novel object and
%       novel empty are set to -1.

%       totalpreference: preference for novel object (or one of the
%       familiar objects if a familiar session) over the entire session

%       percenttime: 4 X 1 vector with % time for first minute spent in: 
%               novel object quadrants
%               familiar object quadrants
%               novel empty quadrants
%               familiar empty quadrants
%       if there was no novel quadrants (familiar session) novel object and
%       novel empty are set to -1.

%       preference: preference for novel object (or one of the familiar
%       objects if a familiar session) as a function of session minute

% set options
threshold = 0;
appendindex = 1;

out = [];
freezetime = [0 0]; % freezing time (s) at 2 minutes and 10 minutes
freezepostimes = []; % sample times when animal is below freezing threshold

for option = 1:2:length(varargin)-1   
    if isstr(varargin{option})       
        switch(varargin{option})
            case 'threshold'
                threshold = varargin{option+1};
            case 'appendindex'
                appendindex = varargin{option+1};
            otherwise
                error(['Option ',varargin{option},' unknown.']);
        end        
    else
        error('Options must be strings, followed by the variable');
    end
end

%Initialize variables
pos = pos{index(1)}{index(2)};
task = task{index(1)}{index(2)};

time = pos.data(:,1);
try
    freezetime = task.freezetime;
catch
    warning('no freezetime in task file');
end
freezetime10 = freezetime(2);
freezetime2 = freezetime(1);

if size(pos.data,1) > 18000
    vel10 = pos.data(1:18000,5); % only take the first 10 minutes
else
    warning(['time < 10 min, samples= ' num2str(size(pos.data,1))])
    vel10 = pos.data(:,5); % only take the first 10 minutes
end
vel2 = pos.data(1:3600,5); % only take the first 2 minutes
    
%Apply excludetimes
valid = logical(isExcluded(time, excludetimes));
%quadrants(valid) = -1;
%totaltime = sum(~valid);


%Compute freezing threshold for all time
%[b10,ix10] = sort(vel10); % sort velocity by order
%threshold = b10(freezetime10*30+1);   % make this the case for if vararg
%threshold is -1, then calculate best threshold
if isscalar(threshold) % calculate freezing with scalar threshold value
    if threshold == -1
        %threshold is -1, then calculate best threshold
        % calculate best threshold
        [b10,ix10] = sort(vel10); % sort velocity by order
        threshold = b10(freezetime10*30+1);
    end
    %elseif isscalar(threshold) % calculate freezing with scalar threshold value
    freezepostimes = pos.data(:,5)<threshold;
    estfreeze(1) = sum(vel2<threshold)/30;
    estfreeze(2) = sum(vel10<threshold)/30;
    estaccuracy = estfreeze -freezetime;
else % calculate the time (s) below freezing threshold in 10 min
    % this block of code is for testing many thresholds to see what works
    % run as case when vararg threshold is a vector
    %threshold = .1:.1:1.1;
    for i = 1:length(threshold)
        estfreeze(i,1) = sum(vel2<threshold(i))/30;
        estfreeze(i,2) = sum(vel10<threshold(i))/30;     
        estaccuracy(i,:) = estfreeze(i,:) -freezetime;
    end
end



out.threshold = threshold;
out.estfreeze = estfreeze;
out.estaccuracy = estaccuracy;
out.freezepostimes = freezepostimes;

end
