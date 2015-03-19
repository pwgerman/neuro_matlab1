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
        animal = {'bukowski', '/mnt/data18/walter/phys/Buk/', 'Buk',...
            '/mnt/data18/walter/phys/Bukowski/',...
            '/mnt/data18/walter/phys/Buk/EEG/',...
            '/mnt/data18/walter/phys/Buk/EEGraw/'};
    case 'cummings'
        animal = {'Cummings', '/mnt/data18/walter/phys/Cum/', 'Cum',...
            '/mnt/data18/walter/phys/Cummings/',...
            '/mnt/data18/walter/phys/Cum/EEG/',...
            '/mnt/data18/walter/phys/Cum/EEGraw/'};
    case 'dickinson'
        animal = {'Dickinson', '/mnt/data18/walter/phys/Dic/', 'Dic',...
            '/mnt/data18/walter/phys/Dickinson/',...
            '/mnt/data18/walter/phys/Dic/EEG/',...
            '/mnt/data18/walter/phys/Dic/EEGraw/'};
    case 'eliot'
        animal = {'Eliot', '/mnt/data18/walter/phys/Eli/', 'Eli',...
            '/mnt/data18/walter/phys/Eliot/',...
            '/mnt/data18/walter/phys/Eli/EEG/',...
            '/mnt/data18/walter/phys/Eli/EEGraw/'};
    case 'jigsaw'
        animal = {'Jigsaw', '/mnt/data18/walter/phys/Jig/', 'Jig',...
            '/mnt/data18/walter/phys/Jigsaw/',...
            '/mnt/data18/walter/phys/Jig/EEG/',...
            '/mnt/data18/walter/phys/Jig/EEGraw/'};

    otherwise
        error(['Animal ',animalname, ' not defined.']);
end

if outputstruct
    [animalstruct.name animalstruct.dir animalstruct.pre, animalstruct.rawdir,...
        animalstruct.eegdir animalstruct.eegraw]...
        = deal(animal{1}, animal{2}, animal{3}, animal{4}, animal{5}, animal{6});
    animal = animalstruct;
end

