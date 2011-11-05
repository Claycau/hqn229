%Testing out mfccs%
[d,sr]      = mp3read('files/RoboBooty.mp3');
'file read success'
% for beats: [b,onsetenv,D,cumscore] = beat(d(:,1),sr);

%Slaney: fft2melmx(512, 8000, 40, 1, 133.33, 6855.5, 0);
melbuffer   = 512;
melweights  = fft2melmx(melbuffer, 8000, 40, 1, 133.33, 6855.5, 0);
songfft     = abs(fft(vec2mat(d(:,1),melbuffer)));
songbuckets = melweights*songfft';
'mel buckets calculated'
pcas        = princomp(songbuckets');
'princomps done'