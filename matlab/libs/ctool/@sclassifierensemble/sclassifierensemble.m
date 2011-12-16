function model = sclassifierensemble(varargin)
%
% function model = sclassifierensemble(varargin)
%
% classifier ensemble with fixed scaling
%
%  J. Wichard 2004

  
  ens = ensemble;
  
  model.urbilder = [];
  model.bilder = [];
  model.sampleclasses = [];
  model.errors = [];
  model.eps = 0;
  
  model = class(model, 'sclassifierensemble', ens);
  
  


