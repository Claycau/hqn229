function [ stats ] = analyse_class_distribution( X, Y )
%%
%%  [ stats ] = analyse_class_distribution( X, Y )
%%
%%  Given the descriptors of two classes X and Y 
%%  the statistics concerning the distribution is shown
%%
  
  stats = [];
  
  [ lx, nx ] = size(X);
  [ ly, ny ] = size(Y);
  
  if( nx ~= ny )
    error('Dimensionsmust agree');
  end
  
  meanx = mean(X);
  meany = mean(Y);
  
  medx = median(X);
  medy = median(Y);
  
  varx = var(X);
  vary = var(Y);
  
  figure(1)
  title('Center of Mass in X and Y');
  subplot(3,1,1)
  plot(meanx,'b')
  hold on;
  plot(meany,'r');
  legend('mean X','mean Y');
  hold off;
  
  subplot(3,1,2)
  plot(medx,'b')
  hold on;
  plot(medy,'r');
  legend('median X','median Y');
  hold off;
 
  subplot(3,1,3)
  plot(varx,'b')
  hold on;
  plot(vary,'r');
  legend('variaz X','variaz Y');
  hold off;
  
  %%%%%%%%%%%% Analyzing distances
  
  dx = sqrt( sum( ( (X - repmat(meanx,lx,1)).^2),2) );
  dy = sqrt( sum( ( (Y - repmat(meany,ly,1)).^2),2) );

  figure(2)
  title('Distributions of distances');
  subplot(2,1,1)
  hist(dx,50)
  xlabel('xdistances');
  subplot(2,1,2)
  hist(dy,50)
  xlabel('Class Y: Distances');
  
