% Build a list of all the files in the dataset
all_files = findAllFiles('files/MillionSongSubset/data/');
cnt = length(all_files);
disp(['Number of h5 files found: ',num2str(cnt)]);

for i=1:1
    h5 = HDF5_Song_File_Reader(all_files{i});
    new = h5.get_segments_pitches()
    i
end
