function value = get(model, param)

% function value = get(model, param)
%
% Assess properties of mlp object.
%
% Joerg Wichard 2002

value = [];

switch(lower(param))
 case 'trainparams'
  value = model.trainparams;
  
  if isempty(value)
    
    %% Epsilon insentiv error loss
    trainparams.error_loss_margin = 0.05;
    
    %%  Weight Decay
    trainparams.decay  = 0.001;
     
    %% Number of training rounds
    trainparams.rounds = 500;
    
    %% Initial stepsize for Rprop
    trainparams.mrate_init = 0.0025;
    
    %% Maximal Weight
    trainparams.max_weight = 10.0;
    
    %% Growthrate of Rprop stepsize
    trainparams.mrate_grow = 1.125;
    
    %% Shrinkrate  of Rprop stepsize
    trainparams.mrate_shrink = 0.5;
    
    value = trainparams;	
  end
 case 'eps'
  value = model.eps;
 otherwise
  warning(['Parameter ' param ' is not element of class mlp'])
end
