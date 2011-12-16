function model = kridge(varargin)
%
%  kridge( degree, coef, shrink )
%
% Generates a kernel ridge object with given hyperparameters.
% The kernel used is k(x,x') = (coef0+x.x')^degree 
% i.e., if coef0=1: the kernel is polynomial,
%       if degree=1, and coef0=0: the kernel is linear (default)
%       
%
%   parameters (with defaults)
%
%   degree             -- kernel degree, default=1  
%   coef               -- kernel bias, default=0
%   shrink             -- (small) value added to the diagonal, randsel([ 0.1, 0.01, 0.001 ])
%  
%% JDW 2006 

%%  -d degree
  
 
  model.shrink = randsel([10, 1, 0.1, 0.01, 0.001 ]);
  if nargin >= 1
    model.shrink  = varargin{1};
  end
 
  model.d = 1;
  if nargin >= 2
    model.d = varargin{2};
  end
  
  
  %% The Output of training
  model.W = [];
  model.b0 = 0;
  
  
  %% The training parameters
  model.trainparams = {};
  
  model.eps = 0.0;
   
  model = class(model, 'kridge' );
  

  

