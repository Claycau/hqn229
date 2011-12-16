function model = set(model, param, value)
%
% function model = set(model, param, value)
%
%
  
  
  switch(lower(param))
   
   case 'trainparams'
    model.trainparams = value;
   
   case 'alpha'
    model.alpha = value;
    
   case 'splitcriterion'
    model.splitcriterion = value;
    
   case 'cost'
    model.cost = value;
    
   case 'cvpart' 
    model.cvpart = value;
    
   case 'eps'
    model.eps = value;

   case 'tree'
    model.tree = value;
    
   otherwise
    warning(['Parameter ' param ' is not element of class dtree'])
  end
  
  
