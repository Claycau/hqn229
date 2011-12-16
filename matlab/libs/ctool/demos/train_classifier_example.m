
%% Example Script for a standard classification with ctool
%%  
%% ctool performs only binary classification !!!
%% Note that the class lables must be -1 and 1 
%%

%% FLAG for debugging output: entooldrawit = 1
global entooldrawit
entooldrawit = 0;

%% seed for random number generator
rand('state',sum(100*clock));

%%%%%%%%%%%%%%%%%%%%%%%%%%%   LOAD YOUR DATA  

%% training data
Xraw_train     = load('train.data');
Xlabel_train   = load('train.labels');

train_urbilder = Xraw_train;
train_bilder   = Xlabel_train;

%% validation data (not used for model training)
Xraw_valid   = load('valid.data');
Xlabel_valid = load('valid.labels');

valid_urbilder = Xraw_valid;
valid_bilder   = Xlabel_valid;

%%%%%%%%%%%%%%%%%%%%%%%%%%%  TRAINING THE ENSEMBLE MODEL

%% Parameter for the eps-insensitive squared loss function
eps = 0.05;

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
				
%% Here you decide, which models are trained and tested in each CV-Partition
%% You can shrink the number of models in order ro make the training faster,
%% for example:
%% 
%% tp.modelclasses = { 'flda', [], {}; 
%%                     'pda', [], {}; 
%%                     'kridge', [], {}; 
%%                     'dtree',  [], {};
%%                   };
%%
%% Here comes a rather enhanced and detailed list:
    
tp.modelclasses = {
%   Fischer's Linear Discriminat analysis
    'flda', [], {};
%   Penalized Discriminant Analysis
    'pda', [], {};  
%   Ridge Linear
    'kridge', [], {};   
%   Gaussian Mixture Model
    'gmm', [], {};   
%   Logistic Regression
    'logreg', [], {};   
%   Adaboost
    'adaboost', [], {20,1,'real'};
    'adaboost', [], {20,1,'gentle'};
    'adaboost', [], {30,1,'real'};
    'adaboost', [], {30,1,'gentle'};
    'adaboost', [], {40,1,'real'};
    'adaboost', [], {40,1,'gentle'};
    'adaboost', [], {50,1,'real'};
    'adaboost', [], {50,1,'gentle'};
    'adaboost', [], {60,1,'real'};
    'adaboost', [], {60,1,'gentle'}
    'adaboost', [], {70,1,'real'};
    'adaboost', [], {70,1,'gentle'}
    'adaboost', [], {80,1,'real'};
    'adaboost', [], {80,1,'gentle'}
    'adaboost', [], {100,1,'real'};
    'adaboost', [], {100,1,'gentle'};
%  Multi Layer Perceptron
    'perceptron', [], {};
    'mlp', [], {};
    'mlp', [], {};
    'mlp', [], {};
    'mlp', [], {};
    'mlp', [], { randsel([ 5, 7, 12])};
    'mlp', [], { randsel([ 10, 14, 25])};
    'mlp', [], { randsel([ 15, 17, 21])};
    'mlp', [], { randsel([ 13, 14, 15])};
    'mlp', [], { randsel([ 10, 12, 15])};
    'mlp', [], { [ randsel([ 10, 12, 15]) randsel([ 3, 5, 7]) ] };
    'mlp', [], { [ randsel([ 5, 10, 20 ]) randsel([ 5, 7, 9]) ] };
    'mlp', [], { randsel([ 15, 17, 25 ])};
    'mlp', [], { randsel([ 10, 12, 15])};
    'mlp', [], { [ randsel([ 10, 12, 15]) randsel([ 3, 5, 7]) ] };
    'mlp', [], { [ randsel([ 5, 10, 20 ]) randsel([ 5, 7, 9]) ] };
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
%  K-Nearest Neighbor Models
    'vicinal2'  [], {};
%  Support Vector Machines
    'svm'  [], {};
    'svm', [], {'rbf',0,10*rand(1),0,10};
    'svm', [], {'rbf',1,10*rand(1),0,10};
    'svm', [], {'rbf',0,rand(1),0,10};
    'svm', [], {'rbf',1,rand(1),0,10};
    'svm', [], {'rbf',0,10*rand(1),0,100};
    'svm', [], {'rbf',1,10*rand(1),0,100};
    'svm', [], {'rbf',0,rand(1),0,100};
    'svm', [], {'rbf',1,rand(1),0,100};
    'svm', [], {'rbf',0,10*rand(1),0,1000};
    'svm', [], {'rbf',1,10*rand(1),0,1000};
    'svm', [], {'rbf',0,rand(1),0,1000};
    'svm', [], {'rbf',1,rand(1),0,1000}; 
    };

%% Train the model
ens = train(ens, train_urbilder, train_bilder, [], tp, eps); 

%% Calculate the classification model on the training data
%% train_out: The ensemble output
%% zm:        The output of the single ensemble members
[train_out, zm ] = calc(ens, train_urbilder);

disp('Results');

[fp, tp, fn, tn] = count_classified( train_bilder, train_out );
[roc_train, etrain ]  = calc_roc_values( fp, tp, fn, tn );
disp('train-data:  accuracy    precision   recall    fscore   fp_rate  specificity  ber');
disp(['train-data: ' num2str(etrain)]);


%% Calculate the classification model on the validation data
[valid_out, zm ] = calc(ens, valid_urbilder);

[fp, tp, fn, tn] = count_classified( valid_bilder, valid_out );
[roc_valid, evalid ]  = calc_roc_values( fp, tp, fn, tn );
disp('valid-data: accuracy    precision   recall    fscore   fp_rate  specificity  ber');
disp(['valid-data: ' num2str(evalid)]);

