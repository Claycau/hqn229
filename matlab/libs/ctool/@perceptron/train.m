function [ model ] = train( model, urbilder, bilder, sampleclass, trainparams, eps, varargin)
%
%
% function [ model ] = train(model, urbilder, bilder, sampleclass, trainparams, eps, varargin)
%
%
%   Train perceptron class training algorithm based on the Rprop.
%
%   See: C. Igel and M. Hüsken, "Improving the Rprop Learning Algoritm",
%        Proceedings of the 2. ICSC Int. Symposium on Neural Computation (NC 2000)
%        pp. 115-121, ICSC Academic Press, 2000
%
  
%% Joerg Wichard 2002

  global entooldrawit

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% Divide Data in Training and Test

  if isempty(trainparams)
    trainparams = get(model, 'trainparams');
  end
  
  model.eps = eps;
  
  nr_train = length(bilder);
  [ dummy, input_channels ] = size(urbilder);
  
  if ( nr_train ~= dummy )
    error('The number of images and the number of preimages differ');
  end
  
  if nargin > 6
    sampleweights = varargin{1};
  else
    sampleweights = ones(nr_train,1);
  end  
  
  
  [indtrain, indtest] = dissemble(sampleclass, nr_train);
  
  %% Scaling the Images and Pre-images
  [urbilder, uscalefacs] = scale_data(urbilder, model.data_scale, model.urbilder_scalefacs);
  [bilder, bscalefac]    = scale_data(bilder, model.data_scale, model.bilder_scalefac);
  
  model.urbilder_scalefacs = uscalefacs;
  model.bilder_scalefac    = bscalefac;
  
  %% Traindata
  urbilder_train = urbilder(indtrain,:);
  bilder_train   = bilder(indtrain);
  weights_train  = sampleweights(indtrain);
  
  %% Testdata
  urbilder_test = urbilder(indtest,:);
  bilder_test   = bilder(indtest);
  weights_test  = sampleweights(indtest);
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% Initialize Perceptron 
  
  [ m,n ] = size(  model.tmp_topo );
  if ( m ~= 1 ) 
    error('Inconsistent topologie-parameter for perceptron class');
  end 

  %% Topologie parameter
  model.topo = [ input_channels, model.tmp_topo, 1 ];
  model.layers = ( length(model.topo ) - 1);

  %% Initializing weights: Following Y. LeCun et al. 'Efficient BackProp' in 
  %% Orr and Müller 'Neural Networks, Tricks and Trade', Springer (1998)
  %%
  %% If a neuron has 'm' input-units, the weights are randomly drawn with zero mean
  %% and a stadard deviation of 1/sqrt(m).
  for l=1:model.layers 
    model.w{l}  = (1.0/sqrt((1+model.topo(l))))*randn( (1+model.topo(l)), model.topo(l+1) );
    
    if( model.linear_init )
      model.w{l}(1,1) = 1.0;
    end
    
  end	
  
  %% Calculating the scales error loss margin
  data_spread = ( max(max(urbilder_train)) - min(min(urbilder_train)) );
  epsi = (eps*data_spread);
  
  [ data_length, dummy ] = size(urbilder_train);
  
  %% Die Datenstructur zum Rprop bereitstellen
  for l=1:model.layers 
    %% Die Schrittweite des Gradientenabstiegs
    dw{l}     = (trainparams.mrate_init)*ones( (1+model.topo(l)), model.topo(l+1) );
    dw_old{l} = (trainparams.mrate_init)*ones( (1+model.topo(l)), model.topo(l+1) );
    dstep{l}  = (trainparams.mrate_init)*ones( (1+model.topo(l)), model.topo(l+1) );
    
    %% Die Gradienten 
    dold{l} = zeros( (1+model.topo(l)), model.topo(l+1) );
    dnew{l} = ones( (1+model.topo(l)), model.topo(l+1) );
    
    delta{l+1} = zeros( data_length, model.topo(l+1) );
    y{l+1} = zeros( data_length, model.topo(l+1) );
    xtmp{l+1} = zeros( data_length, ( 1 + model.topo(l+1) ));
    dev{l+1} = zeros( data_length, model.topo(l+1) );
  end
  
  xtmp{1}   = zeros( data_length, ( 1 + model.topo(1) ));
  y{1}      = ones( data_length, model.topo(1));
  dev{1}    = ones( data_length, model.topo(1));
  delta{1}  = zeros( data_length, model.topo(1));
  
  %% Trainings-daten
  xin   = urbilder_train;
  xreal = bilder_train;
  
  [ m, dummy ] = size( xin );
  
  %% Die verschiedenen Fehler
  terr = zeros(2,trainparams.rounds);
  
  %% Initialize the weights with the best linear fit !!!
  if( model.linear_init )
    
    xtemp = [ xin, model.offsett*ones(m,1) ];
    winit = (pinv(xtemp)*xreal);
    wtmp  = model.w{1};
    wtmp(:,1) = winit;
    
    %% Maximalgewicht
    itmp = find(  abs(wtmp) > trainparams.max_weight );
    wtmp(itmp) = 0.0;
    
    model.w{1} = wtmp;
    
  end
  
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%  Jitter 
  jitter_train = (0.1*randn(size(bilder_train)));
  jitter_test = (0.1*randn(size(bilder_test)));
  
  err_new = 0;
  for iter=1:trainparams.rounds
    
    x =  xin;
    xtmp{1} = [ x, model.offsett*ones(m,1) ];
    y{1} = x;
    dev{1} = ones(m,model.topo(1));

    for l=1:model.layers
      x = tanh(xtmp{l}*model.w{l}) + (model.linear_factor*(xtmp{l}*model.w{l}));
      xtmp{l+1} = [ x, model.offsett*ones(m,1)];
      y{l+1} = x;
      dev{l+1} = ( 1.0 - x.^2) + model.linear_factor*ones(size(x));
    end	
    
    %% Den Epsilon-Insensitiven-Fehler
    ecount = ( (abs( xreal - x )) > epsi );
    
    %% Der Fehler am Netzausgang 
    %% delta{(model.layers + 1)} = -(weights_train.*ecount).*((xreal - x) - epsi );
    delta{(model.layers + 1)} = -(weights_train.*ecount).*sign(xreal - x).*abs(abs(xreal - x) - epsi );
    
    
    err_old = err_new;
    err_new = (sum(delta{(model.layers + 1)}.^2));
    
    %% Den Fehler zurueckpropagieren
    for l=model.layers:-1:1
      delta{l} = (delta{(1+l)}*transpose(model.w{l}(1:(end-1),:))).*dev{l};
    end
    
    %% Den einzelnen Gradienten berechnen
    for l=1:model.layers
      dnew{l} = ( (transpose([ y{l}, model.offsett*ones(m,1) ])*delta{l+1} ) + ...
		  trainparams.decay*(model.w{l}./((1+model.w{l}.^2).^2)) );
    end 
    
    %% Den Gradienten berechnen
    for l=1:model.layers
      
      %% Die Richtungsinformation 
      dtmp = sign( dold{l} .* dnew{l} );
      
      %% Die alte Schrittweite, zum zurücknehmen
      dw_old{l} = dw{l}; 
      
      %% Die Schrittweite adaptieren
      dw{l} = (  trainparams.mrate_grow*( dw_old{l}.*(dtmp == 1)) ...
		 + trainparams.mrate_shrink*(dw_old{l}.*(dtmp == -1)) ...
		 + dw_old{l}.*(dtmp == 0) );
      
      %% Die Schrittweite festlegen, abhängig vom Fehler
      if ( err_new > err_old )
	
	dstep{l} = (    sign(dnew{l}).*( dw{l}.*(dtmp == 1)) ...
			+ sign(dnew{l}).*( dw{l}.*(dtmp == 0)) ...
			- dw_old{l}.*( dtmp == -1) );
      else
	dstep{l} = zeros( (1+model.topo(l)), model.topo(l+1) );
	
	dstep{l} = (    sign(dnew{l}).*( dw{l}.*(dtmp == 1)) ...
			+ sign(dnew{l}).*( dw{l}.*(dtmp == 0)) );
      end
      
      model.w{l} = (model.w{l} - dstep{l});
      
      %% Alte Gradienten abspeichern und beim Richtungswechsel die Ableitung Null setzen
      dold{l} = dnew{l};
      itmp = find( dtmp == -1 );
      dold{l}(itmp) = 0;
      
      %% Maximalgewicht
      itmp = find( model.w{l} > trainparams.max_weight );
      model.w{l}(itmp) = trainparams.max_weight;
      dold{l}(itmp) = 0;

      itmp = find( model.w{l} < -trainparams.max_weight );
      model.w{l}(itmp) = -trainparams.max_weight;
      dold{l}(itmp) = 0;
    end
    
    if ( entooldrawit )
      [ y_train ]   = calc_train( model, urbilder_train );
      terr(1,iter)  = (calc_error( bilder_train, y_train, epsi ));
      
      if( ~isempty(urbilder_test) )
	[ y_test ]    = calc_train( model, urbilder_test );
	terr(2,iter)  = (calc_error( bilder_test, y_test, epsi ));
      end
    end
    
    %%%
  %end
    
    if ( entooldrawit )
      
      %% Calculating the test-error
      [ y_train ] = calc_train( model, urbilder_train );
      trainerr = mean( (y_train - bilder_train).^2 );
      
      if( ~isempty(urbilder_test) )
	
	[ y_test ] = calc_train( model, urbilder_test );
	
	figure(1)
	clf;
	subplot(1,2,1);
	plot(terr(1,:));
	hold on;
	plot(terr(2,:),'r');
	axis square;
	grid on;
	
	subplot(1,2,2)
	plot([-1; 1],[-1; 1],'k');
	hold on;
	plot([(-1-epsi); (1-epsi)],[-1; 1],'k');
	plot([(-1+epsi); (1+epsi)],[-1; 1],'k');
	%plot(bilder_train,y_train,'.b');
	%plot(bilder_test,y_test,'.r');
	plot( (jitter_test + bilder_test), y_test,'.r');
	plot( (jitter_train + bilder_train), y_train,'.b');
	axis([-1 1 -1 1]);
	axis square;
	grid on;
	hold off;
	
	drawnow
	
      else
	figure(1)
	clf;
	subplot(1,2,1);
	plot(terr(1,:));
	hold on;
	plot(terr(2,:),'r');
	axis square;
	grid on;
	
	subplot(1,2,2)
	plot([-1; 1],[-1; 1],'k');
	hold on;
	plot([(-1-epsi); (1-epsi)],[-1; 1],'k');
	plot([(-1+epsi); (1+epsi)],[-1; 1],'k');
	plot(bilder_train,y_train,'.b');
	axis([-1 1 -1 1]);
	axis square;
	grid on;
	hold off;
	
	drawnow
      end
      
    end
    
  end

  model.trainparams = trainparams;
  model.eps = eps;
 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Calculating the epsilon insensitiv error

function [ err ] = calc_error( xreal, xout, epsi )

decide = abs( xreal - xout ) > epsi;

err = mean(( decide.*( abs(xreal - xout) - epsi )).^2);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Calc Model during the training, without scaling

function [ xout ] = calc_train( model, xin )

[ m, dummy ] = size( xin );

for l=1:model.layers
  xin = [ xin, model.offsett*ones(m,1) ];
  xin = (tanh(xin*model.w{l}) + model.linear_factor*(xin*model.w{l}));
end	

xout = xin;
