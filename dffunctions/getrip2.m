function out = getrip2(index, excludeperiods, spikes, ripples, task, cellinfo, cellfilter, varargin)
%   [out] = getrip(index, excludeperiods, spikes, ripples, task, cellinfo, cellfilter, varargin)
%
% built from getripactiv.  This version just returns all ripples even if a
% cell is not active.
%
%   index [day epoch tetrode cell] for each cell
%   tetlist save in animdirectory: ie bartetlist02, tetlist{2}{4} =
%   tetrodes to use for analysis
%
%   options are
%     'minnumspikes', default 1
%           min number of spikes in the entire epoch (within and outside ripples)
%           to include in analysis
%	  'appendindex' , 1 or 0, default 0
%           set to 1 to append the cell index to the output [day epoch
%           value]
%
%   out is n*2 matrix of ripple starttimes and endtimes. 

% assign the options
minnumspikes = 1;
numtetrodes = 1;
minenergy = 0;
proptetrodes = [];
appendindex = 0;
appendnumrip = 0;
for option = 1:2:length(varargin)-1
    switch varargin{option}
        case 'appendindex'
            appendindex = varargin{option+1};
        case 'minnumspikes'
            minnumspikes = varargin{option+1};
        case 'appendnumrip'
            appendnumrip = varargin{option+1};
        otherwise
            error(['Option ''', varargin{option}, ''' not defined']);
    end
end

%get tetrode with most cells
tet = gettetmaxcell(cellinfo, task, index(1,1), cellfilter, 2);
if tet == 0
    activprob = NaN; %if no qualified tetrodes with cells
    activtimes = NaN; %if no qualified tetrodes with cells
    activtimes = struct('times', []);
    tmpthresh = struct('thresh', []);
    numrip = NaN;
else
    
    r = ripples{index(1,1)}{index(1,2)}{tet(1)};
    %s = spikes{index(1,1)}{index(1,2)}{index(1,3)}{index(1,4)};
    
    if 1;%size(s.data, 1) > minnumspikes
        activcount = 0;
        numrip = 0;
        times = [];
        thresh = [];
        for i = 1:length(r.starttime) %for each ripple
            if ~isExcluded(r.starttime(i), excludeperiods) %if ripple is not excluded by exclude periods, proceed with activ coundt
                numrip = numrip + 1;
                times = [times; r.starttime(i), r.endtime(i)];
                if  r.maxthresh(i); % return all ripples %sum(isExcluded(s.data(:,1),[r.starttime(i) r.endtime(i)]))>0
                    %activcount = activcount+1;
                    %r.baseline + 2*r.std
                    % r.maxthresh(i)
                    thresh = [thresh; r.maxthresh(i)];
                    % this point has indexed ripples with spikes of
                    % interest. create matrix of ripple times and spike
                    % times here.  This could be appended as an option to
                    % the original function getripactivprob.  of call my
                    % new function getripactiv (if name not take) to
                    % prepresent it's more general character.  Just be sure
                    % to clearly label the new functionality in the help at
                    % top.
                    
                end
            end
        end
        if numrip>0
            activprob = activcount/numrip;
            activtimes = struct('times', times);
            tmpthresh = struct('thresh', thresh);
                % output{epochfilter}(cell).times
        else
            activprob = NaN;
            activtimes = struct('times', []);
            tmpthresh = struct('thresh', []);
        end
    else
        activprob = NaN; %if not enough spike
        activtimes = struct('times', []); 
    end
end
%calculate ripple rate
if appendindex == 0
    out = activprob;
elseif appendindex ==1
    %out = [index(1,:) numrip]; %activeprob
    out.numrip = [index(1,:) numrip];
end

if appendnumrip == 1
    out = [out numrip];
end

out.times = activtimes.times;
out.thresh = tmpthresh.thresh;
end

