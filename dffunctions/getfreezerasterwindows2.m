function [out] = getfreezerasterwindows2(index, excludeperiods, estpos, task,...
    cellinfo, cellfilter, varargin)

%function [out] = getfreezerasterwindows2(index, excludeperiods, spikes, ripples, task,...
%    cellinfo, cellfilter, varargin)
%is siliar to getfreezerasterwindows escept it is now optiminzed to be
%called by the epochbehaveanal iterator instead of the single cell iterator.
%
%
%   index [day epoch tetrode cell] for each cell
%   tetlist save in animdirectory: ie bartetlist02, tetlist{2}{4} =
%   tetrodes to use for analysis
%
%   options are
%	  'appendindex' , 1 or 0, default 0
%           set to 1 to append the cell index to the output [day epoch
%           value]
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



% assign the options
window = [20 20];
appendindex = 0;
for option = 1:2:length(varargin)-1
    switch varargin{option}
        case 'appendindex'
            appendindex = varargin{option+1};
        case 'window'
            window = varargin{option+1};
        otherwise
            error(['Option ''', varargin{option}, ''' not defined']);
    end
end

%get tetrode with most cells
%tet = gettetmaxcell(cellinfo, task, index(1,1), cellfilter, 2)
%if tet == 0
%    out.times = []; %if no qualified tetrodes with cells
%else
    d = index(1,1); % day
    e = index(1,2); % epoch
    if ~isempty(estpos{d}{e}.data)
    postime = estpos{d}{e}.data(:,1);
    posfreeze = estpos{d}{e}.data(:,10);
    [freezestart freezeend] = state2event(postime, posfreeze);
    rasterwindow = [(freezestart - window(1,1))' (freezestart + window(1,2))'];% GETRASTER OUTPUT
    end
    % make raster state bars
    


    %{
    r = ripples{index(1,1)}{index(1,2)}{tet(1)};
    rasterwindow = [];
        for i = 1:length(r.starttime) %for each ripple
            if ~isExcluded(r.starttime(i), excludeperiods) %if ripple is not excluded by exclude periods, proceed with activ coundt
                rasterwindow = [(r.starttime - window(1,1)) (r.starttime + window(1,2))];% GETRASTER OUTPUT          
            end
        end
    %}
%end

%out.tet = tet;
out.times = {rasterwindow};


