function model = set(model, param, value)
%
% function model = set(model, param, value)
%
% Naive Bayes Classification
%
% Based on the class probabillity of the input data
%
% Joerg D. Wichard  2005
%%
  
  switch(lower(param))
   case 'trainparams'
    model.trainparams = value;
   case 'eps'
    model.eps = value;
   otherwise
    warning(['Parameter ' param ' is not element of class naivebayes'])
  end
  
