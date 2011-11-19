addpath('libs/liblinear-1.8/matlab');  % add LIBLINEAR to the path

yearData = importdata('files/millionsongs/YearPredictionMSD.txt');
'file read in'
trainCategoryNS = 2*(yearData(1:463715,1)>2000)-1; %Training for year after 2000
trainCategory = sparse(trainCategoryNS);
avgTimbres = sparse(yearData(1:463715,2:13));
'going to train...'
model = train(trainCategory, avgTimbres);