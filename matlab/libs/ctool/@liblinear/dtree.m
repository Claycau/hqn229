function model = svm(varargin)
%
%
%
%
%  Joerg D. Wichard  2005
%%

  
  model.alpha = 1;

  if nargin >= 1
    model.alpha = varargin{1};
  end

  model.trainparams = {};
  model.eps = 0.0;

  
  
  model = class(model, 'svm' );

  

