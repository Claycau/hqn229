function [y, scalefactors] = scale(x, varargin)

% [y, scalefactors] = scale(x)
% y = scale(x, scalefactors)
% 
% Scales each column of input x to [-1 1].
% 
% JDW 2004

[N,M] = size(x);

if nargin > 1
  scalefactors = varargin{1};
else
  scalefactors(1,:) = min(x);
  scalefactors(2,:) = max(x) - min(x);
  
  scalefactors(2,find(scalefactors(2,:) == 0)) = inf;
end

for j=1:M
  y(:,j) = x(:,j) - repmat(scalefactors(1,j), N,1);
  y(:,j) = y(:,j) ./ repmat(scalefactors(2,j), N,1);
end

y = 2*y - 1;

y(:,find(scalefactors(2,:) == inf)) = 0;
