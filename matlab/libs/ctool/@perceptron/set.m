function model = set(model, param, value)

% function model = set(model, param, value)
%
%
% Joerg Wichard
  
  switch(lower(param))
   case 'trainparams'
    model.trainparams = value;
   case 'eps'
    model.eps = value;
   otherwise
    warning('Parameter is not element of class perceptron');
  end
  
