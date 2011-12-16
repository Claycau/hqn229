% Build a list of all the files in the dataset
all_files = findAllFiles('files/millionsongs/MillionSongSubset/data/');
cnt = length(all_files);
%Cellfun version:
%all_artist_names = cellfun(@(f) [get_song_hotttnesss(HDF5_Song_File_Reader(f)), get_tempo(HDF5_Song_File_Reader(f)), get_danceability(HDF5_Song_File_Reader(f)), get_loudness(HDF5_Song_File_Reader(f)), get_segments_loudness_max(HDF5_Song_File_Reader(f))], all_files, 'UniformOutput', false);
%debug: cnt = 5;
%forloop version:
dim = 8;
specavg = zeros(cnt,dim);
S = cell(cnt,1);
for i=1:cnt
    h5 = HDF5_Song_File_Reader(all_files{i});
    %a = h5.get_artist_terms();
    %a{1}
    %{
    c = h5.get_segments_timbre();
    c0 = round(size(c,2)/dim);
    if size(c,2)>2*dim
        for k=1:dim-1
            boom(k,:) = mean(c(:,1+(k-1)*c0:k*c0)');
        end
        boom(dim,:) = mean(c(:,(dim-1)*c0+1:size(c,2))');
        if size(boom,1)*size(boom,2)==dim*12
            specavg(i,:) = reshape(boom,1,size(boom,1)*size(boom,2));
        else
            specavg(i,:) = zeros(1,dim*12);
        end
    else
         specavg(i,:) = zeros(1,dim*12);
    end
    %Breaks song into quarters and takes spectral average for each chunk
    %then concatenates
    %}
    a = h5.get_sections_start();
    if size(a,1)>1
        a=a(2);
    else
        a=0;
    end
    specavg(i,:) = [h5.get_tempo(), h5.get_time_signature(), h5.get_energy(), h5.get_loudness(), h5.get_duration(), size(h5.get_sections_start(),1), a, h5.get_key()];
    S{i} = get_song_id(h5);
    if mod(i,100)==0
        i/10000
    end
end

%F = zeros(10000,7);
a = data; %data and textdata are the imported youtube data
[as,asi] = sort(textdata(:,1)); %sorts YTdat by song_id
%aa = specavg;
for i=1:cnt
    boo{i} = S{i};
end
'done with boo'
[aas,aasi] = sort(boo); %sorts specavgdat by song_id
'begin label and feature creation'
labels = zeros(cnt,1);
features = zeros(cnt,dim);
for i=1:cnt %create sorted labels and features
    if a(asi(i),1)>10000 %if viewcount large
        labels(i) = 1; %then popular
    else
        labels(i) = -1; %not popular
    end
    features(i,:) = specavg(aasi(i),:);
end
'labels and features done'

dlmwrite('files/millionsongs/KEYEtcFeatures.txt',features);
%dlmwrite('files/millionsongs/specAvgLabels10k.txt',labels);