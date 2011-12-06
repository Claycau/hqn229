% Build a list of all the files in the dataset
all_files = findAllFiles('files/millionsongs/MillionSongSubset/data/');
cnt = length(all_files);
%Cellfun version:
%all_artist_names = cellfun(@(f) [get_song_hotttnesss(HDF5_Song_File_Reader(f)), get_tempo(HDF5_Song_File_Reader(f)), get_danceability(HDF5_Song_File_Reader(f)), get_loudness(HDF5_Song_File_Reader(f)), get_segments_loudness_max(HDF5_Song_File_Reader(f))], all_files, 'UniformOutput', false);
%debug: cnt = 5;
%forloop version:
specavg = zeros(cnt,4*12);
S = cell(cnt,1);
for i=1:cnt
    h5 = HDF5_Song_File_Reader(all_files{i});
    c = h5.get_segments_pitches();
    c0 = round(size(c,2)/4);
    boom = [mean(c(:,1:c0)'), mean(c(:,c0+1:2*c0)'), mean(c(:,2*c0+1:3*c0)'), mean(c(:,3*c0+1:size(c,2))')];
    if size(boom,1)*size(boom,2)==4*12
        specavg(i,:) = reshape(boom,1,size(boom,1)*size(boom,2));
    else
        specavg(i,:) = zeros(1,4*12);
    end
    %Breaks song into quarters and takes spectral average for each chunk
    %then concatenates
    S{i} = get_song_id(h5);
    if mod(i,1000)==0
        i/10000
    end
end

F = zeros(10000,7);
a = data; %data and textdata are the imported youtube data
[as,asi] = sort(textdata(:,1)); %sorts YTdat by song_id
aa = specavg;
for i=1:cnt
    boo{i} = S{i};
end
'done with boo'
[aas,aasi] = sort(boo); %sorts specavgdat by song_id
'begin label and feature creation'
labels = zeros(cnt,1);
features = zeros(cnt,4*12);
for i=1:cnt %create sorted labels and features
    if a(asi(i),1)>10000 %if viewcount large
        labels(i) = 1; %then popular
    else
        labels(i) = -1; %not popular
    end
    features(i,:) = specavg(aasi(i),:);
end
'labels and features done'

dlmwrite('files/millionsongs/specAvgFeatures.txt',features);
dlmwrite('files/millionsongs/specAvgLabels10k.txt',labels);