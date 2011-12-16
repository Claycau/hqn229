function results = logreg(y,x,betaone)
%Logistic regression using Marquadt's and interpolation schemes for optimizing parameter values.
%     If function run with only y and x variables, program uses ordinary linear
%     regression to generate initial parameter guess.  Alternatively, if
%     three input arguements, function expects third arguement to be a vector of initial
%     parameter estimates.


if nargin < 2 | nargin > 3 %checking correct number of input arguements
   error(sprintf(['     Incorrect number of input arguments.\n' ...
      '     Enter dependent vector, independent matrix, and initial parameter\n' ...
      '     guess vector (optional).']));
end

sizeofy = size(y); sizeofx = size(x); 	%creating "sizeof" variables to use in
																%shaping input matricies to compatible dimensions

if sizeofy(1)==1 %if y input as row vector change to column vector
   y=y';
end

if max(sizeofy)~=sizeofx(1) & max(sizeofy)==sizeofx(2) %check if x matrix has exp's in columns 
   x=x';																				%if so, transpose matrix
elseif max(sizeofy)~=sizeofx(1) %checking to make sure trial # equal for y and x
   error('Dependent and Independent data are not of correct sizes.');
end

if min((x(:,1)==1))==0	%need first column all ones for "constant" parameter
   x=[ones(max(sizeofy),1) x];	%checks if all ones; if not, adds column of ones
end

if nargin == 3	%if vector of parameter estimates supplied, makes sure it is a column vector
	sizeofbetaone = size(betaone);
	if sizeofbetaone(1)==1
      betaone=betaone';
   end
   if max(size(betaone))~=size(x,2)	%verifies user input parameter guess of correct size
      error('Parameter vector size does not match independent data matrix size.');
   end
else
   betaone=ordLS(y,x); %if parameter vector not input, generates one from OLS
   end

maxiter=30; %maximum iteration number
lambda=0.01;
J=1;
convergence_marker = 0;
iter = 1;	%current iteration number
beta=betaone;	%creates vector of parameters for updating without overwriting user's guess
%betaparameters(1,:)=betaone';
if length(beta)>1
   while iter<=maxiter
      for i=1:length(beta),	%creates vector of first derivatives of log liklihood function
         gradient_vector(i) = sum(x(:,i).*(y-logistic(beta,x))); %logistic is my function
      end
      if size(gradient_vector,1)==1	%makes sure gradient vector is a column vector
         gradient_vector=gradient_vector';
      end
      for i=1:length(beta), %creates Hessian matrix of second partial derivatives
         for j=1:length(beta),
            H(i,j)=sum(-1*x(:,i).*x(:,j).*logistic(beta,x)./(1+exp(x*beta)));
         end
      end
      [estbeta, lambda, J] = marquardt(y,x,H,gradient_vector, beta, J, lambda);
      error1 = ((beta) + eps)*1e-4; %error tolerance calculated relative to parameter values
      error2 = sum(abs(y-logistic(beta,x)));
      if max(abs((estbeta-beta))<error1)==1 %if all parameter errors less than tolerance, halts,
         convergence_marker = 1;
         sprintf('Parameter estimates have become stable.\n');
         %disp(['Convergence obtained after ',num2str(iter-1),' iterations.']);%reports convergence,
         odds=loglikelihood(y,x,beta);
         break
      elseif abs(sum(abs(y-logistic(estbeta,x)))-error2)<=1e-5
         sprintf('Residual values not declining.\n')
         disp(['Process halted after ',num2str(iter-1),' iterations.']);%reports failure,
         odds=loglikelihood(y,x,beta);
         convergence_marker=1;
         break
      end
      beta = estbeta;
      iter=iter+1;	%increments iteration counter
      %betaparameters(iter,:)=estbeta';
   end
   if iter-1==maxiter
      results={};
      disp(['Failed to converge after ',num2str(maxiter),' iterations.']);
      beta %displays parameter estimate if halted due to number of iterations
   end
else
   odds = length(find(y==1))*log(length(find(y==1))) + ...
      length(find(y==0))*log(length(find(y==0))) - length(y)*log(length(y));
   disp(['Loglikelihood for constant only model is: ',num2str(odds)]);
   results(1,1)={'Log Likelihood'};
   results(1,2)={'Beta Values'};
   results(2,1)={odds};
   results(2,2)={beta};
end
if (convergence_marker)
   cov_mat = (-1*H)\eye(length(H));
   stderr = sqrt(diag(cov_mat));
   beta_se = beta./stderr;
   results(1,1)={'Log Likelihood'};
   results(1,2)={'  Beta Values'};
   results(1,3)={' SE '};
   results(1,4)={'Beta/S.E.'};
   results(1,5)={'Odd''s Ratio'};
   results(1,6)={'       95% CI'};
   results(2,1)={odds};
   results(2,2)={beta};
   results(2,3)={stderr};
   results(2,4)={beta_se};
   results(2,5)={exp(beta)};
   results(2,6)={[exp(beta-1.96*stderr) exp(beta+1.96*stderr)]}; 
   %print_logreg(results);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Weiter benötigte Funktionen:
% ordLS
function beta = ordLS(y,x)	
%subfunction for ordinary least squares estimates

beta=(x'*x)\x'*y;
   

% marquardt
function [beta, lambda, J] = marquardt(y,x,H,gradient_vector, beta, J, lambda)
%relies on result that correct direction vector can be determined from
%     positive definite matrix and that positive definite matrix can result
%     from adding "large enough" pos. def. matrix to any arbitrary matrix.
%     The scaling variable implicitly affects the step size, however, if
%     this does not lead to a useful improvement in liklihood, marquardt fxn
%     utilizes in interpolation function.

v = createv(H,gradient_vector,lambda);
tempbeta = beta + v;
phi = loglikelihood(y,x,tempbeta);
check = (phi>loglikelihood(y,x,beta));
if check
   beta = tempbeta;
   lambda = max(.1*lambda,1e-7);
   J=J;
else
   while (v'*gradient_vector)^2/(norm(gradient_vector)^2*norm(v)^2)<1/2
      lambda = 10*lambda;
      v = createv(H,gradient_vector,lambda);
      tempbeta = beta + v;
      phi = loglikelihood(y,x,tempbeta);
      check = (phi>loglikelihood(y,x,beta));
      if check
         beta = tempbeta;
         lambda = max(.1*lambda,1e-7);
         break
      end
   end
end
if ~check
   [J, beta] = interpolate(y, x, H, gradient_vector, beta, J, lambda);
end

% logistic
function value = logistic(beta,ex)	
%function to compute logistic-called by logreg function
value = exp(ex*beta)./(1+exp(ex*beta));

% interpolate
function [J, beta] = interpolate(y, x, H, gradient_vector, beta, J, lambda)
%function called by marquardt function, which is used in logreg function
%     the scaling variable in marquardt implicitly affects scaling size
%     but if that doesn't yield correct step, lambda is adjusted and use
%     interpolation/extrapolation scheme for adjusting step size larger and
%     smaller. Relies on quadratic approximation to liklihood function.

rhomax=1; rhomin=0.0001;psi(1) = 0;psi(2) = 0; psi(3) = 1e-30;
%creates max and min step sizes, the large psi value is just to guarantee that
%while loop kicks in on first cycle it is called

rho(1) = 2^(-J)*min(1,rhomax); %initial step estimate
v = createv(H,gradient_vector,lambda); %initial direction vector
gamma = gradient_vector'*v;
psi(1) = loglikelihood(y,x,beta+rho(1)*v);%calc likelihood with new estimated parameters
rhostar = gamma*rho(1)^2/(2*(gamma*rho(1) + loglikelihood(y,x,beta) - psi(1)));

if psi(1)>loglikelihood(y,x,beta)%is fit improved?
   J = J/2;
   if rhostar<=0
      rhostar = 2*rho(1);
   end
   rho(2) = min(rhostar, rhomax);
   rhodiff = abs(rho(2) - rho(1));
   if rhodiff<=0.1*rho(1)
      rhotouse = rho(1);
   else
      psi(2) = loglikelihood(y,x,beta +rho(2)*v); %if so, see if slightly larger step in
      if psi(2)>psi(1)												%direction even better, if so, use it
         rhotouse = rho(2);
      else
         rhotouse = rho(1);%if not stick with original
      end
   end
   beta = beta + rhotouse*v;
   return
else
   rho(2)=rho(1); %otherwise shrink step size, but if below min, abort
   rho(3) = max(0.25*rho(2), min(0.75*rho(2),rhostar));
   if rho(3)<rhomin
      beta = beta;
      return
   end
end
while psi(3) < loglikelihood(y,x,beta) %while liklihood in direction v is worse than
   psi(3) = loglikelihood(y,x,beta + rho(3)*v);  %prior estimate shrink step size and
   J=J+1;																	%try again
   if psi(3)>loglikelihood(y,x,beta)
      rhotouse = rho(3);
      beta=beta+rho(3)*v;
      break
   else
   rho(2) = rho(3);
   rhostar = gamma*rho(2)^2/(2*(gamma*rho(2) + loglikelihood(y,x,beta) - psi(3)));
   rho(3) = max(0.25*rho(2), min(0.75*rho(2),rhostar));
      if rho(3)<rhomin
         beta = beta;
         break
      end
   end
end

% createv
function direction = createv(H,gradient_vector,lambda)
%function used by logreg to create a direction vector for the parameter fitting.
%     Adds the absolute values of the diagonal elements of the hessian back to itself
%     after scaling by lambda.  Uses theorem that any arbitray matrix can
%     be made positive definite (which is important in securing a proper direction
%     vector) by adding a "large enough" positive definite matrix to it.
b=abs(diag(H));  %find absolute values of diagonal of Hessian
for i=1:length(b), %replace any zeros with ones
   if b(i)==0
      b(i)=1;
   end
end
B=diag(b); %Make diagonal matrix to add back to hessian after scaling
R=(H+lambda*B); %add to hessian after scaling by lambda
direction =-R\gradient_vector; %determine direction vector

% loglikelihood
function loghood = loglikelihood(y,x,beta)
%calculates the loglikelihood for a logistic relationship between
%     y and x variable governed by parameter vector beta
loghood = sum(y.*log(logistic(beta,x))+(1-y).*log(1-logistic(beta,x)));

% print_logreg
function print_logreg(array_name)
%function written to print logistic regression results in consistent format
%     uses a cell array as input
fprintf('\n\n\t%s\t%9.3f\n',array_name{1,1},array_name{2,1}); %Log Lokelihood
fprintf('\n\t%s\t%s\t%s\t%s\t%s\t%s\n','   ',array_name{1,2},array_name{1,3}, ...
    array_name{1,4},array_name{1,5},array_name{1,6}); %Überschrift
%fprintf('\n');
for i=1:length(array_name{2,2}),
      fprintf('\t\t\t%7.3f\t\t%.2f\t%7.3f\t\t%7.3f\t\t(%8.4f - %8.4f)\n', ...
         array_name{2,2}(i),array_name{2,3}(i),array_name{2,4}(i), ... 
         array_name{2,5}(i),array_name{2,6}(i,1),array_name{2,6}(i,2))
end
fprintf('\n\n')


%Britt Anderson
%June 5, 2001

%References
%Bard, Y. Nonlinear Parameter Estimation. Academic Press, NY, 1974.
%Hosmer, DW, & Lemeshow S. Applied Logistic Regression. John Wiley & Sons, NY, 1989.