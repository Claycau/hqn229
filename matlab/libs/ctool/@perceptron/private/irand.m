function xrand = irand(imin, imax)
%%
%%  xrand = irand(imin, imax)
%%
%% Integer Random Number Generator zwischen imin und imax
  
  
  xrand = floor(imin + (1.0 + imax - imin)*rand(1));