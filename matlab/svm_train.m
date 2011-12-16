addpath('libs/liblinear-1.8/matlab');  % add LIBLINEAR to the path

YTDataNS = dlmread('files/millionsongs/YTSortedLabels10k.txt');
specDatNS = dlmread('files/millionsongs/specAvg2ves.txt');
specDatNS = zscore(specDatNS);
'files read in'
trainCategory = sparse(YTDataNS(1:7000));
avgSpec = sparse(specDatNS(1:7000,:));
'going to train...'
model = train(trainCategory, avgSpec, '-v 10');


testCategory = sparse(YTDataNS(7001:10000));
avgSpec = sparse(specDatNS(7001:10000,:));

numTestDocs = size(YTDataNS,1)-7000;
output = zeros(numTestDocs, 1);
'going to predict...'
[output, accuracy] = predict(testCategory, avgSpec, model);


% Compute the error on the test set
error=0;
for i=1:numTestDocs
  if (testCategory(i) ~= output(i))
    error=error+1;
  end
end

%Print out the classification error on the test set
error/numTestDocs

[output, accuracy] = predict(sparse(YTDataNS(1:7000)), sparse(specDatNS(1:7000,:)), model);


% Compute the error on the test set
error=0;
for i=1:7000
  if (trainCategory(i) ~= output(i))
    error=error+1;
  end
end

%Print out the classification error on the test set
error/7000

for c=1:1
    couner = 1;
    for i=1:10000
        if idx(i)==c
            newtrain(couner,:) = specDatNS(i,:);
            newlab(couner) = YTDataNS(i);
            couner = couner+1;
        end
    end
    trainCategory = sparse(newlab(1:round(.7*size(newlab,1))));
    trainset = sparse(newtrain(1:round(.7*size(newtrain,1)), :));
    model = train(trainCategory, trainset);
    testCategory = sparse(newlab(round(.7*size(newlab,1)):size(newlab,1)));
    trainset = sparse(newtrain(round(.7*size(newtrain,1)):size(newtrain,1), :));
    [output, accuracy] = predict(testCategory, trainset, model);
end

% Compute the error on the test set
error=0;
for i=1:numTestDocs
  if (testCategory(i) ~= output(i))
    error=error+1;
  end
end

%Print out the classification error on the test set
error/numTestDocs

[output, accuracy] = predict(sparse(YTDataNS(1:7000)), sparse(specDatNS(1:7000,:)), model);
