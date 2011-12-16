%   The algorithms implemented by Alexander Vezhnevets aka Vezhnick
%   <a>href="mailto:vezhnick@gmail.com">vezhnick@gmail.com</a>
%
%   Copyright (C) 2005, Vezhnevets Alexander
%   vezhnick@gmail.com
%   
%   This file is part of GML Matlab Toolbox
%   For conditions of distribution and use, see the accompanying License.txt file.


function Result = Classify(Learners, Weights, Data)

Result = zeros(1, size(Data, 2));

for i = 1 : length(Weights)
  lrn_out = calc_output(Learners{i}, Data);
  Result = Result + lrn_out * Weights(i);
end