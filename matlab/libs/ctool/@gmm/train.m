function [model, trainerr] = train(model, urbilder, bilder, sampleclass, trainparams, eps, varargin)
%
% function [model, trainerr] = train(model, urbilder, bilder, sampleclass, trainparams, eps)
%
% 
%  Gaussian Mixture Naive Bayes Classification
%
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
  
  Y = bilder(indtrain);
  
  %% Class Labels ändern 
  neg = find( Y < 0 );
  pos = find( Y > 0 );
  
  Y(pos) = 1;
  Y(neg) = 2;
    
  model.bayesS = gmmb_create(urbilder(indtrain,:), Y, model.method, model.params{:});
      
  model.trainparams = trainparams;
  model.eps = eps;
