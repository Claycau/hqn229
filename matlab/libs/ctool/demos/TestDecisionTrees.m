
%% FLAG for debugging output: entooldrawit = 1
global entooldrawit
entooldrawit = 0;

%% Generate TOY Example
%% Trainings Data

train_m = randn(1000,15);

train_m(:,5) = train_m(:,1)+train_m(:,2)+train_m(:,3);

%% Generating Input-Variables (train_urbilder)
train_urbilder = train_m(:,2:end);

%% Generating Class-Lables (train_bilder)
%% Class Labels must be -1 and 1 !!!

train_bilder = train_m(:,1);
train_urbilder = train_m(:,2:end);
train_index = find( train_bilder < 1.0 );
train_bilder = ones(size(train_bilder));
train_bilder(train_index) = -1.0;


%% Parameter for the eps-insensitive squared loss function
eps = 0.0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Next, do a five-fold cross-validation (tp.nr_cv_partitions=5) 
%% with 25% (tp.frac_test = 0.25) test samples (75% training samples) for each
%% fold. For each fold, all models listed in 'tp.modelclasses' are trained
%% and the best performing model is selected for the final ensemble

%% Now we define the model class (classifierensemble)
ens = classifierensemble;

%% Get the trainings parameter of the classifierensemble ...
tp = get(ens, 'trainparams');

%% ... and modify the parameters to fit your needs

%% Here you decide how many ensemble members you will have
%% It's the same as the number of cv-partitions
tp.nr_cv_partitions = 5;     

%% Here you define which part of the training set will be used
%% as test set during the cv-training
tp.frac_test = 0.25;

%% Here you define the performance measure that is used for selecting
%% the models for the final ensemble. Alternatives are:
%%  tp.scoring = 'accuracy' 
%%  tp.scoring = 'precision'
%%  tp.scoring = 'recall'          (sensitivity)
%%  tp.scoring = 'fscore'          (F-measure) 
%%  tp.scoring = 'fp_rate'         (false positive rate or false alarm rate)
%%  tp.scoring = 'specificity' 
%%  tp.scoring = 'ber'             (Balanced Error Rate)
tp.scoring = 'accuracy';
			

tp.modelclasses = {
%   Cross-Validated CART (Decision Trees)
    'cvtree',  [], {};
%  CART (Decision Trees)
    'dtree',  [], {5};
    'dtree',  [], {7};
    'dtree',  [], {9};
    'dtree',  [], {11};
    'dtree',  [], {13};
    'dtree',  [], {15};
    'dtree',  [], {21};
    'dtree',  [], {31};
    'dtree',  [], {41};
    'dtree',  [], {};
    		  };

%% Train the model
ens = train(ens, train_urbilder, train_bilder, [], tp, eps); 

%% Calculate the classification model on the training data
%% train_out: The ensemble output
%% zm:        The output of the single ensemble members
[train_out, zm ] = calc(ens, train_urbilder);

disp('Results');
disp('train-data: accuracy  precision   recall     fscore   fp_rate     specificity  ber');
[fp, tp, fn, tn] = count_classified( train_bilder, train_out );
[roc_train, etrain ]  = calc_roc_values( fp, tp, fn, tn );
disp(['train-data: ' num2str(etrain)]);


