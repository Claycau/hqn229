function y = calc(model, urbilder)
%
% y = calc(model, urbilder)
%
% Joerg Wichard 2007

%% Berechnung der Log. Reg. 

  %% Hier muss die Berechnung rein:
  %  y = calc_logreg( model.coeffs,urbilder);

y = logregsim(model, urbilder);
  
  
%% Die Funktion  calc_logreg( model.coeffs,urbilder)
%% muss in das Verzeichnis 'private'
%% und dort eben mit den koeffizientenvektor aus dem Training und den
%% Urbildern die Ausgaben berechnen
    
    



