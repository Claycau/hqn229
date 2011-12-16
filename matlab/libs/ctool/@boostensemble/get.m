function value = get(model, param)

% function value = get(model, param)
%
% Access properties of boostensemble object.
%
% Jörg Wichard 2006
  
  value = [];
  
  switch(lower(param))
    
   case 'trainparams'
    
    value = get(model.ensemble, 'trainparams');
    
   otherwise
    value = get(model.ensemble, param);
  end
  
