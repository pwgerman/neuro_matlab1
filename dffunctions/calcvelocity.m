function out = calcvelocity(pos,index, varargin)
% out = calcvelocity(pos,index, varargin)
% Produces a cell structure with the fields:
% time, velocity (2D)
%   INDEX - N by 2 vector [day epoch]
%
%   OPTION: 'smooth', default no smoothing
%                   to compute linear speed, can smooth linear position data.
%                   It is smoothed with a gaussian of length VSW and std VSW/4.
%                   default for lineardayprocess is 2 seconds
%
%   out = calcvelocity(pos,index, 'smooth', ?, smoothwidth')

smooth = [];
smoothwidth = [];
if ~isempty(varargin)
    smooth = varargin{2};
end
procOptions(varargin);

out.time = pos{index(1)}{index(2)}.data(:,1);
timestep = mean(diff(pos{index(1)}{index(2)}.data(:,1)));
if isempty(smooth)
    linv=diff([0; pos{index(1)}{index(2)}.statematrix.lindist])/timestep;
    linv(pos{index(1)}{index(2)}.statematrix.lindist==-1)=NaN;
elseif ~isempty(smooth)
    %to smooth
    npoints = smoothwidth/timestep;
    filtstd = smoothwidth/(4*timestep);
    % the default filter for smoothing motion direction is a n second long gaussian
    % with a n/4 second stdev
    filt = gaussian(filtstd, npoints);
    % smooth the velocity with the filter 
    smoothvel = smoothvect(pos{index(1)}{index(2)}.data(:,5), filt);
    %linv = diff(smoothdist) / timestep;
end
    out.velocity=smoothvel;

end