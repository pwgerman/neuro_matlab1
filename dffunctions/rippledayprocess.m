function rippledayprocess(directoryname,fileprefix,days, varargin)
%RIPPLEDAYPROCESS(directoryname,fileprefix,days, options)
%
%Applies a ripple filter to all epochs for each day and saves the data in
%in the EEG subdirectory of the directoryname folder.  
%
%directoryname - example '/data99/user/animaldatafolder', a folder 
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
%			specifies, for each day, the tetrodes for which ripple
%			extraction should be done
%
%		'f', matfilename
%			specifies the name of the mat file containing the
%			ripple filter to use 
%			(default /usr/local/filtering/ripplefilter.mat).  
%			Note that the filter must be called 'ripplefilter'.
%       'nonreference', 0 or 1
%           specifies whether to use EEG or EEGnonreference to complete
%           filtering. Default 0
%       'assignphase', 0 or 1
%           specifies whether to ignore spike fields (0) or assign a ripple
%           phase to each spike and save the data (1) in the spike
%           structure.
%           Default 0.
%       'instring', datastructname
%           default is 'eeg' will load eeg data files, i.e.
%           'Bukeeg02-2-05.mat'.

daytetlist = [];
f = '';
defaultfilter = 'ripplefilter.mat'; %'/opt/hippo/filtering/ripplefilter.mat';
system = 2;
subtractreference = 0;
assignphase = 0;
instring = 'eeg';

%set variable options
for option = 1:2:length(varargin)-1
    switch varargin{option}
        case 'daytetlist'
            daytetlist = varargin{option+1};
        case 'f'
            f = varargin{option+1};
        case 'nonreference'
            subtractreference = varargin{option+1};
        case 'assignphase'
            assignphase = varargin{option+1};
        case 'instring'
            instring = varargin{option+1};
    end
end

minint = -32768;

% if the filter was not specified, load the default
if isempty(f) 
    eval(['load ', defaultfilter]);
else
    eval(['load ', f]);
end

days = days(:)';

for day = days
    if assignphase
        %load the spike file
        spikes = loaddatastruct(directoryname,fileprefix,'spikes',day);
    end
    % create the list of files for this day that we should filter
    if (isempty(daytetlist))
        if subtractreference
            tmpflist = dir(sprintf('%s/EEGnonreference/*%s%02d-*.mat', directoryname, instring, day));
        else
            tmpflist = dir(sprintf('%s/EEG/*%s%02d-*.mat', directoryname, instring, day));
        end
        flist = cell(size(tmpflist));
        for i = 1:length(tmpflist)
            if subtractreference
                flist{i} = sprintf('%s/EEGnonreference/%s', directoryname, tmpflist(i).name);
            else
                flist{i} = sprintf('%s/EEG/%s', directoryname, tmpflist(i).name);
            end
       end
    else
       % find the rows associated with this day
       flist = {};
       tet = daytetlist(find(daytetlist(:,1) == day),2);
       for t = tet;
           if subtractreference
               tmpflist = dir(sprintf('%s/EEGnonreference/*%s%02d-*-%02d.mat', ...
                      directoryname, instring, day, t));
           else
               tmpflist = dir(sprintf('%s/EEG/*%s%02d-*-%02d.mat', ...
                  directoryname, instring, day, t));
           end
      	   nfiles = length(tmpflist); 
	   for i = 1:length(tmpflist)
           if subtractreference
    	       flist{iind} = sprintf('%s/EEGnonreference/%s', directoryname, tmpflist(i).name);
           else
               flist{iind} = sprintf('%s/EEG/%s', directoryname, tmpflist(i).name);
           end
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
        indata = getfield(load(flist{fnum}), instring); %load(flist{fnum});
        a = find(indata{day}{epoch}{tet}.data < -30000);
        [lo,hi]= findcontiguous(a);  %find contiguous NaNs
    	for i = 1:length(lo)
            if lo(i) > 1 & hi(i) < length(indata{day}{epoch}{tet}.data)
                fill = linspace(indata{day}{epoch}{tet}.data(lo(i)-1), ...
                    indata{day}{epoch}{tet}.data(hi(i)+1), hi(i)-lo(i)+1);
                indata{day}{epoch}{tet}.data(lo(i):hi(i)) = fill;
        	end
        end
        % filter it and save the result as int16
        ripple{day}{epoch}{tet} = filtereeg2(indata{day}{epoch}{tet}, ...
            ripplefilter, 'int16', 1); 
        clear eegrec
        % replace the filtered invalid entries with the minimum int16 value of
        % -32768
        for i = 1:length(lo)
            if lo(i) > 1 & hi(i) < length(ripple{day}{epoch}{tet}.data)
                ripple{day}{epoch}{tet}.data(lo(i):hi(i)) = minint;
            end
        end

        % save the resulting file
        if subtractreference
            ripplefile = sprintf('%s/EEGnonreference/%sripple%02d-%d-%02d.mat', ...
                directoryname, fileprefix, day, epoch, tet);
        else
            ripplefile = sprintf('%s/EEG/%sripple%02d-%d-%02d.mat', ...
                directoryname, fileprefix, day, epoch, tet);
        end
        save(ripplefile, 'ripple');

        if assignphase && ~isempty(spikes) && ~mod(epoch,2)
            %check to see if there are spikes on this tetrode
            s = [];
            try
                s = spikes{day}{epoch}{tet};
            end
            if ~isempty(s)
                g = ripple{day}{epoch}{tet};
                gtimes = g.starttime:(1/g.samprate):(g.starttime+ ... 
                    (length(g.data)-1)/g.samprate);
                for c = 1:length(s)
                    data = [];
                    try
                        data = s{c}.data;
                    end
                    if ~isempty(data)
                        ind = lookup(data(:,1),gtimes);
                        spikes{day}{epoch}{tet}{c}.ripplephase = ...
                            double(g.data(ind,2))/10000;
                    end
                end
            end
        end
        clear ripple
    end
    
    if assignphase
        savedatastruct(spikes,directoryname,fileprefix,'spikes');
    end
end

