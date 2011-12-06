intervals = [1000,10000,20000,50000,100000,300000,500000,700000,1000000];
counts = zeros(9,1);
labels = zeros(10000,1);
for j=1:9
    for i=1:cnt %create sorted labels and features
        if a(asi(i),1)>intervals(j) %if viewcount large
            labels(i) = 1; %then popular
        else
            labels(i) = 0; %not popular
        end
    end
    counts(j) = nnz(labels);
end