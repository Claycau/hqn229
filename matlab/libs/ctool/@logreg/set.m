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
    
   case 'eps'
    model.eps = value;
   
   otherwise
    warning(['Parameter ' param ' is not element of class logreg'])
  end
  
  
