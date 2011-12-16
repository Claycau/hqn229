function [ sdata, scalefactors ] = scale_data(data, data_scale, old_scale)
%%
%%     [ sdata ] =  scale_data(data, data_scale, old_scale) 
%%
%%      Scales the Data to the Interval, given in data_scale
%%
  
  [ dm, dn ] = size(data_scale);
  if ( (dn ~= 2) | (dm ~= 1) )
	error('scale_image_data: Error ! Inkonsisten Scale-Factors');
  end
  
  smin = data_scale(1);
  smax = data_scale(2);
  
  if ( smin > smax )
	error('scale_image_data: Error (2) ! Inkonsisten Scale-Factors');
  end
  
  [ m, n ] = size(data);
  
  if ( isempty( old_scale ) )
    
    xmin = min(data);
    xmax = max(data);
    
    %% Falls es konstanten Input gibt
    xdiff = abs(xmax-xmin);
    inan  = find( xdiff <= eps );
    xdiff(inan) = 1.0;
    
  else
    
    xmin  =  old_scale(1,:);
    xmax  =  old_scale(2,:);
    xdiff = abs(xmax-xmin);
    
    inan  = find( xdiff <= eps );
    xdiff(inan) = 1.0;
    
  end
    
  %% Normiert auf [ 0 1 ]
  sdata = ( (data - repmat(xmin,m,1)) ./ (repmat( (xdiff), m, 1 ) ) );
  
  %% Normiert auf [ xmin xmax ]
  sdata = (  ((smax-smin)*sdata) + smin*ones(size(data)) );
  
  %% Die alten Werte uebernehmen
  scalefactors = [ xmin; xmax ];

  
  
