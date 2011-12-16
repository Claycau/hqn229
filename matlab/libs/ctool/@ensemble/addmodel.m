function model = addmodel(model, m, varargin)

% function model = addmodel(model, newmodel, (newmodelweight), (newmodelerror) )
% 
% Add model m to ensemble
%
% Christian Merkwirth 2002
%
% Joerg Wichard 2004

  if iscell(m)
    
    for i=1:length(m)
      model.models{end+1} = m{i};
      
      if nargin > 2
	model.weights(end+1) = varargin{1};
      end
      if nargin > 3
	model.errors{end+1} = varargin{2};
      end
    end   
    
  else
    model.models{end+1} = m;
    
    if nargin > 2
      model.weights(end+1) = varargin{1};
    end
    
    if nargin > 3
      model.errors{end+1} = varargin{2};
    end
  end   
  

