function [] = pcaWrite(fullpath)
%Calculates the principle components of the MFCCs of song given by filename
%and writes them to the file filename-pca.dat
slashes     = strfind(fullpath, '/'); 
filename    = fullpath(slashes(size(slashes,2))+1:size(fullpath,2))
[d,sr]      = mp3read(strcat('files/',filename));
'file read success'
melbuffer   = 512; %let this be an argument, try for different values?
melweights  = fft2melmx(melbuffer, 8000, 40, 1, 133.33, 6855.5, 0);
songfft     = abs(fft(vec2mat(d(:,1),melbuffer)));
songbuckets = melweights*songfft';
'mel buckets calculated'
pcas        = princomp(songbuckets');
'princomps done'
dlmwrite(strcat('files/data/', filename,'-mfccs.dat'), songbuckets');
dlmwrite(strcat('files/data/', filename,'-pca.dat'), pcas);
'files written'