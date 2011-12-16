function value = get(model, param)
  
% function value = get(model, param)
%
% Assess properties of  Gaussian Mixture Naive Bayes Classification
%
% Based on the class probabillity of the input data
%
% Joerg D. Wichard  2005
%%
  
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
    warning(['Parameter ' param ' is not element of class NAIVEBAYES'])
  end
  
