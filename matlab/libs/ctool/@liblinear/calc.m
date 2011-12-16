function y = calc(model, urbilder)
%
% y = calc(model, urbilder)
%
% Joerg Wichard 2009
%
% FMP-Berlin
    
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
%             options:
%             -b probability_estimates: whether to predict probability estimates, 0 or 1 (default 0)
%
%         -col:
%             if 'col' is set, each column of testing_instance_matrix is a data instance. Otherwise each row is a data instance.
  
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

% `predict' Usage
% ===============
% 
% Usage: predict [options] test_file model_file output_file
% options:
% -b probability_estimates: whether to predict probability estimates, 0 or 1 (default 0)
% 
  
  N = size(urbilder,1);
  
  if ~isempty(model.scalefactors)
    urbilder = scale(urbilder,  model.scalefactors);
  end
  
  urbilder = sparse(urbilder);
  
  y = predict( randn(N,1), urbilder, model.liblinear);
  
  
