function animal = animaldef(animalname, varargin)
% animal = ANIMALDEF(animalname, varargin)
% 
% animaldef functionreturns the file information for an animal.  The option
% 'outputstruct'= 1 switches the output to a structure with fields: name,
% pre, dir, and rawdir.  The default is used by the standard filter
% framework scripts and functions.  The struct option is called by
% Walter's functions.
%
% Examples:
% animal = animaldef('Bukowski')      returns a cell array
%
% animal = animaldef('Bukowski', 'outputstruct', 1)   returns a struct
% animal = animaldef('Bukowski', 'outputstruct', 1)   returns a struct
%   

outputstruct = 0;
[otherArgs] = procOptions(varargin);

switch lower(animalname)
    % Walter's animals
    case 'bukowski'
        animal = {'bukowski', '/Volumes/MacSD/phys/Buk/', 'Buk',...
            '/Volumes/MacSD/phys/Bukowski/',...
            '/Volumes/MacSD/phys/Buk/EEG/',...
            '/Volumes/MacSD/phys/Buk/EEGraw/'};
    case 'cummings'
        animal = {'Cummings', '/Volumes/MacSD/phys/Cum/', 'Cum',...
            '/Volumes/MacSD/phys/Cummings/',...
            '/Volumes/MacSD/phys/Cum/EEG/',...
            '/Volumes/MacSD/phys/Cum/EEGraw/'};
    case 'dickinson'
        animal = {'Dickinson', '/Volumes/MacSD/phys/Dic/', 'Dic',...
            '/Volumes/MacSD/phys/Dickinson/',...
            '/Volumes/MacSD/phys/Dic/EEG/',...
            '/Volumes/MacSD/phys/Dic/EEGraw/'};
    case 'eliot'
        animal = {'Eliot', '/Volumes/MacSD/phys/Eli/', 'Eli',...
            '/Volumes/MacSD/phys/Eliot/',...
            '/Volumes/MacSD/phys/Eli/EEG/',...
            '/Volumes/MacSD/phys/Eli/EEGraw/'};
    case 'jigsaw'
        animal = {'Jigsaw', '/Volumes/MacSD/phys/Jig/', 'Jig',...
            '/Volumes/MacSD/phys/Jigsaw/',...
            '/Volumes/MacSD/phys/Jig/EEG/',...
            '/Volumes/MacSD/phys/Jig/EEGraw/'};

    otherwise
        error(['Animal ',animalname, ' not defined.']);
end

if outputstruct
    [animalstruct.name animalstruct.dir animalstruct.pre, animalstruct.rawdir,...
        animalstruct.eegdir animalstruct.eegraw]...
        = deal(animal{1}, animal{2}, animal{3}, animal{4}, animal{5}, animal{6});
    animal = animalstruct;
end

