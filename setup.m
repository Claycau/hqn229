%setup msdb
addpath('files/mksqlite');
global MillionSong MSDsubset
MillionSong ='files/MillionSongSubset'

msd_data_path=[MillionSong,'/data'];
msd_addf_path=[MillionSong,'/AdditionalFiles'];
MSDsubset='subset_';
msd_addf_prefix=[msd_addf_path,'/',MSDsubset];
assert(exist(msd_data_path,'dir')==7,['msd_data_path ',msd_data_path,' is not found.']);

% path to the Million Song Dataset code
msd_code_path='libs/MSongsDB';
assert(exist(msd_code_path,'dir')==7,['msd_code_path ',msd_code_path,' is wrong.']);
% add to the path