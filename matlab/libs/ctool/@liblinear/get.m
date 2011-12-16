function value = get(model, param)
  
% function value = get(model, param)
%
% Assess properties of liblinear object.
%
% Joerg Wichard 2009
  
  value = [];
  
  switch(lower(param))
   case 'trainparams'
    value = model.trainparams;
    %%  
    if isempty(value)
      opts.scaledata = 1;    % opts.scaledata = 1 means:scale inputs to [-1 1]
      opts.verbose   = 0;
      value = opts;
    end
   case 'model'
    value = model.liblinear;
   case 'type'
    value = model.type;
   case 'options'
    value = model.options;
   case 'scalefactors'
    value =model.scalefactors; 
   case 'eps'
    value = model.eps;
   otherwise
    warning(['Parameter ' param ' is not element of class liblinear'])
  end
  
