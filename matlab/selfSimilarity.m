%Self-similarity matrix test
song        = mp3read('files/RoboBooty.mp3');
200
song        = song(:,1);
buffersize  = 2^10*2^4;
transform   = vec2mat(song,buffersize);
transform   = real(fft(transform));
n           = sqrt(sum(transform.^2,2));
n           = n(:,ones(1,size(transform,2)));
normalized  = transform./n;
simMat      = normalized*normalized';%/(buffersize^2);
simMat      = fliplr(simMat)';