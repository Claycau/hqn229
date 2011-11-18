% Build a list of all the files in the dataset
all_files = findAllFiles('files/millionsongs/MillionSongSubset/data/');
cnt = length(all_files);
disp(['Number of h5 files found: ',num2str(cnt)]);

for i=1:100
    h5 = HDF5_Song_File_Reader(all_files{i});
    disp(['artist name is: ',h5.get_artist_name()]);
    i
end
