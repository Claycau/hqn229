function model = adaboost(varargin)
%
%   model = adaboost( n )
%
% 
%   iter: number of adaboost iterations
%
%   n: Number of terminal nodes for the base learner
%
%
%   The base leaner:
%
%   Simple decision tree, based on:
%
%   The algorithms implemented by Alexander Vezhnevets aka Vezhnick
%   <a>href="mailto:vezhnick@gmail.com">vezhnick@gmail.com</a>
%
%   Copyright (C) 2005, Vezhnevets Alexander
%   vezhnick@gmail.com
%   
%   This file is part of GML Matlab Toolbox
%   For conditions of distribution and use, see the accompanying License.txt file.

 
  %% Number of iterations
  model.iter =  randsel([ 20, 50, 100 ]);
  
  if nargin >= 1
    model.iter = varargin{1};
  end
  
  
  %% Number of splits
  model.max_split = randsel([ 3, 5, 7, 9]);
  
  if nargin >= 2
    model.max_split = varargin{2};
  end
  
  %% Method: RealAdaboost or ModestAdaboost
  model.method = 'modest';
  if nargin >= 3
    switch lower(varargin{3})
      %
     case 'modest'
      model.method = 'modest';
     case 'real'
      model.method = 'real';
     case 'gentle'
      model.method = 'gentle';
     otherwise
      model.method = 'modest';
    end
  end
    
  %% The base learners
  model.tree = {};
  
  %% The boosting weights
  model.weights = [];
  
  model.left_constrain  = [];
  model.right_constrain = [];
  model.dim             = [];
  model.parent          = [];
  
  
  model.trainparams = {};
  model.eps = 0.0;
  
  model = class(model, 'adaboost');
  

