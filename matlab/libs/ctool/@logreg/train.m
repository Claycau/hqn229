function [model, trainerr] = train(model, urbilder, bilder, sampleclass, trainparams, eps, varargin)
%
% function [model, trainerr] = train(model, urbilder, bilder, sampleclass, trainparams, eps)
%
% training a logistig regression model
% 
% Joerg Wichard 2007
%
  
  global entooldrawit;
    
  if isempty(trainparams)
    trainparams = get(model, 'trainparams');
  end
  
  nr_samples = length(bilder);
  
  [indtrain, indtest] = dissemble(sampleclass, nr_samples);
  
  train_features = urbilder(indtrain,:);
  test_features = urbilder(indtest,:);
  
  train_labels = bilder(indtrain);
  neg_label = find( train_labels <= 0);    %
  train_labels(neg_label) = 0;
  
  test_labels = bilder(indtest);
  neg_label = find( test_labels <= 0);    %
  test_labels(neg_label) = 0;
  
  bilder1=bilder;
  neg_label = find( bilder1 <=0);
  bilder1(neg_label) = 0;
  %%% Hier muss jetzt das training geschehen
  %%% Dazu muss im Verzeichnis 'private' eine
  %%% Trainingsroutine stehen, die  logistische regression
  %%% ausfÃ¼hren kann, und die koeffizienten zurückgibt
  %%% die koeffizienten werden in  model.coeffs
  %%% gespeichert und dann in der calc.m zur Berechnung der Ausgabe benutzt
  %res = logreg(train_labels, train_features);
  res = logreg(bilder1,urbilder);
  model.coeffs = res{4};
  model.trainparams = trainparams;
  model.eps = eps;
  
