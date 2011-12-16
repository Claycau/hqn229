function [model, urbilder, bilder] = compute_scalefactors(model, urbilder, bilder)

% function model = compute_scalefactors(model, urbilder, bilder)
%
% Christian Merkwirth 2002
%
% Joerg Wichard 2004

[urbilder, uscalefacs] = scale(urbilder);
[bilder, bscalefac] = scale(bilder);

model.uscalefacs = uscalefacs;
model.bscalefac = bscalefac;
