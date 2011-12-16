function classifierS = newgmmb(Ptrain, Ttrain, tyyppi, parameters);
%NEWGMMB - Create classifierS struct with GMMBayes project methods
%
% classifierS = drfwnewgmmb(data, class, cl_type [, parameters])
%   data    samples-by-dimensions matrix of data points
%   class   samples-by-1 vector class labels (integers 1..K)
%   cl_type classifier type, field in classifierS
%   parameters are delegated directly to gmmb_create().
%
% classifierS will have three fields:
%   bayesS         the bayesS struct as returned by gmmb_create
%   numOfClasses   number of classes used in training
%   type           an arbitrary value given as parameter cl_type
%
% See also GMMB_CREATE
%
% Author: Pekka Paalanen <pekka.paalanen@lut.fi>
%
% V_0_1
% newgmmb.m,v 1.2 2004/02/25 13:21:56 paalanen Exp

bayesS = gmmb_create(Ptrain, Ttrain, parameters{:});
classifierS = struct(...
	'bayesS', bayesS, ...
	'numOfClasses', length(bayesS), ...
	'type', tyyppi ...
	);
