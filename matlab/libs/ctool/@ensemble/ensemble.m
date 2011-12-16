function model=ensemble(varargin)
%
% function model=ensemble(varargin)
%
% constructor of the ensemble class
%
% Christian Merkwirth 2002
%
% Joerg Wichard 2004/2005
%
  
  
  if nargin == 0
    
    %% create an ensemle object
    
    model.models = {};
    model.errors = {};
    model.weights = [];
    model.summing = 0;		% 0 => average models, sum(weights) == 1; 1 => add model output !  
    model.trainparams = [];
    model.eps = 0.0;
    model.uscalefacs = [];
    model.bscalefac = [];
    model.optional = {};
    
    model = class(model, 'ensemble');
    
  elseif isa(varargin{1},'ensemble')
    
    %% return the ensemle object
    
    model = varargin{1};
    
  end
  

