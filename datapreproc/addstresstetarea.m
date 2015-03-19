function addstresstetarea(animalname)
% ADDSTRESSTETAREA(animalname)
%
% This function calls addtetrodelocation(animdirect,fileprefix,tetrodes,location)
% for each stress animal.  The result is to add the 'area' field for each
% cellinfo and tetinfo struct with values 'CA1' or 'CA3'
%
% Example: addstresstetarea('Bukowski');


animal = animaldef(animalname, 'outputstruct', 1);
switch lower(animalname)
    % Walter's animals
    case 'bukowski'
        tet.ca1 = [1:13];
        tet.ca3 = [];
        tet.ref = 6;
    case 'cummings'
        tet.ca1 = [1 2 4 5 6 7 8 9 10 13 14 17];
        tet.ca3 = [3 11 12 15 16 18 19 20 21];
        tet.ref = 8;
    case 'dickinson'
        tet.ca1 = [1 2 4 5 6 7 8 9 10 13 17 18 19];
        tet.ca3 = [3 11 12 14 15 16 20 21];
        tet.ref = 1;
    case 'eliot'
        tet.ca1 = [1 3 7 8 9 10 11 12 13 14 15 16 17];
        tet.ca3 = [2 4 5 6 18 19 20 21];
        tet.ref = 1;
    case 'jigsaw'
        tet.ca1 = [1 2 4 5 6 7 8 9 10 13 14 17];
        tet.ca3 = [3 11 15 16 18 19 21];
        tet.ref = 12; % note this is a bad channel for days 1&2.  replace?
    otherwise
        error(['Animal ',animalname, ' not defined.']);
end

addtetrodelocation(animal.dir, animal.pre, tet.ca1, 'CA1');
addtetrodelocation(animal.dir, animal.pre, tet.ca3, 'CA3');
addtetrodelocation(animal.dir, animal.pre, tet.ref, 'REF');
