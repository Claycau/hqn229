function y = calc(model, urbilder)
%
% y = calc(model, urbilder)
%
% Joerg Wichard 2005
%
% Naive Bayes simply based on random guessing, 
% based on the Class-probabillity of the data

  [ ntst, p ] = size(urbilder);
  
  y = zeros(ntst,1);
  
  for i = 1:ntst
    log_ratio = log (model.ypr1/(1-model.ypr1));
    for j = 1:p
      if (urbilder(i,j)==1)
        log_ratio = log_ratio + log (model.xpr1(j)/model.xpr0(j));
      else
        log_ratio = log_ratio + log ((1-model.xpr1(j))/(1-model.xpr0(j)));
      end
    end
    y(i) = 1 / (1 + exp(-log_ratio));
  end
  
