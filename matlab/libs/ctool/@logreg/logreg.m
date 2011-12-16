function model = logreg(varargin)
%
%
% Logistic Regression
%
% Joerg D. Wichard  2007
%%
  
%% Einen Parameter kann man immer gebrauchen
  model.alpha = randsel([ 7, 11, 15, 24, 32  ]);
  
  if nargin >= 1
    model.alpha = varargin{1};
  end
  
  model.trainparams = {};
  model.eps = 0.0;
  
  %% Der Koeffizienten Vector der Logistischen Regression
  model.coeffs = [];
  
  model = class(model, 'logreg' );

  

  
