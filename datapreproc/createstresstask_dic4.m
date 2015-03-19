function createstresstask_dic4(animalname, daylist, cfirst)
% CREATESTRESSTASK_DIC4(animalname, daylist, cfirst)
%   modified for Dickinson day 4 when that animal only completed the first
%   4 epochs.
%
%   createstresstask_dic4('Dickinson', 4, 1)
%
% Create task files for stress animals
% the epochs are sleep1, stress-track1, stress-track2, sleep2, w-track1,
% sleep3, w-track2, sleep4
% createstresstask(animalname, daylist, cfirst)
% Example: createstresstask('Bukowski', [1:3], 1);
% cfirst=1 indicates that the animal was exposed to the c track first on odd
% days.  cfirst=0 indicates that the c-track was experienced first on even
% days. (use 1 for Buk ; use 0 for Cum, Eli)
% written by walter 4-30-2012; modified 7-21-2012
%
%
% GETCOORD_CTRACK(directoryname,pos,index)
%23 locations need to be clicked in the following order, where the vertical
%pipe represents the physical divider in the C-track. Position 1 should
%start to the immediate left of the barrier. The click numbers associated
%with each eighth of the C-track are shown in the map below, and clicking
%should continue until the 23rd clinc is made to the immediate right of the
%physical barrier.
% Red guidelines can be used to evenly space the 23 points.
%
%   
%                      1  | 23
%                    /        \
%                   3          21
%                  /            \
%                 6              18         
%                  \            /
%                   9         15
%                     \      /
%                        12
%
% GETCOORD_LINEARTRACK(directoryname,pos,index)
%this program is called by CREATETASKSTRUCT to produce the trajectory
%coodinates for a wtrack.
%Click locations in the following order:
%   
%   1   
%    \   
%     \  
%      \
%       \
%        2
%
% GETCOORD_WTRACK(directoryname,pos,index)
%this program is called by CREATETASKSTRUCT to produce the trajectory
%coodinates for a wtrack.
%Click locations in the following order:
%   
%   1    2    3
%   |    |    |
%   |    |    |
%   |    |    |
%   |    |    |
%   4----5----6
%


animal = animaldef(animalname, 'outputstruct', 1);

for d = daylist
    if (isodd(d) & cfirst) | (~isodd(d) & ~cfirst) % c-track first days
        createtaskstruct(animal.dir, animal.pre, [d 2], 'getcoord_ctrack', 'overwrite', 0); 
        createtaskstruct(animal.dir, animal.pre, [d 3], 'getcoord_lineartrack', 'overwrite', 0); 
    else % linear-track first days
        createtaskstruct(animal.dir, animal.pre, [d 2], 'getcoord_lineartrack', 'overwrite', 0); 
        createtaskstruct(animal.dir, animal.pre, [d 3], 'getcoord_ctrack', 'overwrite', 0); 
    end
    %createtaskstruct(animal.dir, animal.pre, [d 5], 'getcoord_wtrack', 'overwrite', 0);
    %createtaskstruct(animal.dir, animal.pre, [d 7], 'getcoord_wtrack', 'overwrite', 0);
end


