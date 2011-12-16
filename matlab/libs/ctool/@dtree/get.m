function value = get(model, param)
  
% function value = get(model, param)
%
% Assess properties of dtree object.
%
% Joerg Wichard 2005
  
  value = [];
  
  switch(lower(param))
    
   case 'alpha'
    value =  model.alpha;
    
   case 'trainparams'
    value = model.trainparams;
    
    if isempty(value)
      value.optional = {};	
    end
    
   case 'splitcriterion'
    value = model.splitcriterion;
    
   case 'cost'
    value = model.cost;
    
   case 'model'
    value = model.tree;
    
   case 'eps'
    value = model.eps;
    
   otherwise
    warning(['Parameter ' param ' is not element of class dtree'])
  
  end
  
