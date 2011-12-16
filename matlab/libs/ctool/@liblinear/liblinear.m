function model = liblinear(varargin)
%%
%%
%%
%%  Joerg D. Wichard  2009
%%
%%  FMP-Berlin
  
% Usage
% =====
% 
% matlab> model = train(training_label_vector, training_instance_matrix [,'liblinear_options', 'col']);
% 
%         -training_label_vector:
%             An m by 1 vector of training labels. (type must be double)
%         -training_instance_matrix:
%             An m by n matrix of m training instances with n features.
%             It must be a sparse matrix. (type must be double)
%         -liblinear_options:
%             A string of training options in the same format as that of LIBLINEAR.
%         -col:
%             if 'col' is set, each column of training_instance_matrix is a data instance. Otherwise each row is a data instance.
% 
% matlab> [predicted_label, accuracy, decision_values/prob_estimates] = predict(testing_label_vector, testing_instance_matrix, model [, 'liblinear_options', 'col']);
% 
%         -testing_label_vector:
%             An m by 1 vector of prediction labels. If labels of test
%             data are unknown, simply use any random values. (type must be double)
%         -testing_instance_matrix:
%             An m by n matrix of m testing instances with n features.
%             It must be a sparse matrix. (type must be double)
%         -model:
%             The output of train.
%         -liblinear_options:
%             A string of testing options in the same format as that of LIBLINEAR.
%         -col:
%             if 'col' is set, each column of testing_instance_matrix is a data instance. Otherwise each row is a data instance.

% Returned Model Structure
% ========================
% 
% The 'train' function returns a model which can be used for future
% prediction.  It is a structure and is organized as [Parameters, nr_class,
% nr_feature, bias, Label, w]:
% 
%         -Parameters: Parameters
%         -nr_class: number of classes
%         -nr_feature: number of features in training data (without including the bias term)
%         -bias: If >= 0, we assume one additional feature is added to the end
%             of each data instance.
%         -Label: label of each class
%         -w: a nr_w-by-n matrix for the weights, where n is nr_feature
%             or nr_feature+1 depending on the existence of the bias term.
%             nr_w is 1 if nr_class=2 and -s is not 4 (i.e., not
%             multi-class svm by Crammer and Singer). It is
%             nr_class otherwise.
% 
% If the '-v' option is specified, cross validation is conducted and the
% returned model is just a scalar: cross-validation accuracy.
  
% Result of Prediction
% ====================
% 
% The function 'predict' has three outputs. The first one,
% predicted_label, is a vector of predicted labels.
% The second output is a scalar meaning accuracy.
% The third is a matrix containing decision values or probability
% estimates (if '-b 1' is specified). If k is the number of classes
% and k' is the number of classifiers (k'=1 if k=2, otherwise k'=k), for decision values,
% each row includes results of k' binary linear classifiers. For probabilities,
% each row contains k values indicating the probability that the testing instance is in
% each class. Note that the order of classes here is the same as 'Label'
% field in the model structure.

    
% `train' Usage
% =============
% 
% Usage: train [options] training_set_file [model_file]
% options:
% -s type : set type of solver (default 1)
%         0 -- L2-regularized logistic regression
%         1 -- L2-regularized L2-loss support vector classification (dual)
%         2 -- L2-regularized L2-loss support vector classification (primal)
%         3 -- L2-regularized L1-loss support vector classification (dual)
%         4 -- multi-class support vector classification by Crammer and Singer
%         5 -- L1-regularized L2-loss support vector classification
%         6 -- L1-regularized logistic regression
% -c cost : set the parameter C (default 1)
% -e epsilon : set tolerance of termination criterion
%         -s 0 and 2
%                 |f'(w)|_2 <= eps*min(pos,neg)/l*|f'(w0)|_2,
%                 where f is the primal function and pos/neg are # of
%                 positive/negative data (default 0.01)
%         -s 1, 3, and 4
%                 Dual maximal violation <= eps; similar to libsvm (default 0.1)
%         -s 5 and 6
%                 |f'(w)|_inf <= eps*min(pos,neg)/l*|f'(w0)|_inf,
%         where f is the primal function (default 0.01)
% -B bias : if bias >= 0, instance x becomes [x; bias]; if < 0, no bias term added (default -1)
% -wi weight: weights adjust the parameter C of different classes (see README for details)
% -v n: n-fold cross validation mode
% -q : quiet mode (no outputs)
  
  
%% Default model: L2-regularized logistic regression
  model.s = 0;
  model.type = 'L2reg_logreg';
  
  if nargin >= 1
    switch lower(varargin{1})
      
     case 'l2reg_logreg'
      %%   0 -- L2-regularized logistic regression
      model.s = 0;
      model.type = 'L2reg_logreg';
     
     case 'l2reg_l2loss_svm'
      %%   1 -- L2-regularized L2-loss support vector classification (dual)
      model.s = 1;
      model.type = 'L2reg_L2loss_svm';
      
     case 'l2reg_l1loss_svm'
      %%   3 -- L2-regularized L1-loss support vector classification (dual)
      model.s = 3;
      model.type = 'L2reg_L1loss_svm';
      
     case 'l1reg_l2loss_svm'
      %%   5 -- L1-regularized L2-loss support vector classification
      model.s = 5;
      model.type = 'L1reg_L2loss_svm';
      
     case 'l1reg_logreg'
      %%   6 -- L1-regularized logistic regression
      model.s = 6;
      model.type = 'L1reg_logreg';
       
     otherwise
      model.s = 0;
      model.type = 'L2reg_logreg';
      
    end
  end
  
  %% -c cost : set the parameter C (default 1)
  model.c = 1;
  if nargin >= 2
    if isnumeric(varargin{2})
      model.c = varargin{2};
    else
      model.c = 1;
    end
  end
  
  %% Creating the Options-String
  model.options = ['-s ' num2str(model.s) ' -c ' num2str(model.c) ' -q ' ];
  
  %% The Output 
  model.liblinear = {};

  %% The scaling factors
  model.scalefactors = {};
  
  %% The training parameters
  model.trainparams = {};
  
  %% Error loss margin
  model.eps = 0.0;
  if nargin >= 3
    if isnumeric(varargin{3})
      model.eps = varargin{3}
    else
      model.eps = 0;
    end
  end
  
  model = class(model, 'liblinear' );
  

  

