function addstresstaskinfo(animalname, daylist, cfirst, shockfirst)
% ADDSTRESSTASKINFO
% add information to the task struct of an animal to be used in filter
% framework.
% addstresstaskinfo(animalname, daylist, cfirst, shockfirst)
% cfirst=1 indicates that the animal was exposed to the c-track first on 
% odd days.  cfirst=0 indicates that the linear-track was experienced first
% on odd days. (use 1 for Buk,Dic,Jig ; use 0 for Cum, Eli). type 'run' is
% automatically added by createstresstask
% [TODO: add varargin:freezetimes, fecescount]
% 
% Examples: 
% addstresstaskinfo('Bukowski', [1:8], 1, 0);
% addstresstaskinfo('Cummings', [1:10], 0, 0);
% addstresstaskinfo('Dickinson', [1:3], 1, 1);
% addstresstaskinfo('Eliot', [1:5], 0, 1);
% addstresstaskinfo('Jigsaw', 1:5, 1, 1);

animal = animaldef(animalname, 'outputstruct', 1);

if (cfirst & shockfirst) | (~cfirst & ~shockfirst)
    cshock=1;
else
    cshock=0; % linear shock
end
%loaddatastruct(animal.dir, animal.pre, 'freezetimes');
 
% Example: addtaskinfo('/data19/mkarlsso/Ale/','ale',1:10,[2 4],'exposure',1:20,'exposureday',1:10,'description','TrackB')
addtaskinfo(animal.dir, animal.pre, daylist,[2],'exposure',daylist,'exposureday',daylist); % stress epoch 2
addtaskinfo(animal.dir, animal.pre, daylist,[3],'exposure',daylist,'exposureday',daylist); % stress epoch 3
addtaskinfo(animal.dir, animal.pre, daylist,[5 7],'exposure', 1:length(daylist)*2 ,'exposureday',daylist); % wtrack
addtaskinfo(animal.dir, animal.pre, daylist,[1 4 6 8],'exposure', 1:length(daylist)*4 ,'exposureday',daylist); % sleep


for d = daylist
    if (isodd(d) & cfirst) | (~isodd(d) & ~cfirst) % c-track first
        addtaskinfo(animal.dir, animal.pre, [d], [2], 'environment', 'ctrack', 'shock', cshock); 
        addtaskinfo(animal.dir, animal.pre, [d], [3], 'environment', 'lineartrack', 'shock', ~cshock); 
    else % c-track second
        addtaskinfo(animal.dir, animal.pre, [d], [2], 'environment', 'lineartrack', 'shock', ~cshock); 
        addtaskinfo(animal.dir, animal.pre, [d], [3], 'environment', 'ctrack', 'shock', cshock); 
    end
    addtaskinfo(animal.dir, animal.pre, [d], [1], 'type', 'sleep', 'environment', 'sleep', 'shock', 0);
    addtaskinfo(animal.dir, animal.pre, [d], [4], 'type', 'sleep', 'environment', 'sleep', 'shock', 0);
    addtaskinfo(animal.dir, animal.pre, [d], [6], 'type', 'sleep', 'environment', 'sleep', 'shock', 0);
    addtaskinfo(animal.dir, animal.pre, [d], [8], 'type', 'sleep', 'environment', 'sleep', 'shock', 0);
    addtaskinfo(animal.dir, animal.pre, [d], [5], 'environment', 'wtrack', 'shock', 0);
    addtaskinfo(animal.dir, animal.pre, [d], [7], 'environment', 'wtrack', 'shock', 0);   
    for e = 1:8
        addtaskinfo(animal.dir, animal.pre, [d], [e], 'epoch', e);
    end
end



