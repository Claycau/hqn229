function model = perceptron(varargin)
%%
%%
%% Joerg Wichard 2002
  
%% Default-Perceptron Topologie
  flayer1 = randsel([4 6 8 12 16 24 32]);
  flayer2 = randsel([3 5 7 9]);
  
  model.tmp_topo = [ flayer1, flayer2 ];
 
  if nargin >= 1
    model.tmp_topo = varargin{1};
  end
  
  model.topo = [];
  model.layers = 0;
  model.w = [];

  %% Initialize the weights with the best linear fit !!!
  model.linear_init = 0; % randsel([ 0 1 ]);
  
  %% The small linear factor for the function: tanh(x) + model.linear_factor*(x)
  model.linear_factor =  0.0001;
  
  %% Scaling the data to this interval for perceptron training
  model.data_scale = [ -(2/3), (2/3) ];
  
  %% The One-Neuron-Offset
  model.offsett =  (-1/3);
 
  %% Scalingfacotrs for internal use
  model.urbilder_scalefacs = [];
  model.bilder_scalefac = [];
  
  %% Scalingfacotrs for external use
  model.uscalefacs = [];
  model.bscalefac = [];
  
  model.trainparams = {};		
  model.eps = 0.0;
  
  model = class(model, 'perceptron');
  
  
