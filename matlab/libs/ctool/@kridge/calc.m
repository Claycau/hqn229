function y = calc(model, urbilder)
%
% y = calc(model, urbilder)
%
% Joerg Wichard 2005


  N = size(urbilder,1);
  %y =  fastlincut([ urbilder ones(N,1)] * model.W);
  y =  [ urbilder ones(N,1)] * model.W;
