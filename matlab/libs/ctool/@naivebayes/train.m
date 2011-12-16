function [model, trainerr] = train(model, urbilder, bilder, sampleclass, trainparams, eps, varargin)
%
% function [model, trainerr] = train(model, urbilder, bilder, sampleclass, trainparams, eps)
%
% 
% Naive Bayes Classification
%
% Based on the class probabillity of the input data
%
% Joerg D. Wichard  2005
%%
 
  global entooldrawit
   
  if isempty(trainparams)
    trainparams = get(model, 'trainparams');
  end
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% Divide Data in Training and Test

  nr_train = length(bilder);
  [indtrain, indtest] = dissemble(sampleclass, nr_train);
  
  %% The features
  x_train = urbilder(indtrain,:);
  
  %% The labels
  y_train = bilder(indtrain);  

  model.ypr1 = mean( y_train > 0 );

  model.xpr1 = (model.alpha + sum(x_train(y_train > 0,:))) / (2*model.alpha + sum( y_train > 0 ));
  model.xpr0 = (model.alpha + sum(x_train(y_train <= 0,:))) / (2*model.alpha + sum( y_train <= 0 ));

  model.trainparams = trainparams;
  model.eps = eps;
