function [sampSS, fftSS, melSS] = selfSim(fullpath)
%Calculates the self-similarity matrices of a song for samples, fft, and
%mfccs and writes the data to a file
slashes     = strfind(fullpath, '/'); 
filename    = fullpath(slashes(size(slashes,2))+1:size(fullpath,2))
[d,sr]      = mp3read(strcat('files/',filename));
'file read success'
buffersize  = 4096; %let this be an argument, try for different values?
melweights  = fft2melmx(buffersize, 8000, 40, 1, 133.33, 6855.5, 0);
songmat     = vec2mat(d(:,1),buffersize);
songfft     = abs(fft(songmat));
songbuckets = melweights*songfft';
'calculating self-similarity matrices'
sampSS      = fliplr(songmat*songmat')';
fftSS       = fliplr(songfft*songfft')';
melSS       = fliplr(songbuckets'*songbuckets)';
%dlmwrite(strcat('files/data/', filename,'-mfccs.dat'), songbuckets');
%dlmwrite(strcat('files/data/', filename,'-pca.dat'), pcas);
'files written'