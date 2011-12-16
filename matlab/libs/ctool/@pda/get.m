function value = get(model, param)
  
% function value = get(model, param)
%
% Assess properties of pda object.
%
% Joerg Wichard 2004
  
  value = [];
  
  switch(lower(param))
    
   case 'beta'
    value = model.beta;
    
   case 'trainparams'
    value = model.trainparams;
    
    if isempty(value)
      value.optional = {};	
    end
    
   case 'eps'
    value = model.eps;
   otherwise
    warning(['Parameter ' param ' is not element of class pda'])
  end
  
