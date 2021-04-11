function [ R ] = R2_gmm_grnn( pp,cv )
#function [ R ] = R2_gmm_grnn( pp,cv )
# Compute coefficient of determination R^2 from CV (cv) and GM data (pp) 
y = double(pp.data(:, pp.GRNN_outputs_set)); 
R = 1 - cv ./ sum(sqr(y - mean(y,1)),1) * size(y,1);
end

