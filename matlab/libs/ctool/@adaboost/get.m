function value = get(model, param)
% function value = get(model, param)
%
% Assess properties of adaboost object.
%
% Joerg Wichard 2005
  
  value = [];
  
  switch(lower(param))
   case 'trainparams'
    value = model.trainparams;
    %
    if isempty(value)
      value.optional = {};	
    end
   case 'eps'
    value = model.eps;
   case 'tree'
    value = model.tree;    
   case 'weights'
    value = model.weights;
   case 'iter'
    value = model.iter;
   case 'max_split'
    value = model.max_split;
   otherwise
    warning(['Parameter ' param ' is not element of class adaboost']);
  end
  
