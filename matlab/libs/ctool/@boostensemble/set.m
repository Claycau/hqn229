function model = set(model, param, value)
%
% function model = set(model, param, value)
%
% Set properties of boostensemble object.
%
% Joerg Wichard 2006
  
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
    model.ensemble = set(model.ensemble, param, value);
  end

  
