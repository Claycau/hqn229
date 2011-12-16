function y = calc(model, urbilder)
%
% y = calc(model, urbilder)
%
% Joerg Wichard 2004

N = size(urbilder,1);

%% Berechnung der Klassenzugehörigkeit = Nähe zum Cluster-Zentrum

y = zeros(N,1);

tmp0 = log(sum(diag( model.cov0 )));
tmp1 = log(sum(diag( model.cov1 )));

for k=1:N
  
  ma0 = ( urbilder(k,:) - transpose(model.mean0) );
  ma1 = ( urbilder(k,:) - transpose(model.mean1) );
  
  skv0 = (ma0*model.sig0*transpose(ma0));
  skv1 = (ma1*model.sig1*transpose(ma1));
  
  p0  = ( model.pi0 - 0.5*tmp0 - 0.5*skv0 );
  p1  = ( model.pi1 - 0.5*tmp1 - 0.5*skv1 );
  
  y(k) = sign( p1 - p0 );
  
end
