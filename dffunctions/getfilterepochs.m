function epochs = getfilterepochs(f, filterInput,varargin)
% epochs = GETFILTEREPOCHS(f, filterInput)
% Returns the wanted recording epochs for the data filter f.  filterInput is
% either a  cell array of filter strings (for multiple data groups), or 
% just one filter string.  Each filter string following the rules in EVALUATEFILTER.m
% Assumes that each animal's data folder has files named 'task##.mat' that
% contain cell structures with task information.
% the output epoch struct is in the format epoch{animal}{epochfilter_group}

days = [];
epochs = [];

for option = 1:2:length(varargin)-1
    switch varargin{option}
        case 'days'
            days = varargin{option+1}; 
    end
end

for an = 1:length(f)
    if isempty(f(an).animal)
        error(['You must define an animal for the filter before filtering the epochs'])
    end
    datadir = f(an).animal{2};
    animalprefix = f(an).animal{3};
    task = loaddatastruct(datadir,animalprefix,'task');
    
    if iscell(f(an).epochs) %if there are multiple filters in a cell array, create multiple epoch groups
        for j = 1:length(f(an).epochs)
            if isstr(filterInput)
                
                dayep = evaluatefilter(task,filterInput);
                if ~isempty(days)
                    dayep = dayep(ismember(dayep(:,1),days),:); % Keep only if it exists in day list
                end
                epochs{an}{j} = dayep;
            
            else
                error('Each cell in filterInput must contain a string');
            end
        end

    else
        error('FILTERINPUT must either be a cell array or a string');
    end
end

