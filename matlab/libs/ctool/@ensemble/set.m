function model = set(model, param, value)

% function model = set(model, param, value)
%
%
% Christian Merkwirth 2002
%
% Joerg Wichard 2004
  
  switch(lower(param))
   case 'models'
    model.models = value;    
   case 'weights'
    model.weights = value;
   case 'errors'
    model.errors = value;
   case 'optional'
    model.optional = value;
   case 'uscalefacs'
    model.uscalefacs = value;
   case 'bscalefac'
    model.bscalefac = value;
   case 'trainparams'
    model.trainparams = value;
   case 'eps'
    model.eps = value;
   case 'summing'
    model.summing = value;  
   otherwise
    warning(['Parameter ' param ' is not element of class ensemble'])
  end

  
