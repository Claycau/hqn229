% NAIVE BAYES FOR BINARY DATA.  The first argument is the extra amount to add 
% to the counts when estimating probabilities.  The remaining arguments are
% the training inputs (a matrix with rows for different cases), the training 
% targets (a vector), and the test inputs (a matrix with rows for different 
% test cases).  The result is a vector containing the probabilities of class 1 
% for each test case.

function pred = nbayes (alpha, x_train, y_train, x_test)

  [ n, p ] = size(x_train);
  [ ntst, ptst ] = size(x_test);

  ypr1 = mean(y_train);

  xpr1 = (alpha + sum(x_train(y_train==1,:))) / (2*alpha + sum(y_train==1))
  xpr0 = (alpha + sum(x_train(y_train==0,:))) / (2*alpha + sum(y_train==0))

  pred = zeros(1,ntst);

  for i = 1:ntst
    log_ratio = log (ypr1/(1-ypr1));
    for j = 1:p
      if (x_test(i,j)==1)
        log_ratio = log_ratio + log (xpr1(j)/xpr0(j));
      else
        log_ratio = log_ratio + log ((1-xpr1(j))/(1-xpr0(j)));
      end
    end
    pred(i) = 1 / (1 + exp(-log_ratio));
  end
