function [ model ] = train(model, urbilder, bilder, sampleclass, trainparams, eps, varargin)
%
% function [ model ] = train(model, urbilder, bilder, sampleclass, trainparams, eps, varargin)
%
% Simple straight-forward adaboost for boostensemble
%
% Joerg Wichard 2003
%
  
  global entooldrawit;
  
  if isempty(trainparams)
    trainparams = get(model, 'trainparams');
  end
  
  nr_samples          = length(bilder);
  [indtrain, indtest] = dissemble(sampleclass, nr_samples);
  
  model.urbilder = urbilder(indtrain,:);
  model.bilder   = bilder(indtrain);
  
  urbilder = urbilder(indtrain,:);
  bilder   = bilder(indtrain);
  w        = ones(size(bilder));   %% Initializing the Boosting Weights
  
  loss = randsel( [ 0.1, 0.01, 0.001, 0.0001] );
  for i=1:model.iter_boost
    
    my_model =  model.m;
    
    switch my_model
     case 'kridge'
      m = kridge(loss + 0.1*i*loss);
      mtrainparams = get(m, 'trainparams');
     case 'mlp'     
      m = mlp([10 5]);
      mtrainparams = get(m, 'trainparams');
      mtrainparams.decay  = (loss + 0.1*i*loss);
      mtrainparams.rounds = 100;
      mtrainparams.error_loss_margin = 0.1;
     case 'dtree'
      m = dtree(10+2*i);
      mtrainparams = get(m, 'trainparams');
     case 'cvtree'
      m = cvtree(10+2*i);
      mtrainparams = get(m, 'trainparams');
     otherwise
      m = kridge(loss + 0.1*i*loss);
      mtrainparams = get(m, 'trainparams');
    end
      
    m = train(m, urbilder, bilder, [], mtrainparams, eps, w);
    
    thismodel = m;
    
    %% Calc the Error 
    ztrain                            = calc(m, urbilder);
    
    wri = find( sign(ztrain) ~= bilder );
    
    if( sum(w) > 0 )
      err = sum(w(wri))/sum(w);
      if( abs(err) > 0 ) 
	alpha = log( (1-err)/err );
      else
	alpha = 0;
      end
    else
      err = 0.0;
      alpha = 0;
    end
    
    w(wri) = w(wri)*exp(alpha);
    
    disp([num2str(alpha), '  ', num2str(err), '  ', num2str(nnz(wri)) ]);
    
    %% Ensemble Gewichtet mit dem Testfehler
    model.ensemble=addmodel(model.ensemble, thismodel, alpha, err);
    
  end
  
  disp( '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
  disp('Boosting-Ensemble-Trained');
  
  
  model = set(model, 'eps', eps);
  %model = set(model, 'trainparams', trainparams);
  
  
