% loadfreezetimes
%   this script is built around the ANIfreezetimes.mat files.  those files
%   where meant to contain the manually scored freezing times for each
%   animal.  However, the formatting is off and each animals info is in a
%   different struct layout.  Currently, this info is not being used for
%   analysis while the automatice freezing scores from position_estimation
%   estpos are being used.
%
%   Currently, the output of this function shows the different struct
%   layout for each animal.  However, except for Eliot, all the times are
%   present and correct.

animals = {'Bukowski', 'Cummings','Dickinson', 'Eliot', 'Jigsaw'};
for an = 1:length(animals)
animal = animaldef(animals{an}, 'outputstruct', 1);


freezetimes = load([animal.dir animal.pre 'freezetimes.mat']);

animal.pre
frzname = fieldnames(freezetimes)
frztmp = getfield(freezetimes, frzname{1})
%frztime = frztmp{1};

%frztime = freezetimes.freeze_times;
%frztime.stress(d)
end