function sampleclass = getsampleclass_balanced(bilder, nr_models, frac_test)
%
% function sampleclass = getsampleclass_balanced(bilder, nr_models, frac_test)
%
% Compute multiple column vectors of sampleclasses to train #nr_models models. These 
% column vectors are combined to a matrix of size length(bilder) by nr_models.
% The coding is as follows:
%
% A zero entry at position i indicates that the sample with index i belongs to the training set.
% Any other value indicates that this sample may not be used for training, not even for early stopping
% or any other kind of validation during the training!
%
% From all available samples, the testset is drawn randomly, but with 
% minimal mutual overlap between each pair of column vectors of sampleclass.
%
% The balncing is done in the way, that there are as many false positive (=1) as
% false negative (= -1) examples for classification in the training set !!!
% This is called class frequency normalization and leads to better
% classification results
% 
% Christian Merkwirth 2002
%
% Joerg Wichard 2004
  
  nr_samples = length(bilder);
  
  nr_positiv =  find( bilder >= 0.0 );
  nr_negativ =  find( bilder < 0.0 );
  
  if ( length(nr_positiv) > length(nr_negativ) )
    nr = length(nr_negativ);
  else
    nr = length(nr_positiv);
  end
  
  nr_test  = ceil(frac_test * nr);
  nr_train = (nr - nr_test);
  
  if nr_train < 1
    error('Fraction of test samples is too large');
  end
  
  disp(['The data set contains ' num2str(length(nr_positiv)) ' positive and ' ...
	num2str(length(nr_negativ)) ' negative examples']);
  disp(['In order to balance the data set, each partition contains ' num2str(2.0*nr_train) ' data points']);
  
  sampleclass = ones(nr_samples, nr_models); 
  
  for i=1:nr_models
    
    p_index = randperm(length(nr_positiv));
    n_index = randperm(length(nr_negativ));
    
    sampleclass(nr_positiv(p_index(1:nr_train)),i) = 0.0;
    sampleclass( nr_negativ(n_index(1:nr_train)),i) = 0.0;
  
  end
  
