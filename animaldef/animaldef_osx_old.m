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
% 

outputstruct = 0;
[otherArgs] = procOptions(varargin);

switch lower(animalname)
    % Walter's animals
    case 'bukowski'
        animal = {'bukowski', '/Volumes/MacSD/data/Buk/', 'Buk', '/Volumes/MacSD/data/Bukowski/' };
    case 'cummings'
        animal = {'Cummings', '/Volumes/MacSD/data/Cum/', 'Cum', '/Volumes/MacSD/data/Cummings/'};
    case 'dickinson'
        animal = {'Dickinson', '/Volumes/MacSD/data/Dic/', 'Dic', '/Volumes/MacSD/data/Dickinson/'};
    case 'eliot'
        animal = {'Eliot', '/Volumes/MacSD/data/Eli/', 'Eli', '/Volumes/MacSD/data/Eliot/'};
    case 'jigsaw'
        animal = {'Jigsaw', '/Volumes/MacSD/data/Jig/', 'Jig', '/Volumes/MacSD/data/Jigsaw/'};
    otherwise
        error(['Animal ',animalname, ' not defined.']);
end

if outputstruct
    [animalstruct.name animalstruct.dir animalstruct.pre, animalstruct.rawdir] = deal(animal{1}, animal{2}, animal{3}, animal{4});
    animal = animalstruct;
end
