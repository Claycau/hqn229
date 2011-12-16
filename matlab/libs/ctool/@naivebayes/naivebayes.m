function model = naivebayes(varargin)
%
% Naive Bayes Classification
%
% Based on the class probabillity of the input data
%
% Joerg D. Wichard  2005
%%
  
  
%% Class Probabilliteis
  model.ypr1 = [];
  model.xpr1 = [];
  model.xpr0 = [];
  
  %% Number of nearest neighbors
  model.alpha = 1;
  
  if nargin >= 1
    model.alpha = varargin{1};
  end
  
  %% The Vector of feature weights
  model.weights = [];
  
  %% The features
  model.feat = [];
  
  %% The labels
  model.label = [];
  
  model.trainparams = {};		
  model.eps = 0.0;
  
  model = class(model, 'naivebayes');


