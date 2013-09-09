function createstressinfostructs(animalname)
% CREATESTRESSINFOSTRUCTS(animalname)
% This script calls createcellinfostruct and createtetinfostruct
%
% Example: createstressinfostructs('Bukowski')

animal = animaldef(animalname, 'outputstruct', 1);

createcellinfostruct(animal.dir, animal.pre);
createtetinfostruct(animal.dir, animal.pre);