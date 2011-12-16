function display(ens)
%
% display(x)
%
% Display content of ensemble object
%
% Christian Merkwirth & Joerg Wichard
  
  disp('Ensemble object:')
  disp(struct(ens))
  disp(' ')
  
  if length(ens.models)
    ans = input('Detailed list of constituting models ? (n/y)', 's');
    
    if strcmp(ans, 'y')
      more on
      disp('Constituting models:')
      for m=1:length(ens.models)
	disp(['Model Nr. ' num2str(m)]);
	display(ens.models{m});
	disp('Train errors'); 
	disp(ens.errors{m}.train);
	disp('Test errors'); 
	disp(ens.errors{m}.test);
	%disp('Total errors'); 
	%disp(ens.errors{m}.total);
      end
      more off
    else
      for m=1:length(ens.models)
	disp(['Model Nr. ' num2str(m) ' of type ' class(ens.models{m})])   
      end   
    end   
  end
  
