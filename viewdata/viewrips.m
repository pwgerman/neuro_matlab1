% vieweeg
animal = animaldef('Bukowski', 'outputstruct', 1);
ind = [3 5 1]; % third value is changed to tetrode with max cells

% find best tetrode
task = loaddatastruct(animal.dir, animal.pre, 'task');
cellinfo = loaddatastruct(animal.dir, animal.pre, 'cellinfo');
riptetfilter =  '(isequal($area, ''CA1'')) '; % riptetfilter is an arg for getripactivprob call to gettetmaxcell
tet = gettetmaxcell(cellinfo, task, ind(1), riptetfilter, 1); %1,2,3=all,run,sleep
ind(3) = tet;

% load ripple eeg info from one tetrode
eeg = loadeegstruct(animal.dir, animal.pre, 'eeg', ind(1), ind(2), ind(3));
rip = loadeegstruct(animal.dir, animal.pre, 'ripple', ind(1), ind(2), ind(3));
ripples = loaddatastruct(animal.dir, animal.pre, 'ripples');

% plot each ripple
maxrip = size(ripples{ind(1)}{ind(2)}{ind(3)}.starttime, 1);
for ripnum = 1:maxrip
    if ripples{ind(1)}{ind(2)}{ind(3)}.maxthresh(ripnum)>4
        startind = ripples{ind(1)}{ind(2)}{ind(3)}.startind(ripnum);
        starttime = ripples{ind(1)}{ind(2)}{ind(3)}.starttime(ripnum);
        endtime = ripples{ind(1)}{ind(2)}{ind(3)}.endtime(ripnum);
        
        
        startbuf = .2;
        endbuf = .2;
        starttime = starttime - startbuf;
        endtime = endtime + endbuf;
        if starttime > ripples{ind(1)}{ind(2)}{ind(3)}.timerange(1)
            %{
        if starttime - startbuf > ripples{ind(1)}{ind(2)}{ind(3)}.timerange(1)
            starttime = starttime - startbuf;
            endtime = starttime + startbuf + endbuf;
        else % too close to beginning of dataset
            endtime = starttime + endbuf;
        end
            %}
            endind = startind + 600;
            samprate = 1500;
            
            %values = eegvalues(eeg, ind, [starttime endtime]);
            values = eegvalues(rip, ind, [starttime endtime]);
            tmprip = rip{ind(1)}{ind(2)}{ind(3)}.data(startind:endind);
            
            times = starttime:(1/samprate):endtime;
            cutoff = min(length(times), length(values));
            times = times(1:cutoff);
            values = values(1:cutoff);
            %plot(times, values)
            plot(values)
            %plot(tmprip) % simpler code doesn't require eegvalues()
            %xlim([starttime endtime]);
            %xlim([0 600]);
            equalylim = max(abs(get(gca, 'ylim')));
            ylim([-120 120]); %ylim([-equalylim equalylim]);
            xlim([0 800]);
            title(['tet:', num2str(tet), '  ', num2str(ripnum), ' / ', num2str(maxrip)]);
            pause(.15); %keyboard; %pause(.5);
        end
    end
end