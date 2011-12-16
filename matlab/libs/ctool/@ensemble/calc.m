function [y, yall]  = calc(model, urbilder)
%
% [y, yall] = calc(model, urbilder)
%
% Christian Merkwirth 2002
%
% Joerg Wichard 2004

  
%% Skalierung bei Klassifizierung : [ -1; 1 ]
  if (~isempty(urbilder)) & (~isempty(model.uscalefacs))
    urbilder = scale(urbilder, model.uscalefacs);
  end   
  
  yall = zeros(size(urbilder,1), length(model.models));
  
  %% Calculate output for all models of the ensemble
  for i=1:length(model.models)
    %% Use all variables as input for model i
    yall(:,i) = calc(model.models{i}, urbilder);
  end 
  
  %% Bring output back to original scaling
  if ~isempty(model.bscalefac)
    yall = yall*model.bscalefac(2) + model.bscalefac(1);
  end
  
  %% Do the ensemble averaging or adding (in case of summing)
  if isempty(model.weights)
    if model.summing
      y = sum(yall,2);   
    else
      y = mean(yall,2);    
    end
  else
    if model.summing
      ws = 1.0;
    else
      ws = sum(model.weights);
    end
    
    y = sum(yall .* repmat(model.weights, size(yall,1), 1), 2) / ws;
    
    zindex = find(y==0);
    
    if( zindex )
      disp(['There were ', num2str(nnz(zindex)), ' undifined class-labels !']);
      y(zindex) = sign(randn(size(zindex)));
    end
    
  end   
  
