function [fp, tp, fn, tn] = count_classified( des, is )
%
%  [fp, tp, fn, tn] = count_classified( des, is )
%
%  Count classified objects
% 
%  Input:  
%          des: desired labels
%          is:  model output (not necessary class labels !!)
%
%
%  Output: 
%          fp: False positive
%          tp: True positive
%          fn: False negative
%          tn: True negative
%
%  
  
%  J. Wichard 2004
%% Thanks to Ramin Norousi for correcting the fp/fn
  
  
%% Labels werden gesetzt auf -1 1 
%% Decision Boundery ist 0.0
  
  islabeled = ones(size(is));
  index = find( is < 0.0 );
  islabeled(index) = -1.0;
  
  deslabeled = ones(size(des));
  index = find( des < 0.0 );
  deslabeled(index) = -1.0;
  
  %%  fp: False positive
  fp = nnz( (islabeled ~= deslabeled).*(deslabeled < 0) );
  
  %%  tp: True positive
  tp = nnz( (islabeled == deslabeled).*(deslabeled > 0) );
  
  %%  fn: False negative
  fn = nnz( (islabeled ~= deslabeled).*(deslabeled > 0) );
  
  %%  tn: True negative
  tn = nnz( (islabeled == deslabeled).*(deslabeled < 0) );
  