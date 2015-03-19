function remove_high_amplitude_raw(directoryname,fileprefix,days, instring,outstring,thresh,varargin)
% REMOVE_HIGH_AMPLITUDE_RAW(eegdirectoryname,fileprefix,days, instring,outstring,thresh,varargin)
% One the main problems with large amplitude noise is that it causes strong
% power in many bands, potentially a long time before and after the large
% amplitude event. A way to limit the temporal extent of the noise is to
% filter out these points before doing any analysis on the traces. This
% code finds the raw data greater or less than the inputed threshold
% thresh, and interpolates between those points.
%
% Consider changing the buffer variable, which determines how much temporal
% padding should be added to be around high amplitude events.
%
% example: remove_high_amplitude_raw(directoryname,fileprefix,day,'raw','foo',1500)
%
%directoryname - example '/data99/user/animaldatafolder/EEG/', a folder
%                containing processed matlab data for the animal
%
%fileprefix -    animal specific prefix for each datafile (e.g. 'fre')
%
%days -          a vector of experiment day numbers
%
%instring -      the name associated the data being read in (e.g. 'eeg' or 'raw')
%
%outstring -     the name for the files being saved (e.g. 'eeg' or 'raw' to
%                overwite current file, or maybe 'thresholded')
%
%
%options -
%
%		'daytetlist', [day tet ; day tet ...]
%			specifies, for each day, the tetrodes for which high gamma
%			extraction should be done
%       'tetfilter', 'isequal($area,''CA1'')'
%           specifies the filter to use to determine which tetrodes
%           low gamma extraction should be done. This assumes that a
%           tetinfostruct exists.

%		'f', filter
%			specifies the filter to use. This should be made specificially
%			for each animal based on individual cutoffs for low and high
%           gamma.


if nargin < 6
    thresh = 5000; %anything above or below 5000 is too big
end
buffer = 0.1; %100 ms buffer around big events

daytetlist = [];
%f = '';
tetfilter = '';
tmpflist = [];

%set variable options
for option = 1:2:length(varargin)-1
    switch varargin{option}
        case 'daytetlist'
            daytetlist = varargin{option+1};
%        case 'f'
%            f = varargin{option+1};
        case 'tetfilter'
            tetfilter = varargin{option+1};
    end
end


% check to see if the directory has a trailing '/'
if (directoryname(end) ~= '/')
    warning('directoryname should end with a ''/'', appending one and continuing');
    directoryname(end+1) = '/';
end

minint = -32768;
days = days(:)';


for day = days
    % create the list of files for this day that we should filter
    if isempty(daytetlist) && isempty(tetfilter)
        foo = sprintf('%02d-*.mat',day);
        foo = [directoryname,'*',instring,foo];
        tmpflist = dir(foo);
        %             tmpflist = dir(sprintf('%s*raw%02d-*.mat', directoryname, day));
        flist = cell(size(tmpflist));
        for i = 1:length(tmpflist)
            
            flist{i} = sprintf('%s%s', directoryname, tmpflist(i).name);
        end
    elseif ~isempty(tetfilter)
        flist = {};
        load(sprintf('%s%stetinfo.mat',directoryname,fileprefix));
        tmptetlist = evaluatefilter(tetinfo,tetfilter);
        tet = unique(tmptetlist(tmptetlist(:,1)==day,3));
        tmpflist = [];
        for t = 1:length(tet);
            
            tmp = dir(sprintf('%s%02d-*-%02d.mat', ...
                directoryname, day,tet(t)));
            
            tmpflist = [tmpflist; tmp];
        end
        for i = 1:length(tmpflist)
            
            flist{i} = sprintf('%s%s', directoryname, tmpflist(i).name);
            
        end
    else
        % find the rows associated with this day
        flist = {};
        tet = daytetlist(find(daytetlist(:,1) == day),2);
        for t = 1:length(tet);
            
            tmp = dir(sprintf('%s/*%s%02d-*-%02d.mat', ...
                directoryname, instring,day,tet(t)));
            tmpflist = [tmpflist; tmp];
        end
        for i = 1:length(tmpflist)
            
            flist{i} = sprintf('%s/%s', directoryname, tmpflist(i).name);
        end
    end
    
    length(flist)
    
    % go through each file in flist and filter it
    for fnum = 1:length(flist)
        % clear data from previous item on flist
        clear tmpdata cleandata;
        
        % get the tetrode number and epoch
        % this is ugly, but it works
        dash = find(flist{fnum} == '-');
        epoch = str2num(flist{fnum}((dash(1)+1):(dash(2)-1)));
        tet = str2num(flist{fnum}((dash(2)+1):(dash(2)+3)));
        
        % if ~mod(epoch,2) %not sure why this was here
        %load the eeg file
        tmpdata = getfield(load(flist{fnum}), instring); %load(flist{fnum});
        mydata = tmpdata{day}{epoch}{tet};
        samprate = mydata.samprate;
        mybuffer = buffer*samprate;
        mydata.noise_thresh = thresh;
        mydata.above_thresh = (abs(mydata.data) > thresh);
        mydata.num_above_thresh = sum(mydata.above_thresh);
        mydata.modified = zeros(size(mydata.data));
        above_thresh = find(abs(mydata.data(2:end-2)) > thresh);
        if ~isempty(above_thresh)
            above_thresh = above_thresh+1;
            starts = above_thresh(find(abs(mydata.data(above_thresh-1)) <= thresh));
            ends = above_thresh(find(abs(mydata.data(above_thresh+1)) <= thresh));
            
            % handle edges of data
            if abs(mydata.data(1)) > thresh
                if abs(mydata.data(2)) > thresh
                    starts = [1; starts];
                elseif abs(mydata.data(2)) < thresh
                    starts = [1; starts];
                    ends = [2; ends]; % when 1 is above thresh, but 2 is below
                end
            end
            if abs(mydata.data(end)) > thresh
                if abs(mydata.data(end-1)) > thresh
                    ends = [ends; length(mydata.data)];
                elseif abs(mydata.data(end-1)) < thresh
                    starts = [starts; length(mydata.data)-1];
                    ends = [ends; length(mydata.data)];
                end
            end
            if abs(mydata.data(end-1)) > thresh
                if abs(mydata.data(end-2)) > thresh
                    ends = [ends; length(mydata.data)-1];
                elseif abs(mydata.data(end-2)) < thresh
                    starts = [starts; length(mydata.data)-2];
                    ends = [ends; length(mydata.data)-1];
                end
            end
            
            mydata.above_thresh_starts = starts;
            mydata.above_thresh_ends = ends;
            
            %figure; plot(mydata.data); hold on;
            
            for s = 1:length(starts)
                startme = starts(s);
                endme = ends(s);
                mydata.data(startme:endme) = 0;
            end
            
            starts = round(starts-mybuffer);
            ends = round(ends+mybuffer);
            ends(ends > length(mydata.data)) = length(mydata.data);
            starts(starts < 1) = 1;
            
            
            for s = 1:length(starts)
                startme = starts(s);
                %bstart = startme-mybuffer;
                %if bstart < 1
                %    bstart = 1;
                %end
                
                endme = ends(s);
                %bend = endme+mybuffer
                %if bend > length(mydata.data)
                %    bend = length(mydata.data);
                %end
                try
                    mydata.data(startme:endme) = interp1([startme endme],[mydata.data(startme) mydata.data(endme)],startme:endme);
                    mydata.modified(startme:endme) = 1;
                catch err
                    disp(err)
                end
                %mydata.data(bstart:bend) = interp1([bstart:startme endme:bend]',[mydata.data(bstart:startme); mydata.data(endme:bend)],bstart:bend);
            end
            
            %plot(mydata.data,'g');
        end
        mydata.num_modified = sum(mydata.modified);
        %interpolate between the value of the start and end time
        
        a = find(mydata.data < -30000);
        [lo,hi]= findcontiguous(a);  %find contiguous NaNs
        for i = 1:length(lo)
            if lo(i) > 1 & hi(i) < length(mydata.data)
                fill = linspace(mydata.data(lo(i)-1), ...
                    mydata.data(hi(i)+1), hi(i)-lo(i)+1);
                mydata.data(lo(i):hi(i)) = fill;
            end
        end
        cleandata{day}{epoch}{tet} = mydata;
        

        % replace the filtered invalid entries with the minimum int16 value of
        % -32768
        for i = 1:length(lo)
            if lo(i) > 1 && hi(i) < length(cleandata{day}{epoch}{tet}.data)
                cleandata{day}{epoch}{tet}.data(lo(i):hi(i)) = minint;
            end
        end
        
        % save the resulting file
        outputfile = sprintf('%s%s%s%02d-%d-%02d.mat', ...
            directoryname, fileprefix, outstring,day, epoch, tet);
        name_variable(outstring,cleandata); %this allows the saved variable to have the filtername rather than just highgamma
        save(outputfile, outstring);
        %end
    end
end
