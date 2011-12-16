function model = svm(varargin)
%%
%%
%%
%%
%%  Joerg D. Wichard  2005
%%

%%  libsvm_options:
%%  -s svm_type : set type of SVM (default 0)
%%         0 -- C-SVC
%%         1 -- nu-SVC
%%         2 -- one-class SVM
%%         3 -- epsilon-SVR
%%         4 -- nu-SVR
%%  -t kernel_type : set type of kernel function (default 2)
%%         0 -- linear: u'*v
%%         1 -- polynomial: (gamma*u'*v + coef0)^degree
%%         2 -- radial basis function: exp(-gamma*|u-v|^2)
%%         3 -- sigmoid: tanh(gamma*u'*v + coef0)
%%  -d degree : set degree in kernel function (default 3)
%%  -g gamma : set gamma in kernel function (default 1/k)
%%  -r coef0 : set coef0 in kernel function (default 0)
%%  -c cost : set the parameter C of C-SVC, epsilon-SVR, and nu-SVR (default 1)
%%  -n nu : set the parameter nu of nu-SVC, one-class SVM, and nu-SVR (default 0.5)
%%  -p epsilon : set the epsilon in loss function of epsilon-SVR (default 0.1)
%%  -m cachesize : set cache memory size in MB (default 40)
%%  -e epsilon : set tolerance of termination criterion (default 0.001)
%%  -h shrinking: whether to use the shrinking heuristics, 0 or 1 (default 1)
%%  -b probability_estimates: whether to train a SVC or SVR model for probability estimates, 0 or 1 (default 0)
%%  -wi weight: set the parameter C of class i to weight*C, for C-SVC (default 1)
%%  -v n: n-fold cross validation mode
  
  
%%  -s svm_type 
  model.s = 0;
  
  %%  set the default model to linear
  model.t = 0;
  model.kernel = 'linear';
  model.d = 0;
  model.g = 1;
  model.r = 0;
  model.c = 1;
  
  if nargin >= 1
    switch lower(varargin{1})
     case 'linear'
      model.t = 0;
      model.kernel = 'linear';
     case 'poly'
      model.t = 1;
      model.kernel = 'poly';
     case 'rbf'
      model.t = 2;
      model.kernel = 'rbf';
     case 'sigmoid'
      model.t = 3;
      model.kernel = 'sigmoid';
     otherwise
      model.t = 0;
      model.kernel = 'linear';
    end
  end
  
  %%  -d degree
  model.d = randsel([ 0, 1 ]);
  if nargin >= 2
    model.d = varargin{2};
  end
  
  %%  -g gamma
  model.g = randsel([ 0.001, 0.01, 0.1 1 ]);
  if nargin >= 3
    model.g = varargin{3};
  end
  
  %%  -r coef0
  model.r = randsel([ 0, 1 ]);
  if nargin >= 4
    model.r = varargin{4};
  end
  
  %%  -c cost
  model.c = randsel([ 1, 10, 100, 1000]);
  if nargin >= 5
    model.c = varargin{5};
  end
  
  %% Creating the Options-String
  model.options = ['-s ' num2str(model.s) ... 
		   ' -t ' num2str(model.t) ... 
		   ' -d ' num2str(model.d) ...
		   ' -g ' num2str(model.g) ...
		   ' -r ' num2str(model.r) ...
		   ' -c ' num2str(model.c) ];
  
  %% The Output of svm-train
  model.svm = {};

  %% The scaling factors
  model.scalefactors = {};
  
  %% The training parameters
  model.trainparams = {};
  
  model.eps = 0.0;
   
  model = class(model, 'svm' );
  

  

