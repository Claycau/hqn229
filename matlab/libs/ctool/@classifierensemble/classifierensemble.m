function model = classifierensemble(varargin)
%
% function model = classifierensemble(varargin)
%
%  J. Wichard 2004

  
  ens = ensemble;
  
  model.urbilder = [];
  model.bilder = [];
  model.sampleclasses = [];
  model.errors = [];
  model.eps = 0;
  
  model = class(model, 'classifierensemble', ens);
  
  


