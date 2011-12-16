function y = calc(model, urbilder)
%
% y = calc(model, urbilder)
%
% Joerg Wichard 2005

%% Berechnung der Klassenzugehörigkeit

y = treeval(model.tree,urbilder);



