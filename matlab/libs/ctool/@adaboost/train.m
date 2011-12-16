function [model, trainerr] = train(model, in_dataset, in_labels, sampleclass, trainparams, eps, varargin)
%% 
  
  global entooldrawit
   
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% Divide Data in Training and Test
  
  if isempty(trainparams)
    trainparams = get(node, 'trainparams');
  end
  
  trainerr = 0; %% !!
  
  [indtrain, indtest] = dissemble(sampleclass, length(in_labels));
  
  dataset = in_dataset(indtrain,:)';
  labels  = in_labels(indtrain)';
  
  %test_dataset = in_dataset(indtest,:)';
  %test_labels  = in_labels(indtest)';
  
  %% constructing weak learner
  weak_learner = tree_node_w(model.max_split); % pass the number of tree splits to the constructor
  
  %% Real-Adaboost or Modest-Adaboost
  
  switch lower(model.method)
    
   case 'modest'
    
    %% training with Modest AdaBoost
    [model.tree, model.weights] = ModestAdaBoost(weak_learner, dataset, labels, model.iter);
    
   case 'real'
    
    %% training with Real AdaBoost
    [model.tree, model.weights] = RealAdaBoost(weak_learner, dataset, labels, model.iter);
    
   case 'gentle'
    
    %% training with Gentle AdaBoost
    [model.tree, model.weights] =  GentleAdaBoost(weak_learner, dataset, labels, model.iter);
    
   otherwise
    
    %% training with Modest AdaBoost
    [model.tree, model.weights] = ModestAdaBoost(weak_learner, dataset, labels, model.iter);
    
  end
  
  model.trainparams = trainparams;
  model.eps = eps;
  
  