% vieweeg_movie
animal = animaldef('bukowski', 'outputstruct', 1)
loadeegstruct(animal.dir, animal.pre, 'eeg', 1,2,6)
eeg = loadeegstruct(animal.dir, animal.pre, 'eeg', 1,2,6)

for jj = 1:200:length(eeg{1}{2}{6}.data)
plot(eeg{1}{2}{6}.data(jj:jj+1000))
ylim([-400 400])
pause(.1)
end

