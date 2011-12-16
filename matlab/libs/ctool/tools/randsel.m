function r = randsel(v, nr)
  
% function r = randsel(v, nr)
%
% Randomly select one or more elements from vector v.
% By default, nr ist one. No element will be choosen
% more than once, however, if v contains identical
% elements, it is possible that also r has identical
% elements.
%
% Joerg Wichard and Christian Merkwirth
  
  if nargin < 2
    nr = 1;
  end
  
  if nr == 1
    r = v(ceil(rand*length(v)));
  else
    r = v(randperm(length(v)));
    r = r(1:min(nr,length(r)));
  end
  