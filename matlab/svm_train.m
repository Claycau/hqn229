addpath('libs/liblinear-1.8/matlab');  % add LIBLINEAR to the path

YTDataNS = dlmread('files/millionsongs/YTSortedLabels100k.txt');
specDatNS = dlmread('files/millionsongs/hotetcFeatures.txt');
'files read in'
trainCategory = sparse(YTDataNS(1:7000));
avgSpec = sparse(specDatNS(1:7000,:));
'going to train...'
model = train(trainCategory, avgSpec);