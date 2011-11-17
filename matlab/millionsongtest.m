% Build a list of all the files in the dataset
all_files = findAllFiles('files/millionsongs/MillionSongSubset/data/');
cnt = length(all_files);
disp(['Number of h5 files found: ',num2str(cnt)]);

% Get info from the first file using our wrapper
%{
h5 = HDF5_Song_File_Reader(all_files{1});
disp(['artist name is: ',h5.get_artist_name()]);
disp([' song title is: ',h5.get_title()]);
%}
for i=1:1000
    h5 = HDF5_Song_File_Reader(all_files{i});
    y = h5.get_year();
    if y>0
        N(i,1) = h5.get_year();
        N(i,2) = h5.get_tempo();
    end
    if mod(i,100)==0
        i
    end
end