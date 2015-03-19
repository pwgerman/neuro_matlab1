function out=getfreezetimes(animalname, varargin)
% GETFREEZETIMES(animalname, varargin)
%   Returns the total time spent
%   freezing, in sec, according to estpos.
%   Example:
%       freezetimes = getfreezetimes('Bukowkski', 'output', 'shock')
%   options:
%       'epochs', [day epoch; day epoch;...]
%           epochs = [] will load all epochs from all days
%       'samprate', default = 30
%       'output', ['shock', 'control'] default is all epochs 

%   This functin will work as input for timefilter or as filterfunction???

epochs = [];
samprate = 30;
output = 'all';
unused= procOptions(varargin);

animal = animaldef(animalname, 'outputstruct', 1);

estpos = getestpos(animal.dir, animal.pre, epochs);
task = loaddatastruct(animal.dir, animal.pre, 'task');
tmpout = [];
for d = 1:length(estpos)
    for e = 1:length(estpos{d})
        tmpout(d,e) = sum(estpos{d}{e}.freezing)/samprate;
        if task{d}{e}.shock
            shockout(d) = sum(estpos{d}{e}.freezing)/samprate;
        end
        if task{d}{e}.control
            ctrlout(d) = sum(estpos{d}{e}.freezing)/samprate;
        end
    end
end
switch output
    case 'shock'
        out = shockout;
    case 'control'
        out = ctrlout;
    otherwise
        out = tmpout;
end
end