% runspectrogram

% set parameters
hammingwin = 256; %128; What makes a good hamming window?
noverlap = 10;%120;  % must be less than hammingwin
nfft = 256; %128; % ? nfft is the FFT length and is the maximum of 256 or ...

% load eeg data
animal = animaldef('Eliot', 'outputstruct', 1);
tet = 10;
eeg = loadeegstruct(animal.dir, animal.pre, 'eeg', 4, 3, tet);
lfp = eeg{4}{3}{tet}.data;
sampfreq = eeg{4}{3}{10}.samprate;

% graph
spectrogram(lfp, hammingwin, noverlap, nfft, sampfreq);
xlim([0 250]);

% scripts used in mcarr/worksinprogress
%loadriptriggeredcoherence
%loadriptriggeredspectrum

% search for spectrograms in code:
%find mcarr/ -name '*.m' -exec grep -iHn spectrogram {} \; | less
