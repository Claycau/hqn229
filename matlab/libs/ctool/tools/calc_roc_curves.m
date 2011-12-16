function [ roc_out ] = calc_roc_curves( labels, zm )
%%
%%  [ roc_out ] = calc_roc_curves( labels, zm )
%%
%%  Calculate ROC curves by shifting the threshold in the ensemble vote
%%
  
%%  Joerg Wichard, 2005
  
  
  [ m, n ] = size(zm);
  
  roc_out = zeros((2*n+1),2); 
  
  count = 1;
  for k = -n:1:n
    
    decision = -1.0*ones(m,1);
    
    ind = find( sum(zm,2) >= k );
    decision(ind) = 1.0;
    
    [fp, tp, fn, tn] = count_classified( labels, decision )
    [ roc, varargout ] = calc_roc_values( fp, tp, fn, tn );

    %% False positiv rate
    roc_out(count,1) = roc.fp_rate;
    
    %% True positiv rate
     roc_out(count,2) = roc.recall;
   
    count = (count + 1);
    
  end
  
  plot([0.0:0.01:1.0],[0.0:0.01:1.0]);
  hold on;
  plot(roc_out(:,1),roc_out(:,2));
  hold off;
