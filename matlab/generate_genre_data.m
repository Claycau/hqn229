

addpath('libs/liblinear-1.8/matlab'); 

%read in data
Data = textscan(fopen('files/msd_genre_dataset.txt'), '%s %s %s %s %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d');
SongCellData = cell(59600, 4);
for i = 1:4
    for j = 1:59600
        SongCellData{j, i} = Data{1,i}{j};
    end
end
genres = Data{1,1};
[unique_genres something genre_labels] = unique(genres);
MatData = zeros(59600, 30);

for i = 1:30
    MatData(:, i) = Data{1,i+4};
end
featuresandlabels = zeros(59600, 31);
featuresandlabels(:, 1:30) = MatData;
featuresandlabels(:, 31)   = genre_labels;

%randomize the order of songs--currently org. by genre
featuresandlabels = featuresandlabels(randperm(size(featuresandlabels,1)),:);
data = featuresandlabels(:, 1:30);
genre_labels = featuresandlabels(:, 31);




%test on a uniform dataset

min_number = nnz(genre_labels==5);
newfl = zeros(size(unique_genres,1)*min_number, 30);
newgl = zeros(size(unique_genres,1)*min_number,1);
so_far = zeros(size(unique_genres,1),1);
k = 1;
j = 1;
while sum(so_far)<min_number*size(unique_genres,1)
    label = genre_labels(k);
    if(so_far(label)<min_number)
        newgl(j)=label;
        newfl(j,:)=data(k,:);
        j = j+1;
        so_far(label) = so_far(label)+1;
    end
    k = k+1;
end
data = newfl;
genre_labels = newgl;

data = zscore(data);
randomforest = TreeBagger(500 ,data, genre_labels, 'OOBPred', 'on')
plot(oobError(randomforest))
xlabel('Trees Grown')
ylabel('out-of-bag classification error')

%{  
train_size = round(min_number*.7);
test_size  = size(genre_labels,1) - train_size;
train_labels  = genre_labels(1:train_size);
test_labels   = genre_labels(train_size:size(genre_labels,1));
train_data    = data(1:train_size,:);
test_data     = data(train_size:size(genre_labels,1),:);


%test one genre against another -run this all in a for loop, m, then n
data = featuresandlabels(:, 1:30);
genre_labels = featuresandlabels(:, 31);
label1 = m;
label2 = n; 
min_number = min(nnz(genre_labels==label1), nnz(genre_labels==label2));
newfl = zeros(2*min_number, 30);
newgl = zeros(2*min_number,1);
so_far = zeros(2,1);
k = 1;
j = 1;
while sum(so_far)<min_number*2
    label = genre_labels(k);
    if label == label1
        index = 1;
    else
        index = 2;
    end
    if(so_far(index)<min_number) && (label == label1 || label == label2)
        newgl(j)=label;
        newfl(j,:)=data(k,:);
        j = j+1;
        so_far(index) = so_far(index)+1;
    end
    k = k+1;
end
data = newfl;
lone = 1*(newgl ==label1);
ltwo = -1*(newgl ==label2);
genre_labels = lone+ltwo;

data = zscore(data);

train_size = round(min_number*.7);
test_size  = size(genre_labels,1) - train_size;
train_labels  = genre_labels(1:train_size);
test_labels   = genre_labels(train_size:size(genre_labels,1));
train_data    = data(1:train_size,:);
test_data     = data(train_size:size(genre_labels,1),:);
%}

%{
%normalize: 
data = zscore(data);


train_labels  = genre_labels(1:50000);
test_labels   = genre_labels(50001:59600);
train_data    = data(1:50000,:);
test_data     = data(50001:59600,:);

sparse_data = sparse(data);
sparse_labels = sparse(genre_labels);
sparse_train_labels = sparse(train_labels);
sparse_test_data    = sparse(test_data);
sparse_test_labels  = sparse(test_labels);
sparse_train_data   = sparse(train_data);

%SVM
%svm = train(sparse_labels, sparse_data,'-s 4 -v 5 -q');
%[predicted_label, accuracy] = predict(sparse_test_labels, sparse_test_data, svm);
%A(m,n) = accuracy;



%k-means
%clusters = [3 4 5 6 7 8 9];
%data = balance(data)
clusters = [4];
for j = 1:size(clusters,2)
    num_clusters = clusters(j);
    idx = kmeans(data, num_clusters, 'MaxIter',1000);
    class_vs_cluster = zeros(size(unique_genres,1),num_clusters);
    for i = 1:size(genre_labels,1)
        class_vs_cluster(genre_labels(i),idx(i)) = class_vs_cluster(genre_labels(i),idx(i)) +1;
    end
    k_prob = diag(1./sum(class_vs_cluster,2))*class_vs_cluster;
    k_prob = k_prob*100;

    accuracies = zeros(num_clusters,1);
    for i=1:num_clusters
        clusteri_data = data(find(idx==i),:);
        clusteri_labels = genre_labels(find(idx==i));
        sparsed2 = sparse(clusteri_data);
        sparsel2 = sparse(clusteri_labels);
        bestcv = 0;
        for log2c = 0:0,
          for log2e = -10:0,
            cmd = ['-v 5 -s 4 -q -c 8 -e ' num2str(2^log2e)];
            cv = train(sparsel2, sparsed2, cmd);
            if (cv >= bestcv),
              bestcv = cv; %bestc = 2^log2c; beste = 2^log2e;
            end
          end
        end

        accuracies(i) = bestcv%train(sparsel2, sparsed2,'-s 4 -c 8 -e .125 -v 10 -q');
        results(j, i) = accuracies(i);
    end
    averages(j) = sum(accuracies)/num_clusters
end

%}


%knn-classify
%class = knnclassify(test_data, train_data, train_labels, 10);
%knn_accuracy = 100 - (nnz(class-test_labels)/test_size*100)