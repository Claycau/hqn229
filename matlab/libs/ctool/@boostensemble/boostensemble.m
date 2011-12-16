function model = boostensemble(varargin)
%
% function model = boosterensemble(varargin)
%
%  J. Wichard 2004

  
  ens = ensemble;
  
  %% Standartmodel is the kernel-ridge classifier
  model.m = 'kridge';
  if nargin >= 1
    model.m = varargin{1};
  end

  %% number of boosting rounds
  model.iter_boost = randsel([ 11, 21, 31]);
  if nargin >= 2
    model.iter_boost = varargin{2};
  end
  
  
  %% The shrinking parameter
  model.shrink = randsel([0.1, 1, 10]);
  if nargin >= 3
    model.shrink = varargin{3};
  end

  
  
  model.urbilder = [];
  model.bilder = [];
  model.sampleclasses = [];
  model.errors = [];
  model.eps = 0;
  
  model = class(model, 'boostensemble', ens);
  
  


