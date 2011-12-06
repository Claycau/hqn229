addpath('libs/liblinear-1.8/matlab');  % add LIBLINEAR to the path

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
