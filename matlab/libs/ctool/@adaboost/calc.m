function y = calc(model, urbilder)
%
% y = calc(model, urbilder)
%
% Joerg Wichard 2005
  
  y = transpose( sign(Classify( model.tree, model.weights, transpose(urbilder))) );
  