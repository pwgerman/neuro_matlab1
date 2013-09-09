function linearizestress(animalname, daylist)
% LINEARIZESTRESS(animalname, daylist)
%
% run lineardayprocess for stress animals
% the epochs are sleep1, stress-track1, stress-track2, sleep2, w-track1,...
% sleep3, w-track2, sleep4
% 
% Example: linearizestress('Bukowski', [1:3]);
%
% By: Walter German 07-22-2013

animal = animaldef(animalname, 'outputstruct', 1);
lineardayprocess(animal.dir, animal.pre, daylist);  % create linpos from task file