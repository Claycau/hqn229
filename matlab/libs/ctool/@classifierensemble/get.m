function value = get(model, param)

% function value = get(model, param)
%
% Access properties of classifierensemble object.
%
% Jörg Wichard 2004
  
  value = [];
  
  switch(lower(param))
    
   case 'trainparams'
    
    value = get(model.ensemble, 'trainparams');
    
    if isempty(value)
      
      %% Number of Test/Trainings Partitions
      value.nr_cv_partitions = 5;
      
      %% Hold out for the test set
      value.frac_test = 0.20;
      
      %% Lineare Discriminanz Analyse als Default Modell 
      %% value.modelclasses = {'flda', [], {} };
      
      %% Naive Bayes als Default Modell
      value.modelclasses = {'dtree', [], {} };
      
      %% Default Scoring function is the fscore
      value.scoring = 'fscore';
      
      %% Datensatz balancieren ?
      value.balance = 0;
      
    end
      
   otherwise
    value = get(model.ensemble, param);
  end
  
