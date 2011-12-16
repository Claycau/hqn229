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

if(length(Weights) == 0)
    ME_min = 999999;
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
    Alpha = (s1 - s2) / (s1 + s2);

    Weights(end+1) = Alpha;
    
    Learners{end+1} = curr_tr;
    
    final_hyp = final_hyp + step_out .* Alpha;    
  end
  
%   h_best = 999999999999999999;
%   i_best = 0;
%   for h = 1 : length(Learners) - 1
%       lrn_out = calc_output(Learners{h}, Data);
%       lrn_hyp = (lrn_out == 1) .* Weights(2 * h - 1) + (lrn_out == -1) .* Weights(2 * h);
%       lrn_hyp = (final_hyp - lrn_hyp);
%       h_err = -sum(Labels.*lrn_hyp) / sum(abs(lrn_hyp));
%       if(h_err < h_best)
%           h_best = h_err;
%           i_best = h;
%       end
%   end
%     
%   if(h_best < ME_min)
%     Weights(2 * i_best) = 0;
%     Weights(2 * i_best - 1) = 0;
%     final_hyp = Classify(Learners, Weights, Data);
%   end
  
  % recalculate distribution
%   ME_min = min(ME_min, -sum(Labels .*final_hyp)) / sum(abs(final_hyp));
  distr = exp(- 1 * (Labels .* final_hyp));
  Z = sum(distr);
  distr = distr / Z;  

end
