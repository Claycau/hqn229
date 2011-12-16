function model=pda(varargin)
%
% pda: penalized linear discriminant analysis 
%
%
%
% Joerg D. Wichard  2004
%%
  
  
%% Die Cluster Center
  model.mean0 = 0.0;
  model.mean1 = 0.0;
  
  %% Die Covarianz-Matrizen
  model.cov0 = [];
  model.cov1 = [];
  
  %% Die Pseudo-Inversen der Covarianz-Matrizen
  model.sig0  = []; 
  model.sig1  = [];
  
  %% Die Gewichte (Log. der rel. Häufigkeiten)
  model.pi0  = 0.0;
  model.pi1  = 0.0;  
  
  %% model.alpha das gewicht das gewicht für die penalty function 
  %% auf der covarianz matrix 0 < model.alpha < 0.1
  model.alpha = abs(0.1*rand(1)); 
  
  %% model.beta  das Maximal-Gewicht für die Gewichtung aus 
  %% pooled cov und einzel cov der Klassen, während des Trainings werden
  %% 10 Werte zwischen 0 und model.beta getested und der beste wird genommen
  model.beta = 1.0; 
    
  if nargin >= 1
    model.alpha = varargin{1};
  end
  
  if nargin >= 2
     model.beta = varargin{1};
  end
    
  model.trainparams = {};		
  model.eps = 0.0;
  
  model = class(model, 'pda');


