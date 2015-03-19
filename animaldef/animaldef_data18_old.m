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
        animal = {'bukowski', '/mnt/data18/walter/phys/Buk/', 'Buk', '/mnt/data18/walter/phys/Bukowski/' };
    case 'cummings'
        animal = {'Cummings', '/mnt/data18/walter/phys/Cum/', 'Cum', '/mnt/data18/walter/phys/Cummings/'};
    case 'dickinson'
        animal = {'Dickinson', '/mnt/data18/walter/phys/Dic/', 'Dic', '/mnt/data18/walter/phys/Dickinson/'};
    case 'eliot'
        animal = {'Eliot', '/mnt/data18/walter/phys/Eli/', 'Eli', '/mnt/data18/walter/phys/Eliot/'};
    case 'jigsaw'
        animal = {'Jigsaw', '/mnt/data18/walter/phys/Jig/', 'Jig', '/mnt/data18/walter/phys/Jigsaw/'};
    otherwise
        error(['Animal ',animalname, ' not defined.']);
end

if outputstruct
    [animalstruct.name animalstruct.dir animalstruct.pre, animalstruct.rawdir] = deal(animal{1}, animal{2}, animal{3}, animal{4});
    animal = animalstruct;
end
