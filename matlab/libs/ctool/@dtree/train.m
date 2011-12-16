function [model, trainerr] = train(model, urbilder, bilder, sampleclass, trainparams, eps, varargin)
%
% function [model, trainerr] = train(model, urbilder, bilder, sampleclass, trainparams, eps)
%
% training a tree
% 
% Joerg Wichard 2005
%
  
  global entooldrawit;
  
  if isempty(trainparams)
    trainparams = get(model, 'trainparams');
  end
  
  nr_samples = length(bilder);
  
  [indtrain, indtest] = dissemble(sampleclass, nr_samples);
  
  train_features = urbilder(indtrain,:);
  test_features = urbilder(indtest,:);
  
  train_labels = bilder(indtrain);
  test_labels = bilder(indtest);
  
  model.tree =  treefit(train_features, train_labels, 'splitmin', model.alpha, 'splitcriterion', model.splitcriterion ); 

  
  model.trainparams = trainparams;
  model.eps = eps;
  
