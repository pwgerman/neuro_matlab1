%trigepochspec 
% trigepochspec averages z-scores of all tetrodes across an epoch to get
% average spectrogram. (It's better to use the reference tetrode instead). 
%
%   This version will find the mean spectrogram across all tetrodes for an
%   epoch.
%
% triggered spectrograms
% the base spectrograms analyzed are segmented into 50 msec bins. and .9 Hz
% frequency bins.  This script will index these bins by velocity or
% freezing and compare the frequency ranges of high and low theta.
% 

cd /mnt/data18/walter/phys/Spec;
load spectro-CA1-shock-ctrl-eli.mat;


g = 1; %group;
nume = size(f.output{g},2);
dim3 = zeros(nume, 1);
dim1 = zeros(nume, 1);
dim2 = zeros(nume, 1);
epd = zeros(nume, 1);
for e = 1:nume; %epoch within filter group
    
    index = f.output{g}(e).index;
    day = index(1);
    ep = index(2); % epoch within a day
    t = index(3); % tetrode lfp
    
    freq{day}{ep}{t} = f.output{g}(e).frequency;
    time{day}{ep}{t} = f.output{g}(e).time;
    spect{day}{ep}{t} = f.output{g}(e).fullspectrum;
    zspect{day}{ep}{t} = zscore(spect{day}{ep}{t}, 0,1); % what happens with change of dim?
    
    dim3(day) = dim3(day) + ~isempty(time{day}{ep}{t}); % number of tetrodes with lfp each day
    if t ~= 17;
        dim1(day) = size(time{day}{ep}{t},2); % kludge to make this work with last tetrode for Cummings day 3, epoch 3
    end
    dim2(day) = size(freq{day}{ep}{t},2);
    epd(day) = ep; % epoch within day;
end

numd = size(time,2);
for d = 1:numd
    %ezspect{d} = mean(reshape(cell2mat(zspect{d}{epd(d)}), dim1(d),dim2(d),dim3(d)),3);
    % the above line should work, but the last tetrode has a larger time
    % than the other tetrode cells, resulting in a crash for this
    % operation.  As a quick fix, I have removed the last tetrode from
    % the analysis below.
    ezspect{d} = mean(reshape(cell2mat(zspect{d}{epd(d)}(1:end-1)), dim1(d),dim2(d),dim3(d)-1),3);
end

animalname = f.animal{1};
animal = animaldef(animalname, 'outputstruct', 1);

estpos = loaddatastruct(animal.dir, animal.pre, 'estpos');
frztimes = estpos{index(1)}{index(2)}.data(:,10);
postimes = estpos{index(1)}{index(2)}.data(:,1);
vel = estpos{index(1)}{index(2)}.data(:,5);




% now break down by times in frequencis of interest
% theta1 = 7-9 Hz; theta2 = 4-6 Hz (sometimes reported as 4-7Hz type2)


