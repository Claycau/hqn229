% Build a list of all the files in the dataset
all_files = findAllFiles('files/millionsongs/MillionSongSubset/data/');
cnt = length(all_files);
disp(['Number of h5 files found: ',num2str(cnt)]);

% Get info from the first file using our wrapper
h5 = HDF5_Song_File_Reader(all_files{1});
disp(['artist name is: ',h5.get_artist_name()]);
disp([' song title is: ',h5.get_title()]);