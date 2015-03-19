% script for extractripples
% run after rippledayprocess to find ripple event times and parameters from
% ripple band eeg data.
%
% NOTE: The versions of the data that has not had the high amplitude noise
% filtered is in other file locations.  The high amp filtered eeg is in
% *eegthresh* files.  The high amp filtered ripple lfp is with the same
% names but in the directory EEG_ripple_no_remove_high_amp.  And the
% ripples times files are also with the same name, but in the
% 'ripples_no_remove_high_amp' directory.

tetrodes = -1; % specify all tetrodes with -1
mindur = 0.015; % 15 ms minimum duration
nstd = 2; % 2 std

days = 1; %1:5;

for an = [{'Eliot'} {'Jigsaw'}];
    %animal = animaldef('Bukowski', 'outputstruct', 1);
    animal = animaldef(an{1}, 'outputstruct', 1);
    %animal = animaldef('Dickinson', 'outputstruct', 1);
    %animal = animaldef('Eliot', 'outputstruct', 1);
    
    
    %remove_high_amplitude_raw(animal.eegdir,animal.pre, days, 'eeg','eegthresh',1500, 'daytetlist', [1 6]); % check days and options indices
    remove_high_amplitude_raw(animal.eegdir,animal.pre, days, 'eeg','eegthresh',1500); % check days and options indices
    %remove_high_amplitude_raw(animal.eegdir,animal.pre, days, 'eeg','eegthresh',1500, 'daytetlist', [2 18]); % debug save error
    
    
    rippledayprocess(animal.dir, animal.pre, days, 'instring', 'eegthresh'); % varargin= 'daytetlist', [day tet ; day tet ...]
    
    for daynum = days
        extractripples(animal.dir, animal.pre, daynum, tetrodes, mindur, nstd);
    end
end


