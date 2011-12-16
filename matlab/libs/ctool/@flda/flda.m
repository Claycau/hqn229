function model=flda(varargin)
%
% Lineare Diskriminanz Analyse 
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
  
  %% model.alpha das gewicht für die penalty function 
  %% der Covarianz-Matrix  aus: 0 < model.alpha < 0.1
  model.alpha = abs(0.1*(rand(1))); 
  model.alpha_flag = 0;
  
  if nargin >= 1
    model.alpha = varargin{1};
    model.alpha_flag = 1;
  end
    
  model.trainparams = {};		
  model.eps = 0.0;
  
  model = class(model, 'flda');


