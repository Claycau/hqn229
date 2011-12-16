function value = get(model, param)
  
% function value = get(model, param)
%
% Assess properties of svm object.
%
% Joerg Wichard 2005
  
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
   case 'eps'
    value = model.eps;
   otherwise
    warning(['Parameter ' param ' is not element of class svm'])
  end
  
