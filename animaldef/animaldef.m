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
        animal = {'bukowski', '/mnt/backup/walter/walter/phys/Buk/', 'Buk', '/mnt/backup/walter/walter/phys/Bukowski/' };
    case 'cummings'
        animal = {'Cummings', '/mnt/backup/walter/walter/phys/Cum/', 'Cum', '/mnt/backup/walter/walter/phys/Cummings/'};
    case 'dickinson'
        animal = {'Dickinson', '/mnt/backup/walter/walter/phys/Dic/', 'Dic', '/mnt/backup/walter/walter/phys/Dickinson/'};
    case 'eliot'
        animal = {'Eliot', '/mnt/backup/walter/walter/phys/Eli/', 'Eli', '/mnt/backup/walter/walter/phys/Eliot/'};
    case 'jigsaw'
        animal = {'Jigsaw', '/mnt/backup/walter/walter/phys/Jig/', 'Jig', '/mnt/backup/walter/walter/phys/Jigsaw/'};
    otherwise
        error(['Animal ',animalname, ' not defined.']);
end

if outputstruct
    [animalstruct.name animalstruct.dir animalstruct.pre, animalstruct.rawdir] = deal(animal{1}, animal{2}, animal{3}, animal{4});
    animal = animalstruct;
end
