function [ roc, varargout ] = calc_roc_values( fp, tp, fn, tn )
%%
%%  [ roc, varargout ] = calc_roc_values( fp, tp, fn, tn )
%%
%%  calculate the ONE-POINT ROC (Receiver Operation Characteristics) 
%%  for the binary Classifier
%%
%%  Input:
%%
%%         fp: False positive
%%         tp: True positive
%%         fn: False negative
%%         tn: True negative
%%
%%  Output:
%%
%%  roc.accuracy 
%%  roc.precision
%%  roc.recall          (sensitivity)
%%  roc.fscore          (F-measure) 
%%  roc.fp_rate         (false positive rate or false alarm rate)
%%  roc.specificity 
%%  roc.ber             (Balanced Error Rate)
%%
%%  varargout = [ accuracy, precision, recall, fscore, fp_rate, specificity, ber ]
%%
%% Joerg D. Wichard 2005
  
  %% 
  accuracy  = ( tp + tn )/(tp + fp + tn + fn);
  if ( (tp+fp) > 0 )
    precision = (tp/(tp+fp));
  else
    precision = NaN;   %% Null oder Nan, das ist die Frage
    warning('No positive examples could be found to calculate precision rate !');
  end
  
  %% recall = sensitivity
  if( (tp+fn) > 0 )
    recall    = (tp/(tp+fn));
  else
    recall    = 0;
    disp(num2str([tp, fn]));
    warning('No positive examples could be found to calculate recall !');
  end
  
  if( (recall + precision) > 0 )
    fscore    = ( 2.0*recall*precision )/(recall + precision);
  else
    fscore    = 0.0;
    warning('No fscore defined !');
  end

  if ( (tn+fp) > 0 )
    fp_rate      = fp/(tn+fp);
    specificity  = tn/(tn+fp);
  else
    fp_rate      = NaN;
    specificity  = NaN;
    warning('No negative examples to calculate alarm-rate and  specificity !');
  end
  
  %% Balanced Error Rate
  if( ((tn+fp) > 0) &  ((fn+tp) > 0 ) )
    matthews = 0.5*(tn/(tn+fp) + tp/(fn+tp));
  else
    matthews = NaN;
  end
  
  roc.accuracy    = accuracy;
  roc.precision   = precision;
  roc.recall      = recall;
  roc.fscore      = fscore;
  roc.fp_rate     = fp_rate;
  roc.specificity = specificity;
  roc.matthews    = matthews;

  if ( nargout > 1 ) 
    varargout = {[ accuracy, precision, recall, fscore, fp_rate, specificity, matthews ]};
  end
