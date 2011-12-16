%   The algorithms implemented by Alexander Vezhnevets aka Vezhnick
%   <a>href="mailto:vezhnick@gmail.com">vezhnick@gmail.com</a>
%
%   Copyright (C) 2005, Vezhnevets Alexander
%   vezhnick@gmail.com
%   
%   This file is part of GML Matlab Toolbox
%   For conditions of distribution and use, see the accompanying License.txt file.


function [Learners, Weights, final_hyp] = GentleAdaBoost(WeakLrn, Data, Labels, Max_Iter, OldW, OldLrn, final_hyp)

global GE_min;

if( nargin == 4)
  Learners = {};
  Weights = [];
  distr = ones(1, length(Data)) / length(Data);  
  final_hyp = zeros(1, length(Data));
elseif( nargin > 5)
  Learners = OldLrn;
  Weights = OldW;
  if(nargin < 7)
      final_hyp = Classify(Learners, Weights, Data);
  end
  distr = exp(- (Labels .* final_hyp));  
  distr = distr / sum(distr);  
else
  error('Function takes eather 4 or 6 arguments');
end


for It = 1 : Max_Iter
  
  %chose best learner

  nodes = train(WeakLrn, Data, Labels, distr);

  for i = 1:length(nodes)
    curr_tr = nodes{i};
    
    step_out = calc_output(curr_tr, Data);
      
    s1 = sum( (Labels ==  1) .* (step_out) .* distr);
    s2 = sum( (Labels == -1) .* (step_out) .* distr);

    if(s1 == 0 && s2 == 0)
        continue;
    end
    Alpha = 0.5 * log((s1 + eps)/ (s2 + eps));

    Weights(end+1) = Alpha;
    
    Learners{end+1} = curr_tr;
    
    final_hyp = final_hyp + step_out .* Alpha;    
  end
  
  distr = exp(- 1 * (Labels .* final_hyp));
  Z = sum(distr);
  distr = distr / Z;  

end
