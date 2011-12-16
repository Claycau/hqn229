%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Den Epsilon-loss Fehler berechnen

function [ err ] = calc_error( xreal, xout, parameters )

epsi = (parameters.error_loss_margin*parameters.data_spread);

decide = abs( xreal - xout ) > epsi;

err = mean(( decide.*( abs(xreal - xout) - epsi )).^2);

