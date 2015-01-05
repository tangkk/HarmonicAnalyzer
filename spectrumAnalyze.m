function spectrumAnalyze(file)

root = 'd:\Documents\REAPER Media';
path = [root '\' file];

display(path);

[song,fs] = audioread(path);
song = toMono(song);

songLength = length(song);
NFFT = 2^nextpow2(songLength);
fftSong = fft(song,NFFT);
f = fs/2*linspace(0,1,NFFT/2+1);

% "The signal is real-valued and has even length.
% Because the signal is real-valued, you only need power estimates for the
% positive or negative frequencies. In order to conserve the total power,
% multiply all frequencies that occur in both sets ? the positive and
% negative frequencies ? by a factor of 2. Zero frequency (DC) and
% the Nyquist frequency do not occur twice."

fftAmpSpec = abs(fftSong(1:NFFT/2+1))/songLength;
fftAmpSpec(2:end-1) = 2*fftAmpSpec(2:end-1);
fftAmpSpec = normalize(fftAmpSpec);
fftAmpSpec = noisegate(fftAmpSpec, 0);

[pks,locs] = findpeaks(fftAmpSpec,f,'MinPeakHeight', 0.04, 'MinPeakDistance', 30);
pitchPeaks = freq2pitchclass(locs);
for i = 1:1:length(pitchPeaks)
    display([pitch2name(pitchPeaks(i)) ' ' num2str(locs(i)) ' ' num2str(locs(i)/locs(1))]);
end

myPlot(f, fftAmpSpec);
