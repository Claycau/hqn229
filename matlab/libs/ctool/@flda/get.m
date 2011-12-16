function value = get(model, param)
  
% function value = get(model, param)
%
% Assess properties of fdla object.
%
% Joerg Wichard 2004
  
  value = [];
  
  switch(lower(param))
   case 'trainparams'
    value = model.trainparams;
    
    if isempty(value)
      value.optional = {};	
    end
   case 'eps'
    value = model.eps;
   otherwise
    warning(['Parameter ' param ' is not element of class fdla'])
  end
  
