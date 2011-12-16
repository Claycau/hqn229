% Try out the Naive Bayes method on binary data derived from the Golub, et al
% data set.

trnx = load('genetrainx.dat');
tstx = load('genetestx.dat');
trny = load('genetrainy.dat');
tsty = load('genetesty.dat');

pred = nbayes (1, trnx, trny, tstx)

[ pred', tsty ]
