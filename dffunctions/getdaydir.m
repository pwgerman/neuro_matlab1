function strout = getdaydir(animalname, day)
% GETDAYDIR(animalname, day)
% returns a string with the name of a raw data directory for a given animal
% and day.

animal = animaldef(animalname, 'outputstruct', 1);

if day < 10
    strout = [animal.rawdir animal.name '_0' num2str(day)];
elseif day > 99
    error('The day number must be from 1 to 99)');
else
    strout = [animal.rawdir animal.name '_' num2str(day)];
end
