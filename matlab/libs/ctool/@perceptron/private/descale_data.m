function [ sdata ] = descale_data(data, data_scale, old_scale)
%%
%%     [ sdata ] =  descale_data(data, data_scale, old_scale) 
%%
%%      Rescales the Data to the Interval, given in data_scale
%%
  
  [ dm, dn ] = size(data_scale);
  
  smin = data_scale(1,:);
  smax = data_scale(2,:);
  
  if ( smin > smax )
	error('descale_data: Error ! Inconsistent Scale-Factors');
  end
  
  [ m, n ] = size(data);
  
  xmin = old_scale(1)*ones(1,n);
  xmax = old_scale(2)*ones(1,n);
  
  xdiff = abs(xmax-xmin);
  
  inan  = find( xdiff <= eps );
  xdiff(inan) = 1.0;
  
  %% Normiert auf [ 0 1 ]
  sdata = ( (data - repmat(xmin,m,1)) ./ (repmat( (xdiff), m, 1 ) ) );
  
  %% Normiert auf [ xmin xmax ]
  scale = repmat((smax-smin),m,1);
  sdata = (  (scale.*sdata) + repmat((smin),m,1) );

  
  
  
  
  
  
  
  
