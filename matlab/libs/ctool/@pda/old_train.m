function [model, trainerr] = train(model, urbilder, bilder, sampleclass, trainparams, eps, varargin)
%
% function [model, trainerr] = train(model, urbilder, bilder, sampleclass, trainparams, eps)
%
% Penalized Linear Discriminant Analysis 
% 
% Joerg Wichard 2004
%
  
  global entooldrawit
  
  if isempty(trainparams)
    trainparams = get(model, 'trainparams');
  end
  
  nr_samples = length(bilder);
  
  [indtrain, indtest] = dissemble(sampleclass, nr_samples);
  
  train_features = urbilder(indtrain,:);
  test_features = urbilder(indtest,:);
  
  train_labels = bilder(indtrain);
  test_labels = bilder(indtest);
  
  train_one  = find(train_labels > 0.0 );
  train_zero = find(train_labels <= 0.0 );
    
  length0                 = length(train_zero);
  length1                 = length(train_one);
    
  c0                    = cov(train_features(train_zero,:),1);
  c1                    = cov(train_features(train_one,:),1);
  cpooled               = 0.5*(c0 + c1);
  
  model.cov0		= ((1-model.beta)*c0 + model.beta*cpooled);
  model.mean0		= mean(train_features(train_zero,:))';
  model.sig0            = pinv( model.cov0 );
  model.pi0             = log( length0 / (length0 + length1) );
    
  model.cov1		= ((1-model.beta)*c1 + model.beta*cpooled);
  model.mean1		= mean(train_features(train_one,:))';
  model.sig1            = pinv( model.cov1 );
  model.pi1             = log( length1 / (length0 + length1) );
   
  model.trainparams = trainparams;
  model.eps = eps;

  
  
