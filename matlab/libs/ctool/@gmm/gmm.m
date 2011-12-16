function model = gmm(varargin)
%
% Gaussian Mixture Naive Bayes Classification
%
% Based on the class probabillity of the input data
%
% Joerg D. Wichard  2005
%%
  
  
%% The Method used
%%
%%  method can be:
%%
%% 'EM' 
%% 'FJ' 
%% 'GEM'
  
  model.method = 'FJ';
  model.params = { 'Cmax', 25, 'thr', 1e-3};
  
  if nargin >= 1
    
    switch  lower(varargin{1})

     case 'fj'
       model.method = 'FJ';
       model.params = { 'Cmax', 50, 'thr', 1e-3 };
     
     case 'em'
      model.method = 'EM';
      model.params = { 'components', 5, 'thr', 1e-8};
       
     case 'gem'
       model.method = 'GEM';
       model.params = { 'Cmax', 10  };
    
    otherwise
      model.method = 'FJ';
      model.params = { 'Cmax', 50, 'thr', 1e-3};
      warning('In gmm: Method FJ udes !');
    end
     
  end

  %% Die Datenstruktur für den BMM
  model.bayesS = struct([]);
  
  model.trainparams = {};		
  model.eps = 0.0;
  
  model = class(model, 'gmm');


