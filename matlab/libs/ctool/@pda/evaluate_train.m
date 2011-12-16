function [model, trainerr] = train(model, urbilder, bilder, sampleclass, trainparams, eps, varargin)
%
% function [model, trainerr] = train(model, urbilder, bilder, sampleclass, trainparams, eps)
%
% Penalized Linear Discriminant Analysis 
% 
% Joerg Wichard 2004
%
  
  global entooldrawit
  
  if isempty(trainparams)
    trainparams = get(model, 'trainparams');
  end
  
  nr_samples = length(bilder);
  
  [indtrain, indtest] = dissemble(sampleclass, nr_samples);
  
  train_features = urbilder(indtrain,:);
  test_features = urbilder(indtest,:);
  
  train_labels = bilder(indtrain);
  test_labels = bilder(indtest);
  
  train_one  = find(train_labels > 0.0 );
  train_zero = find(train_labels <= 0.0 );
    
  length0              = length(train_zero);
  length1              = length(train_one);
    
  c0                    = cov(train_features(train_zero,:),1);
  c1                    = cov(train_features(train_one,:),1);
  cpooled               = 0.5*(c0 + c1);
  
  model.mean0		= mean(train_features(train_zero,:))';
  model.pi0             = log( length0 / (length0 + length1) );
  
  model.mean1		= mean(train_features(train_one,:))';
  model.pi1             = log( length1 / (length0 + length1) );
  

  gamma = [ 0:0.1:1.0 ];
  beta = [ 0:0.1:1.0 ];
  
  accuracy     = zeros(length(gamma),length(beta));
  oot_accuracy = zeros(length(gamma),length(beta));
  
  for l=1:length(gamma)
    for k=1:length(beta)
      
%       model.cov0		= ((1-beta(k))*c0 + beta(k)*cpooled);
%       model.sig0            = pinv( model.cov0 );
%       
      model.cov0		= ((1-gamma(l))*c0 + gamma(l)*cpooled);
      model.sig0            = pinv( model.cov0 );
      
      model.cov1		= ((1-beta(k))*c1 + beta(k)*cpooled);
      model.sig1            = pinv( model.cov1 );
      
      tout = calc(model, train_features);
      
      [fp, tp, fn, tn] = count_classified(train_labels, tout);
      
      accuracy(k,l)  = ( tp + tn )/(tp + fp + tn + fn);
      
      if( ~isempty( test_labels ) )
	tout = calc(model, test_features);
	[fp, tp, fn, tn] = count_classified(test_labels, tout);
	oot_accuracy(k,l)  = ( tp + tn )/(tp + fp + tn + fn);
      end
      
    end
  end
    
    
  figure(11)
  subplot(1,2,1)
  imagesc(accuracy)
  colorbar
  title('train');
  
  subplot(1,2,2)
  imagesc(oot_accuracy)
  colorbar
  title('test');
  
     
  figure(12)
  subplot(1,2,1)
  surfc(accuracy)
  colorbar
  title('train');
  
  subplot(1,2,2)
  surfc(oot_accuracy)
  colorbar
  title('test');
  
  drawnow;
  
  
  [ Y, I ] = sort( -1.0*accuracy );
  
  model.beta = beta(I(1));
  
  model.cov0		= ((1-model.beta)*c0 + model.beta*cpooled);
  model.sig0            = pinv( model.cov0 );
  
  model.cov1		= ((1-model.beta)*c1 + model.beta*cpooled);
  model.sig1            = pinv( model.cov1 );
    
  if( entooldrawit )
    figure(12)
    plot(beta, accuracy);
    hold on;
    xlabel('beta')
    ylabel('accuracy');
    
    if( ~isempty( test_labels ) )
      plot(beta, oot_accuracy,'r');
    end
    hold off;
    drawnow;
    
  end
  
  model.trainparams = trainparams;
  model.eps = eps;
  
