function [ model ] = train(model, urbilder, bilder, sampleclass, trainparams, eps, varargin)
%
% function [ model ] = train(model, urbilder, bilder, sampleclass, trainparams, eps, varargin)
%
% Simple straight-forward cross-validation for scaled classifier ensembles
%
% Joerg Wichard 2004
%
  
  global entooldrawit;
  
  mean_select = 1;
  
  if isempty(trainparams)
    trainparams = get(model, 'trainparams');
  end
  
  %% Scoring Function for Classification
  switch(lower( trainparams.scoring ))
   case 'accuracy'
    spos = 1;
   case 'precision'
    spos = 2;
   case 'recall'
    spos = 3;
   case 'fscore'
    spos = 4;
   case 'fp_rate'
    spos = 5;
   case 'specificity'
    spos = 6;
   case 'matthews'
    spos = 7;
   otherwise
    warning(['Scoring function ', trainparams.scoring, ' is not defined, using fscore instead']);
    trainparams.scoring = 'fscore';
    spos = 4;
  end
  
  
  nr_samples          = length(bilder);
  nr_model_classes    = size(trainparams.modelclasses,1);
  [indtrain, indtest] = dissemble(sampleclass, nr_samples);
  
  model.urbilder = urbilder(indtrain,:);
  model.bilder   = bilder(indtrain);
  
  urbilder = urbilder(indtrain,:);
  bilder   = bilder(indtrain);
  
  %% Compute scale factors only on training data !
  [model.ensemble, urbilder, bilder] = compute_scalefactors(model.ensemble, urbilder, bilder);
 


  
  msampleclass = getsampleclass(bilder, trainparams.nr_cv_partitions, trainparams.frac_test);
  %msampleclass = getsampleclass_balanced(bilder, trainparams.nr_cv_partitions, trainparams.frac_test);
  
  for i=1:trainparams.nr_cv_partitions  
    
    thismodel     = {};
    thiserr       = struct([]);   %% Fehler der Klassifizierung
    
    for j=1:nr_model_classes 
     
      
      [thismodeltrain, thismodeltest] = dissemble(msampleclass(:,i), length(bilder));
      
      disp(['Cross-validation training on train/test partition ' num2str(i)])    
            
      modelclass   = trainparams.modelclasses{j,1};
      mtrainparams = trainparams.modelclasses{j,2};
      minitparams  = trainparams.modelclasses{j,3}; 
      
      m = feval(modelclass, minitparams{:});
      
      if isempty(mtrainparams)
	mtrainparams = get(m, 'trainparams');
      end
      
      try  
	m = train(m, urbilder, bilder, msampleclass(:,i), mtrainparams, eps);
      catch
	disp(['An error occured while training ' modelclass ', model will be discarded']);
	disp(lasterr);
	m = [];
      end
      
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      if ~isempty(m)
	
	thismodel{j} = m;

	%% Trainingset
	ztrain                            = calc(m, urbilder(thismodeltrain,:));
	[fp, tp, fn, tn]                  = count_classified(bilder(thismodeltrain), ztrain);
	[thiserr{j}.train, temp ]         = calc_roc_values( fp, tp, fn, tn );
	etrain(j,:) = temp;
	
	%% Testset
	ztest                             = calc(m, urbilder(thismodeltest,:));
	[fp, tp, fn, tn]                  = count_classified(bilder(thismodeltest), ztest);
	[thiserr{j}.test,  temp ]         = calc_roc_values( fp, tp, fn, tn );
	etest(j,:)  = temp;
	
	%% Total
	ztotal                            = calc(m, urbilder);
	[fp, tp, fn, tn]                  = count_classified(bilder, ztotal);
   	[thiserr{j}.total, temp ]         = calc_roc_values( fp, tp, fn, tn );
	etotal(j,:) = temp; 
	
	if ( entooldrawit )
	  disp(['Trained ' modelclass ' model:']);
	  disp('Total errors'); 
	  disp(thiserr{j}.total);
	  disp('Train errors'); 
	  disp(thiserr{j}.train);
	  disp('Test errors'); 
	  disp(thiserr{j}.test);
	else
	  disp(['Trained ' modelclass ' model:']);
	  disp('Errors on Total/Train/Test Data');
	  disp('accuracy    precision   recall    fscore   fp_rate  specificity  matthews'); 
	  disp( [etotal(j,:); etrain(j,:); etest(j,:)] );
	end
	
      else
 	%% if no model was succesfully trained, create the simple linear model
 	modelclass   = 'flda';
 	m = feval(modelclass);
 	m = train(m, urbilder, bilder, msampleclass(:,i), mtrainparams, eps);
 
	thismodel{j} = m;

		%% Trainingset
	ztrain                            = calc(m, urbilder(thismodeltrain,:));
	[fp, tp, fn, tn]                  = count_classified(bilder(thismodeltrain), ztrain);
	[thiserr{j}.train, temp ]         = calc_roc_values( fp, tp, fn, tn );
	etrain(j,:) = temp;
	
	%% Testset
	ztest                             = calc(m, urbilder(thismodeltest,:));
	[fp, tp, fn, tn]                  = count_classified(bilder(thismodeltest), ztest);
	[thiserr{j}.test,  temp ]         = calc_roc_values( fp, tp, fn, tn );
	etest(j,:)  = temp;
	
	%% Total
	ztotal                            = calc(m, urbilder);
	[fp, tp, fn, tn]                  = count_classified(bilder, ztotal);
   	[thiserr{j}.total, temp ]         = calc_roc_values( fp, tp, fn, tn );
	etotal(j,:) = temp; 
	
	if ( entooldrawit )
	  disp(['Trained ' modelclass ' model:']);
	  disp('Total errors'); 
	  disp(thiserr{j}.total);
	  disp('Train errors'); 
	  disp(thiserr{j}.train);
	  disp('Test errors'); 
	  disp(thiserr{j}.test);
	else
	  disp(['Trained ' modelclass ' model:']);
	  disp('Errors on Total/Train/Test Data');
	  disp('accuracy    precision   recall    fscore   fp_rate  specificity  matthews'); 
	  disp( [etotal(j,:); etrain(j,:); etest(j,:)] );
	end
	
     end
   end
   
   %% Den Fehler auf den Test Daten extrahieren
   testerrors = zeros(1,nr_model_classes);
   for j=1:nr_model_classes 
     testerrors(j) = etest(j,spos);  %%%%
   end
   
   nsel = min([mean_select,nr_model_classes]);
  
   [Y,I] = sort(-1.*testerrors);
   best_model = I(1:nsel);
   
   for j=1:nsel
     
     %% Ensemble Gewichtet mit dem Testfehler
     model.ensemble=addmodel(model.ensemble,thismodel(best_model(j)),testerrors(best_model(j)),thiserr{best_model(j)});
    
     disp(testerrors(best_model(j)));
     
     model.sampleclasses = [model.sampleclasses msampleclass(:,i)];
   end
  end
  
  model = set(model, 'eps', eps);
  %model = set(model, 'trainparams', trainparams);
  
  
