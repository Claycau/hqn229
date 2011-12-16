YTData = dlmread('files/millionsongs/YTSortedLabels100k.txt');
specDat = dlmread('files/millionsongs/zscoreSpecAvg4th.txt');

km = kmeans(specDat, 5);
hists = zeros(5,2);

for i=1:10000
    kk = km(i);
    if YTData(i)>0
        hists(kk,1) = hists(kk,1)+1;
    else
        hists(kk,2) = hists(kk,2)+1;
    end
end