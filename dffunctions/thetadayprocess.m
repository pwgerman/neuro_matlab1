function thetadayprocess(directoryname,fileprefix,days, varargin)
%THETADAYPROCESS(directoryname,fileprefix,days, options)
%
%Applies a theta filter to all epochs for each day and saves the data in
%in the EEG subdirectory of the directoryname folder. The specific
%subdirectory must be specified in directoryname.
%
%directoryname - example '/data99/user/animaldatafolder/EEG', a folder
%                containing processed matlab data for the animal
%
%fileprefix -    animal specific prefix for each datafile (e.g. 'fre')
%
%days -          a vector of experiment day numbers
%
%options -
%		'system', 1 or 2
%			specifies old (1) or new/nspike (2) rigs. Default 2.
%
%		'daytetlist', [day tet ; day tet ...]
%			specifies, for each day, the tetrodes for which theta
%			extraction should be done
%
%		'downsample', factor
%			saves only every factor points (eg. 1:factor:end).
%                       Default 10
%
%		'f', matfilename
%			specifies the name of the mat file containing the
%			theta filter to use
%			(default /usr/local/filtering/thetafilter.mat).
%			Note that the filter must be called 'thetafilter'.

daytetlist = [];
f = '';
defaultfilter = '/opt/hippo/filtering/thetafilter.mat'; %'/usr/local/filtering/thetafilter.mat';
system = 2;
downsample = 10;
instring = 'eeg';
outstring = 'theta';

%set variable options
for option = 1:2:length(varargin)-1
    switch varargin{option}
        case 'system'
            system = varargin{option+1};
        case 'daytetlist'
            daytetlist = varargin{option+1};
        case 'downsample'
            downsample = varargin{option+1};
        case 'f'
            f = varargin{option+1};
        case 'instring'
            instring = varargin{option+1};
        case 'outstring'
            outstring = varargin{option+1};
    end
end

minint = -32768;

% if the filter was not specified, load the default
if isempty(f)
    eval(['load ', defaultfilter]);
    [pathstr, filtername, ext] = fileparts(defaultfilter);
else
    eval(['load ', f]);
    [pathstr, filtername, ext] = fileparts(f);
end
eval(['thetafilter = ', filtername, ';']);

days = days(:)';

for day = days
    % create the list of files for this day that we should filter
    if (isempty(daytetlist))
        tmpflist = dir(sprintf('%s/*%s%02d-*.mat', directoryname, instring, day));
        flist = cell(size(tmpflist));
        for i = 1:length(tmpflist)
            flist{i} = sprintf('%s/%s', directoryname, tmpflist(i).name);
        end
    else
        % find the rows associated with this day
        flist = {};
        ind = 1;
        tet = daytetlist(find(daytetlist(:,1) == day),2);
        for t = tet;
            tmpflist = dir(sprintf('%s/*%s%02d-*-%02d.mat', ...
                directoryname, instring, day, t));
            nfiles = length(tmpflist);
            for i = 1:length(tmpflist)
                flist{i} = sprintf('%s/%s', directoryname, tmpflist(i).name);
            end
        end
    end
    
    % go through each file in flist and filter it
    for fnum = 1:length(flist)
        % get the tetrode number and epoch
        % this is ugly, but it works
        dash = find(flist{fnum} == '-');
        epoch = str2num(flist{fnum}((dash(1)+1):(dash(2)-1)));
        tet = str2num(flist{fnum}((dash(2)+1):(dash(2)+3)));
        
        %load the eeg file
        load(flist{fnum});
        renamevar(instring, 'eeg'); % reasign value from file to name 'eeg'
        a = find(eeg{day}{epoch}{tet}.data < -30000);
        [lo,hi]= findcontiguous(a);  %find contiguous NaNs
        for i = 1:length(lo)
            if lo(i) > 1 & hi(i) < length(eeg{day}{epoch}{tet}.data)
                fill = linspace(eeg{day}{epoch}{tet}.data(lo(i)-1), ...
                    eeg{day}{epoch}{tet}.data(hi(i)+1), hi(i)-lo(i)+1);
                eeg{day}{epoch}{tet}.data(lo(i):hi(i)) = fill;
            end
        end
        % filter it and save the result as int16
        theta{day}{epoch}{tet} = filtereeg2(eeg{day}{epoch}{tet}, ...
            thetafilter, 'int16', 1);
        % downsample if requested
        if (downsample ~= 1)
            theta{day}{epoch}{tet}.data = ...
                theta{day}{epoch}{tet}.data(1:downsample:end, :);
            theta{day}{epoch}{tet}.samprate = ...
                theta{day}{epoch}{tet}.samprate / downsample;
        end
        clear eegrec
        % replace the filtered invalid entries with the minimum int16 value of
        % -32768
        for i = 1:length(lo)
            if lo(i) > 1 & hi(i) < length(theta{day}{epoch}{tet}.data)
                theta{day}{epoch}{tet}.data(lo(i):hi(i)) = minint;
            end
        end
        
        % save the resulting file
        outputfile = sprintf('%s/%s%s%02d-%d-%02d.mat', ...
            directoryname, fileprefix, outstring, day, epoch, tet);
        name_variable(outstring, theta); %this allows the saved variable to have the filtername other than theta
        save(outputfile, outstring);
        clear theta
    end
end
end

function name_variable( name, value )
assignin('caller',name,value);
end

function renamevar(oldstr, newstr)
% RENAMEVAR(oldstr, newstr)
%   Used for assigning a handle to a loaded variable when the name of the
%   variable is known as a string (oldstr).  This will assign that variable
%   to the name of another string (newstr). 
evalin('caller', [newstr ' = ', oldstr, ';']);
end
