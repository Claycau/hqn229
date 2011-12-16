function [model, trainerr] = train(model, urbilder, bilder, sampleclass, trainparams, eps, varargin)
%
% function [model, trainerr] = train(model, urbilder, bilder, sampleclass, trainparams, eps, (sample-weights) )
%
% training a Kridge Object
% 
% Joerg Wichard 2006
%
 
  global entooldrawit

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% Divide Data in Training and Test

  if isempty(trainparams)
    trainparams = get(model, 'trainparams');
  end

  nr_train = length(bilder);
  
  if nargin > 6
    sampleweights = varargin{1};
  else
    sampleweights = ones(nr_train,1);
  end
  
  [indtrain, indtest] = dissemble(sampleclass, nr_train);

  %% Traindata
  X = urbilder(indtrain,:);
  w = sampleweights(indtrain);
  Y = w.*bilder(indtrain);
  

  %% Testdata
  urbilder_test = urbilder(indtest,:);
  bilder_test   = bilder(indtest);
  weights_test  = sampleweights(indtest);

  %% Compute the eigenvectors and eigenvalues
  
  [p,n]=size(X);
  
  XX=[X, ones(p,1)];  % Add one for the bias
  
  if( (n+1) < p )
    [V,D] = eig(XX'*XX); % Matrix (n+1,n+1)
    D=diag(D);
    D(D<0)=0;
  else
    [U,S,V] = svd(XX,0);
    S=diag(S);
    S(S<0)=0;
    D=S.^2;
  end
  
  DI=1./(D + model.shrink);
  RDI=DI(:, ones(length(DI),1));
  
  if ( (n+1) < p)
    a = (V.*RDI')*(V'*(XX'*Y));
  else
    a = XX'*((U.*RDI')*(U'*Y));
  end
  
  model.W = a;
  model.b0 = a(end);
  
  
  model.trainparams = trainparams;
  model.eps = eps;
  
