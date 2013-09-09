function rundiodayprocess(animalname, day)
% call diodayprocess
varargin = [];

animal = animaldef(animalname, 'outputstruct', 1);
daydirect = getdaydir(animal.name, day);
diodayprocess(daydirect, animal.dir, animal.pre, day, varargin);