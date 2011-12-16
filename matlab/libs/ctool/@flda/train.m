function [model, trainerr] = train(model, urbilder, bilder, sampleclass, trainparams, eps, varargin)
%
% function [model, trainerr] = train(model, urbilder, bilder, sampleclass, trainparams, eps)
%
% Fischer Linear Discriminant Analysis 

% 
% Joerg Wichard 2004
%
  
  global entooldrawit
  
  if isempty(trainparams)
    trainparams = get(model, 'trainparams');
  end
  
  alpha = model.alpha;
  
  nr_samples = length(bilder);
  
  [indtrain, indtest] = dissemble(sampleclass, nr_samples);
  
  train_features = urbilder(indtrain,:);
  test_features = urbilder(indtest,:);
  
  train_labels = bilder(indtrain);
  test_labels = bilder(indtest);
  
  train_one  = find(train_labels > 0.0 );
  train_zero = find(train_labels <= 0.0 );
    
  length0                 = length(train_zero);
  length1                 = length(train_one);
    
  model.cov0		= cov(train_features(train_zero,:),1);
  model.mean0		= mean(train_features(train_zero,:))';
  model.pi0             = log( length0 / (length0 + length1) );
  model.cov1		= cov(train_features(train_one,:),1);
  model.mean1		= mean(train_features(train_one,:))';
  model.pi1             = log( length1 / (length0 + length1) );
  

  %% Wenn kein Wert für model.alpha gesetzt ist, wird der Wert für model.alpha 
  %% aus [ 0, 0.1 ] gewählt
  
  if (   model.alpha_flag == 0 )
    
    alphav = [0.0:0.1:1];
    for k = 1:length(alphav)
      
      alpha = alphav(k);
      
      model.sig0            = pinv(alpha*model.cov0 + (1-alpha)*diag(diag(model.cov0)));
      model.sig1            = pinv(alpha*model.cov1 + (1-alpha)*diag(diag(model.cov1)));
      
      tout = calc(model, train_features);
      
      [fp, tp, fn, tn] = count_classified(train_labels, tout);
      
      accuracy(k)  = ( tp + tn )/(tp + fp + tn + fn);
      
      if( ~isempty( test_labels ) )
        tout = calc(model, test_features);
        [fp, tp, fn, tn] = count_classified(test_labels, tout);
        oot_accuracy(k)  = ( tp + tn )/(tp + fp + tn + fn);
      end
      
    end
    
    [ Y, I ] = sort( -1.0*accuracy );
    
    model.alpha = alphav(I(1));

    if( entooldrawit )
   
      plot(alphav, accuracy);
      hold on;
      title('FLDA Penalty')
      xlabel('alpha')
      ylabel('accuracy');
      
      if( ~isempty( test_labels ) )
	plot(alphav, oot_accuracy,'r');
      end
      hold off;
      drawnow;
    end
    
  else
    
    model.sig0            = pinv(model.alpha*model.cov0 + (1-model.alpha)*diag(diag(model.cov0)));
    model.sig1            = pinv(model.alpha*model.cov1 + (1-model.alpha)*diag(diag(model.cov1)));
    
  end
    
    
 
  model.trainparams = trainparams;
  model.eps = eps;
