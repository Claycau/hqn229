function model = cvtree(varargin)
%
%
% cross_validated decision tree
%
% Joerg D. Wichard  2005
%%
  
%% splitmin
  model.alpha = randsel([ 7, 11, 15, 24, 32  ]);
  
  if nargin >= 1
    model.alpha = varargin{1};
  end
  
  
  %% Splitcriterion 
  
  %% gdi: Gini Index
  %% twoing:  the twoing rule
  %% deviance: maximum deviance reduction

  select = randsel([ 1 2 3 ]);
  switch select
   case 1
    model.splitcriterion = 'gdi';
   case 2
    model.splitcriterion = 'twoing';
   case 3
    model.splitcriterion = 'deviance';
  end
  
  if nargin >= 2
    model.splitcriterion =  varargin{2};
  end
  
 
  %% Number of cross-validation partitions
  model.cvpart = 5;
  if nargin >= 3
    model.cvpart = varargin{3};
  end
  
    
  %% cost: Square matrix C, C(i,j) is the cost of classifying
  %%       a point into class j if its true class is i (default
  %%       has C(i,j)=1 if i~=j, and C(i,j)=0 if i=j).
  model.cost = [];
  
  model.trainparams = {};
  model.eps = 0.0;

  %% The tree structure
  model.tree = struct([]);
  
  model = class(model, 'cvtree' );

  

  
