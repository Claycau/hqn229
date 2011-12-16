function y = calc(model, urbilder)
%
% y = calc(model, urbilder)
%
% Joerg Wichard 2005


  N = size(urbilder,1);

  if ~isempty(model.scalefactors)
    urbilder = scale(urbilder,  model.scalefactors);
  end
  
  y = svmpredict( randn(N,1), urbilder, model.svm);
  
