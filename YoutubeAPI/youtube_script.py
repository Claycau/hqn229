import os, re, sys, time, glob, datetime, sqlite3
import numpy as np
import gdata.youtube
import gdata.youtube.service
from getytkeys import getYTKeys
from collections import defaultdict

msd_subset_path= '/Users/empty/Documents/hqn229/matlab/files/MillionSongSubset'
msd_subset_data_path=os.path.join(msd_subset_path,'data')
msd_subset_addf_path=os.path.join(msd_subset_path,'AdditionalFiles')
assert os.path.isdir(msd_subset_path),'wrong path' # sanity check
msd_code_path='/Users/empty/Documents/hqn229/MSongsDB'
assert os.path.isdir(msd_code_path),'wrong path' # sanity check
sys.path.append( os.path.join(msd_code_path,'PythonSrc') )

# imports specific to the MSD
import hdf5_getters as GETTERS

# the following function simply gives us a nice string for
# a time lag in seconds
def strtimedelta(starttime,stoptime):
    return str(datetime.timedelta(seconds=stoptime-starttime))


def PrintVideoFeed(feed):
  for entry in feed.entry[:2]:
    PrintEntryDetails(entry)

def GetYTData(key):
	yt_service = gdata.youtube.service.YouTubeService()
	try:
		entry = yt_service.GetYouTubeVideoEntry(video_id=key)
	except gdata.service.RequestError:
		print key
		return['0','0','0']
	
	view_count = '0' 
	avg_rating = '0'
	n_raters = '0'
	try:
		view_count = entry.statistics.view_count
		avg_rating = entry.rating.average
		n_raters = entry.rating.num_raters
	except AttributeError:
		pass
	
	return [view_count, avg_rating, n_raters]
	
# we define this very useful function to iterate the files
def apply_to_all_files(basedir,func=lambda x: x,ext='.h5'):
    """
    From a base directory, go through all subdirectories,
    find all files with the given extension, apply the
    given function 'func' to all of them.
    If no 'func' is passed, we do nothing except counting.
    INPUT
       basedir  - base directory of the dataset
       func     - function to apply to all filenames
       ext      - extension, .h5 by default
    RETURN
       number of files
    """
    cnt = 0
    # iterate over all files in all subdirectories
    for root, dirs, files in os.walk(basedir):
        files = glob.glob(os.path.join(root,'*'+ext))
        # count files
        cnt += len(files)
        # apply function to all files
        for f in files :
            func(f)     
    return cnt

# we can now easily count the number of files in the dataset
print 'number of song files:',apply_to_all_files(msd_subset_data_path)


songdata = defaultdict(list)
already = []

# we define the function to apply to all files
def func_to_get_artist_name(filename):
    h5 = GETTERS.open_h5_file_read(filename)
    
    track_id = GETTERS.get_song_id(h5)
    if track_id in already:
    	h5.close()
    	return
    songdata[track_id].append(GETTERS.get_title(h5))
    songdata[track_id].append(GETTERS.get_artist_name(h5))
    songdata[track_id].append(GETTERS.get_duration)
    
    h5.close()
    
# let's apply the previous function to all files
# we'll also measure how long it takes
f = open('/Users/empty/Documents/hqn229/data.txt','r')

for line in f:
	track_id = re.search(r"^[A-Z0-9]+", line)
	already.append(track_id.group(0))
f.close()

f = open('/Users/empty/Documents/hqn229/data.txt','a')
print len(already)
t1 = time.time()
apply_to_all_files(msd_subset_data_path,func=func_to_get_artist_name)
t2 = time.time()
print 'all artist names extracted in:',strtimedelta(t1,t2)

for id,data in songdata.iteritems():
	query = data[0].split()
	query.extend(data[1].split())
	key = getYTKeys(query)
	ytdata = GetYTData(key)
	line =  id + '|' + key + '|' + ytdata[0] + '|' + ytdata[1] + '|' + ytdata[2] + '\n'
	f.write(line)
f.close()


