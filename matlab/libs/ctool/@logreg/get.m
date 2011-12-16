function value = get(model, param)
  
% function value = get(model, param)
%
% Assess properties of logreg object.
%
% Joerg Wichard 2007
  
  value = [];
  
  switch(lower(param))
    
   case 'alpha'
    value =  model.alpha;
    
   case 'trainparams'
    value = model.trainparams;
    
   case 'coeffs'
    value = model.coeffs;
    
    if isempty(value)
      value.optional = {};	
    end
    
   case 'eps'
    value = model.eps;
    
   otherwise
    warning(['Parameter ' param ' is not element of class logreg'])
  
  end
  
