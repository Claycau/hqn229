function value = get(model, param)
  
% function value = get(model, param)
%
% Assess properties of ensemble object.
%
% Christian Merkwirth 2002
%
% Joerg Wichard 2004
  
  
  value = [];
  
  switch(lower(param))
   case 'models'
    value = model.models;
   case 'weights'
    value = model.weights;
   case 'errors'
    value = model.errors;
   case 'optional'
    value = model.optional;
   case 'uscalefacs'
    value = model.uscalefacs;
   case 'bscalefac'
    value = model.bscalefac;
   case 'trainparams'
    value = model.trainparams;
   case 'eps'
    value = model.eps;
   case 'summing'
    value = model.summing;   
   otherwise
    warning(['Parameter ' param ' is not element of class ensemble'])
  end
  
