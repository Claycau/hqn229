function [dim, tr, signum] = get_dim_and_tr(tree_node)

dim = tree_node.dim;



if( length(tree_node.right_constrain) > 0)
  tr = tree_node.right_constrain;
  signum = -1;
end
if( length(tree_node.left_constrain) > 0)
  tr = tree_node.left_constrain;
  signum = +1;
end