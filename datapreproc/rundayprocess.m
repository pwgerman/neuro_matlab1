function rundayprocess(animalname, daylist)
% RUNDAYPROCESS(animalname, daylist)
% runs the program dayprocess for animal on all days in daylist.
% Must be run from within the animals rawdata directory.
%
% find cm/pixel for each track. create array with a cmpixpix value for each
% epoch. This must be done by creating an file called PREcmperpix.mat in
% the animals data directory.
%
% Example:
% rundayprocess('Bukowski', 1:5)


clear cmperpix;
animal = animaldef(animalname, 'outputstruct', 1);

for day = daylist
DAYDIRECT = [animal.name, '_0', num2str(day)]; % modify for days > 9
cmperpix = loaddatastruct(animal.dir, animal.pre, 'cmperpix');
dayprocess(DAYDIRECT, animal.dir, animal.pre, day, 'cmperpix', cmperpix{day}, 'diodepos', 1 );
end


