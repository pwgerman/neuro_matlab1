function out = getriptrigrasterwindows()


% calls getrasterwindow which returns ripple triggered rasters because
% ripple event are given as argin, but other triggers could be used also.


%
%   OUT is [rasterwindow] which is an Nx2 matrix where the first column is
%   starttimes for the raster window and column 2 is the endtimes.  In
%   other words, generate the rasters to appear between the times for each
%   row of OUT for use as a row in the event triggered raster plot.
%       
% getrasterwindows, ripples=triggerevents, 
% in calling function call getmaxtetcell and then use r=ripple(tet...) as event argin to getrasterwindow
%create an ancillary function called getrippleevents that preprocesses for
% best tetrode. cellfilter, task, cellinfo
%
% check for min num spikes is already in plotrasters.m




    
 % out will be the list of ripples from the best tetrode.
 % and this will then call getrasterwindows which will return rasterwindows
 % for plotting.  
 
 % ---->> This function will be more specifc, it will just return ripples
 % from the best tetrode.  The calling function will then send those on as
 % an arguement for its call to getrasterwindows.  Finally, the calling
 % function will take its returned answers from this (ripple times of best
 % tet) and of getrasterwindows and send them both as arguements to...
 %  Try again, these ripples are only used to TRIGGER the rasterwindows,
 %  the calling function will then send the spikes for that same session
 %  on with the rasterwindow output to plotrasters.
 %
 % the rasterwindows can also be filtered for certain exclude times in  a
 % similar fashion to other filter framework exclude times.
 %
 % to do this will require the use of extendfilter() so that the same
 % filter output can be used to as excludetimes and epochlists etc, for
 % inputs to the sequential function calls.
 
 
 
 
 