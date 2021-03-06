% Build a list of all the files in the dataset
all_files = findAllFiles('files/MillionSongSubset/data/');
cnt = length(all_files);
%Cellfun version:
%all_artist_names = cellfun(@(f) [get_song_hotttnesss(HDF5_Song_File_Reader(f)), get_tempo(HDF5_Song_File_Reader(f)), get_danceability(HDF5_Song_File_Reader(f)), get_loudness(HDF5_Song_File_Reader(f)), get_segments_loudness_max(HDF5_Song_File_Reader(f))], all_files, 'UniformOutput', false);

%forloop version:
datamat = zeros(cnt,4);
%datamat2 = zeros(cnt,144);
S = cell(cnt,1);
for i=1:cnt
    h5 = HDF5_Song_File_Reader(all_files{i});
    
    %For correlations:
    datamat(i,:) = [get_song_genre(h5)];
    S{i} = get_song_id(h5);
    
    %For svm, these have been saved in files/PCApitch and PCAtimbre
    %datamat(i,:) = reshape(princomp(get_segments_pitches(h5)'),144,1);
    %datamat2(i,:) = reshape(princomp(get_segments_timbre(h5)'),144,1);

    if mod(i,100)==0
        i/10000
    end
end

a = data; %data and textdata are the imported youtube data
[as,asi] = sort(textdata(:,1)); %sorts YTdat by song_id
aa = datamat;
for i=1:cnt
    boo{i} = S{i};
end
'done with boo'
[aas,aasi] = sort(boo); %sorts specavgdat by song_id
'begin label and feature creation'
labels = zeros(cnt,1);
features = zeros(cnt,4);
for i=1:cnt %create sorted labels and features
    if a(asi(i),1)>10000 %if viewcount large
        labels(i) = 1; %then popular
    else
        labels(i) = -1; %not popular
    end
    features(i,:) = datamat(aasi(i),:);
end
'labels and features done'

dlmwrite('files/millionsongs/hotetcFeatures.txt',features);
%dlmwrite('files/millionsongs/specAvgLabels10k.txt',labels);
