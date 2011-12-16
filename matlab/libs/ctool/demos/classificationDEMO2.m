
global entooldrawit
entooldrawit = 0;

%% Trainings Daten
Nx = 1000;
Ny = 2000;

x1 = 0.5*randn(Nx,5);
x2 = 0.75*randn(Ny,5);

shift1 = repmat([1,1,1,1,1],Nx,1);
shift2 = repmat([0.5,1.5,1.1,1.5,0.1],Ny,1);

x1 = shift1 + x1;
x2 = shift2 - x2;

train_urbilder = [ x1; x2 ];
train_bilder   = [ ones(size(x1,1),1); -1.0*ones(size(x2,1),1) ];



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

tp.modelclasses = {'flda', [], {};
     		   'pda', [], {};
   		   'logreg', [], {};
		   'gmm', [], {};
		   'boostensemble', [], {};
		   'perceptron', [], {}; 
 		   'vicinal2', [], {}; 
     		   'kridge', [], {}; 
  		   'dtree', [], {};
   		   'cvtree', [], {};
  		   'mlp', [], {};
  		   'svm', [], {'rbf',0,rand(1),0,10};
  		   'svm', [], {'rbf',1,rand(1),0,10};
  		   'svm', [], {'linear',0,rand(1),0,10};
  		   'adaboost', [], {20,2,'modest'};
 		   'adaboost', [], {20,2,'real'};
 		   'liblinear', [], {};
 		   'liblinear', [], {'l1reg_logreg',0.01};
 		   'liblinear', [], {'l1reg_logreg',0.1};
 		   'liblinear', [], {'l1reg_logreg',1};
 		   'liblinear', [], {'l1reg_logreg',10};
 		   'liblinear', [], {'l1reg_logreg',100};
 		   'liblinear', [], {'l2reg_logreg',0.01};
 		   'liblinear', [], {'l2reg_logreg',0.1};
 		   'liblinear', [], {'l2reg_logreg',1};
 		   'liblinear', [], {'l2reg_logreg',10};
 		   'liblinear', [], {'l2reg_logreg',100};
 		   'liblinear', [], {'l2reg_21loss_svm',0.01};
 		   'liblinear', [], {'l2reg_21loss_svm',0.1};
 		   'liblinear', [], {'l2reg_21loss_svm',1};
 		   'liblinear', [], {'l2reg_21loss_svm',10};
 		   'liblinear', [], {'l2reg_21loss_svm',100};
 		   'liblinear', [], {'l2reg_l1loss_svm',0.01};
 		   'liblinear', [], {'l2reg_l1loss_svm',0.1};
 		   'liblinear', [], {'l2reg_l1loss_svm',1};
 		   'liblinear', [], {'l2reg_l1loss_svm',10};
 		   'liblinear', [], {'l2reg_l1loss_svm',100};
 		   'liblinear', [], {'l1reg_l2loss_svm',0.01};
 		   'liblinear', [], {'l1reg_l2loss_svm',0.1};
 		   'liblinear', [], {'l1reg_l2loss_svm',1};
 		   'liblinear', [], {'l1reg_l2loss_svm',10};
 		   'liblinear', [], {'l1reg_l2loss_svm',100};
		  };

ens = train(ens, train_urbilder, train_bilder, [], tp, eps); 

%% Train Data

[train_out, zm ] = calc(ens, train_urbilder);

figure(3)
plot(train_bilder,'b.')
hold on;
plot(train_out,'ro')
title('train');
hold off;

disp('Over all Results');

[fp, tp, fn, tn] = count_classified( train_bilder, train_out );
[roc_train, etrain ]  = calc_roc_values( fp, tp, fn, tn );
disp(['train: ' num2str(etrain)]);
	
