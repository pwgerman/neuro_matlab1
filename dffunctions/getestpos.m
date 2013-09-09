function out = getestpos(animaldir, animalpre, epochs, varargin)  
% estpos = GETESTPOS(animalname)
% Example: estpos = getestpos('Bukowski')
% Returns estpos struct with day and epoch.  Fields include params (the
% parameters used when calling 'estimate_position_script.m' to generate the
% estpos files.  The 'data' field contains the columns for 'time x y dir
% vel xvel yvel xres yres stopped'.  The 'stopped' column is the freezing
% time value with each stop being a minimum of 2 seconds.
%
% This function processes the output files 'estpos' made form the function
% estimate_position_freezing.m

%animal = animaldef(animalname, 'outputstruct', 1);
cd(animaldir);
loaddays = unique(epochs(:,1));
estpos = loaddatastruct(animaldir, animalpre, 'estpos', loaddays);
for i = 1:size(epochs,1)
[out{epochs(i,1)}{epochs(i,2)}.time, out{epochs(i,1)}{epochs(i,2)}.freezing] = formatestpos(estpos, epochs(i,1), epochs(i,2));
end

% output in format out{day}{epoch}.field
% the output fields should included time.  the other fields should be the
% same length and index as the time field and be a string or value that can
% be used for filtering.
%freezetime = (freeze{1}{2}.data(:,10))

%------------------------------
function [time freezing]=formatestpos(estpos, day, epoch)
time = [];
freezing = [];
if ~isempty(estpos{day}{epoch}.data)
    time = estpos{day}{epoch}.data(:,1);
    freezing = estpos{day}{epoch}.data(:,10);
end

