function [model, trainerr] = train(model, urbilder, bilder, sampleclass, trainparams, eps, varargin)
%
% function [model, trainerr] = train(model, urbilder, bilder, sampleclass, trainparams, eps)
%
% training a tree
% 
% Joerg Wichard 2005
%
  
  
  global entooldrawit
  
  if isempty(trainparams)
    trainparams = get(model, 'trainparams');
  end
  
  nr_train = length(bilder);
  
  [indtrain, indtest] = dissemble(sampleclass, nr_train);
  
  Ntrain = length(indtrain);
  Ntest = length(indtest);
  
  if trainparams.scaledata
    %% Only use training samples to determine scale factors. Then use these to scale all data
    [dummy, model.scalefactors] = scale(urbilder(indtrain,:));
    urbilder = scale(urbilder, model.scalefactors);
  end
  

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

  
  model.liblinear = train_liblinear(bilder(indtrain), sparse(urbilder(indtrain,:)), model.options);
  
  model.trainparams = trainparams;
  model.eps = eps;
  
