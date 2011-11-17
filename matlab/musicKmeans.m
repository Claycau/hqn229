function [clusters, repsong, symbsong] = musicKmeans(filename, targetname, nClusters, buffersize, iterations)
%Calculates clusters for a given song by raw waveform similarity (could do
%by fft if wanted)
[song,sr]   = mp3read(strcat('files/',filename));
'song read in'
clusters    = zeros(nClusters, buffersize);
A           = vec2mat(song(:,1),buffersize);
%'fft computed'
for i=1:nClusters
    clusters(i,:) = A(round(random('unif',1,size(A,1))),:);
end
B = zeros(size(A,1),size(A,2));
B2 = zeros(nClusters,size(A,1));
for i=1:iterations
    if mod(i,1000)==0
        i/1000
    end
    for j=1:nClusters
        B = bsxfun(@minus,A,clusters(j,:));
        B2(j,:) = (sum((B.*B)')./sum((A.*A)'))/(clusters(j,:)*clusters(j,:)');
    end
    [V,I] = min(B2); %I is the indices of the closest cluster to each pixel
    for j=1:nClusters
        I2 = find(I==j);
        numerator = zeros(1,size(A,2));
        for k=1:size(I2,2) %There has to be a more efficient way to do this
            numerator = numerator + A(I2(1,k),:);
        end
        denominator = size(I2,2);
        clusters(j,:) = numerator/denominator;
    end
end
'clusters found'

for j=1:nClusters
    B = bsxfun(@minus,A,clusters(j,:));
    B2(j,:) = sum((B.*B)');
end
[V,I] = min(B2); B3 = zeros(size(A,1),size(A,2));
symbsong = I;
'indices found'
for j=1:size(A,1)
    B3(j,:) = clusters(I(1,j),:);
end
repsong     = reshape(B3,size(B3,1)*size(B3,2),1);
mp3write(repsong,sr,16,targetname);

