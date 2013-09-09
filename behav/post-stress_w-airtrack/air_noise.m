


wav03 = wavread('/home/walter/src/matlab/airtrack_wav/11-03-25-13-03-34.wav');
spectrogram(wav03);

[S,F,T,P] = spectrogram(wav03);
surf(T,F,10*log10(abs(P)));
axis tight;
view(0,90);
spectrogram(X,256,250,256,1E3);
??? Undefined function or variable 'X'.
 
spectrogram(wav03,256,250,256,1E3);
figure
spectrogram(wav03,131077,120000,131077,1E3);


[m d] = wavfinfo('/home/walter/src/matlab/airtrack_wav/11-03-25-13-03-34.wav');

sound(wav03,16000,16);

figure;

plot(wav03(:));

% export PSD analysis from Audacity to .txt
data=dlmread('/home/walter/src/matlab/airtrack_wav/44khzSpectrum.txt', '\t', 1, 0);
plot(data(:,1),data(:,2));

wavwrite()


%
% create arbitrarily long version of noise file from a shorter one
%


% signal of interest is wavX
wavX = wav4;
MaxSegSize = 0.1*length(wavX);
%wavX(:,2) = zeros(length(wavX));
NumSegs = 30;
wavNew = [];

for seg = 1:NumSegs;
SegSize = int8(rand(1)*MaxSegSize);
startSeg = int8(rand(1)*(length(wavX))-(SegSize)); % start with enough room to not overrun matrix
wavNew = [wavNew; wavX(startSeg:startSeg+SegSize)];
end


Hs=spectrum.welch;
Fs = 44000;
figure
psd(Hs, wavNew, 'Fs', Fs);

sound(wavNew,44200, 16);