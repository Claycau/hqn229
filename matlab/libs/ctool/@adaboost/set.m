function model = set(model, param, value)
%
% function model = set(model, param, value)
%
% JDW 2005
  
  
  switch(lower(param))
   case 'trainparams'
    model.trainparams = value;
   case 'tree'
    model.tree = value;    
   case 'weights'
    model.weights = value;
   case 'iter'
    model.iter = value;
   case 'max_split'
    model.max_split = value;
   case 'eps'
    model.eps = value;
   otherwise
    warning(['Parameter ' param ' is not element of class adaboost']);
  end
  
