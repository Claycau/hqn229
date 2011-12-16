function [ zmean, zvar ] = variable_importance(model, urbilder, bilder )
%
% [ zmean, zvar ] = variable_importance(model, urbilder, bilder )
%
%
% Joerg Wichard - 2005
%
  
  nr_repetitions = 3;
  
  [N, D] = size(urbilder);

  [ z ] = calc(model, urbilder);
  [fp, tp, fn, tn ] = count_classified( bilder, z);
  [roc_all, iall ]  = calc_roc_values( fp, tp, fn, tn );
  
  zmean = zeros(D, size(iall,2));
  zvar  = zeros(D, size(iall,2));
  
  for d=1:D
    
    error_tmp = zeros(nr_repetitions,size(iall,2));
    
    for r=1:nr_repetitions
      
      u = urbilder;
      
      u(:,d) = u( randperm( size(u,1)), d);    
      
      [ z ] = calc(model, u);
      
      [fp, tp, fn, tn] = count_classified( bilder, z);
      [roc_all, eall ]  = calc_roc_values( fp, tp, fn, tn );
      
      disp([ num2str(d), ' ', num2str(r),  ' ', num2str(eall) ] );
      
      error_tmp(r,:) = eall;
      
    end    
    
    zmean(d,:) = iall- mean(error_tmp);
    zvar(d,:)  = var(error_tmp);
   
  end
    
    
