function y = calc(model, urbilder)
%
% y = calc(model, urbilder)
%
% Joerg Wichard 2005
%
% Naive Bayes simply based on random guessing, 
% based on the Class-probabillity of the data
  
  
  pdfmat = gmmb_pdf(urbilder, model.bayesS);
  postprob = gmmb_normalize( gmmb_weightprior(pdfmat, model.bayesS) );
  tmp = gmmb_decide(postprob);
  
  %% Class Labels ändern 
  neg = find( tmp > 1 );
  
  y = ones(size(tmp));
  y(neg) = -1;
  
