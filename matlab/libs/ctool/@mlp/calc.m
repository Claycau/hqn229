function [ xout ] = calc( model, xin )
%%
%%  [ xout ] = calc( model, xin )
%%
%%  Calculate mlp
%%

[ m, dummy ] = size( xin );

if ~isempty(xin)
  %% Scale data 
 [ xin, scalefactor ] = scale_data(xin, model.data_scale, model.urbilder_scalefacs);
end

for l=1:model.layers
  xin = [ xin, model.offsett*ones(m,1) ];
  xin = (tanh(xin*model.w{l}) + model.linear_factor*(xin*model.w{l}));
end	

% Bring output back to original scaling and give classification labels -1,1
%xout = sign(descale_data( xin,  model.bilder_scalefac, model.data_scale ));

%% Bring output back to original scaling and give continous values
xout = fastlincut(descale_data( xin,  model.bilder_scalefac, model.data_scale ));

