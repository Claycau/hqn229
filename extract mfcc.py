import os, re, sys, time, glob, datetime, sqlite3, random, math
import numpy as np
import gdata.youtube
import gdata.youtube.service
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

trackdata = defaultdict(list)
traindata = defaultdict(list)

track_ids = []
train_ids = []

results   = defaultdict(list)


# we define this very useful function to iterate the files
def apply_to_all_files(basedir,func=lambda x: x,ext='.h5'):
 
    cnt = 0
    # iterate over all files in all subdirectories
    for root, dirs, files in os.walk(basedir):
        files = glob.glob(os.path.join(root,'*'+ext))
        # count files
        cnt += len(files)
        # apply function to all files
        for f in files :
            #func(f)
            v = func(f)
            if v==[0,0]:
            	print 'fuck that again'
            else:
            	track_ids.append(v[0])
            	trackdata[v[0]] = v[1]
    return cnt

pullsize = 200
def apply_to_some_files(basedir,func=lambda x: x,ext='.h5'):
	cnt = 0
    # iterate over all files in all subdirectories
	c = 0
	while c<pullsize:
		for root, dirs, files in os.walk(basedir):
			files = glob.glob(os.path.join(root,'*'+ext))
			# count files
			cnt += len(files)
			# apply function to all files
			
			for f in files:
				c +=1
				if c>pullsize:
					break
				print c
				v = func(f)
				if v==[0,0]:
					print 'fuck that again'
				else:
					train_ids.append(v[0])
					traindata[v[0]] = v[1]
			if c>pullsize:
				break
	return cnt

# we can now easily count the number of files in the dataset
#print 'number of song files:',apply_to_all_files(msd_subset_data_path)


mfccs =  []
alphabet = map(chr, range(97, 123))
begin = 200
end = 400
dist = end-begin

# we define the function to apply to all files
def extract_data(filename):
    v = [0,0]
    h5 = GETTERS.open_h5_file_read(filename)
    
    #what data you want:
    track_id = GETTERS.get_song_id(h5)
    data = GETTERS.get_segments_pitches(h5)
    mfcc = np.zeros((12,dist))
    #print len(data)
    #print 'MFCC:'
    #print data[1,1]
    flag = 0
    for i in range(1):
    	try:
    		mfcc[i,:] = data[begin:end, i]
    	except ValueError:
    		flag = 1
    		
    if flag==0:
        v[0] = track_id
        v[1] = mfcc
    #track_ids.append(track_id)
    
    h5.close()
    return v

def generate_bins():
	bins = np.ones((12, 26), float)
	for h in range(1,12):
		for i in range(25):
			for j in range(20):
				reweight(bins, i, j, h)
	return bins

target = 1.0/26.0
total_chars = 1*dist*pullsize
def reweight(bins, letter, it, h):
	mfccs[:] = []
	generate_strings(bins, h, train_ids)
	count = count_occurences(letter, h)
	print count/total_chars
	bins[h][letter] = bins[h][letter] + math.copysign(1.0, -1*target+count/total_chars)*math.pow(2,(-1*(it+1)))
	print bins[h][letter]
	if it==0:
		print "Reweight done for " + str(letter)

def generate_strings_train(bins, h, ids):
	for id in ids:
		string = []
		mfcc = trackdata_track[id]
		for i in range(dist):
			string.append(assign_char(bins, mfcc[h,i], h))
		mfccs.append(string)
		
def generate_strings_output(bins, h, ids):
	for id in ids:
		string = []
		mfcc = trackdata[id]
		for i in range(dist):
			string.append(assign_char(bins, mfcc[h,i], h))
			#print string
		#mfccs.append(string)
		try:
			string =  ''.join(string)
			results[id] = string
		except TypeError:
			print string
	
def assign_char(bins,x,h):
	for i in range(len(alphabet)):
		if x>bins[h][i]: return alphabet[i]

def count_occurences(letter, h):
	count = 0.0
	#print 'COUNT BITCH'
	for mfcc in mfccs:
		count += mfcc.count(alphabet[letter])
	#print count
	return count


#already = []
#f = open('/Users/empty/Documents/hqn229/data.txt','r')
#for line in f:
#	track_id = re.search(r"^[A-Z0-9]+", line)
#	already.append(track_id.group(0))
#f.close()

# let's apply the previous function to all files 
# we'll also measure how long it takes
t1 = time.time()
apply_to_all_files(msd_subset_data_path,func=extract_data)
t2 = time.time()
print 'all artist names extracted in:',strtimedelta(t1,t2)

print "Now generating bins"
t1 = time.time()
bins = generate_bins()
bins[0] =[9.99999046e-01,   8.80000114e-01,   7.82000542e-01,   6.98000908e-01,
 	   6.23000145e-01,   5.54999352e-01,   4.94999886e-01,   4.41000938e-01,
  	  3.96000862e-01,   3.53999138e-01,   3.14000130e-01,   2.79000282e-01,
  	  2.44999886e-01,   2.13000298e-01,  1.85000420e-01,   1.58999443e-01,
  	  1.32000923e-01,   1.08000755e-01,   8.40005875e-02,   6.09998703e-02,
  	  3.90005112e-02,   1.29995346e-02,   9.53674316e-07,   9.53674316e-07,
  	  9.53674316e-07,   -1.00000000e+00]
t2 = time.time()
print 'Generated Bins in:',strtimedelta(t1,t2)

print "LET'S GO!"

for h in range(1,12):
	print "Now generating strings for bin "+ str(h) + "!"
	t1 = time.time()
	bins[h][25]= -1.000e+00
	
	print len(track_ids)
	generate_strings_output(bins, h, track_ids)
	t2 = time.time()
	print 'Generated Strings in:',strtimedelta(t1,t2)
	
	#Output the data:
	filename = '/Users/empty/Documents/hqn229/spectra_data' + str(h) + '.txt'
	f = open(filename,'a')
	for id,data in results.iteritems():
		
		#output the data you want: 
		line =  id + '|' + data + '\n' #+ key + '|' + data[0] + '|' + data[1] + '|' + data[2] + '\n'
		
		f.write(line)
	f.close()
print bins