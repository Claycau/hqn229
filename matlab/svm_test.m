addpath('libs/liblinear-1.8/matlab');  % add LIBLINEAR to the path

%yearData = importdata('files/millionsongs/YearPredictionMSD.txt');
%'file read in'
testCategoryNS = 2*(yearData(463716:size(yearData,1),1)>2000)-1; %Training for year after 2000
testCategory = sparse(testCategoryNS);
avgTimbres = sparse(yearData(463716:size(yearData,1),2:13));

numTestDocs = size(yearData,1)-463716;
output = zeros(numTestDocs, 1);
'going to predict...'
[output, accuracy] = predict(testCategory, avgTimbres, model);


% Compute the error on the test set
error=0;
for i=1:numTestDocs
  if (testCategory(i) ~= output(i))
    error=error+1;
  end
end

%Print out the classification error on the test set
error/numTestDocs
