function value = get(model, param)
  
% function value = get(model, param)
%
% Assess properties of svm object.
%
% Joerg Wichard 2005
  
  value = [];
  
  switch(lower(param))
   case 'trainparams'
    value = model.trainparams;
   case 'eps'
    value = model.eps;
   case 'coefficients'
    value = model.W;
   otherwise
    warning(['Parameter ' param ' is not element of class kridge'])
  end
  
