function [ output ] = computeR2(pp)
% R^2 ceofficeint of determination coeputed from ground motion data
    [cv, oy_r, oy_e, dy_e] = compute_gmm_grnn_cv(pp,'verbose',2);
    output =  1 - sum(sqr(oy_e - oy_r)) / sum(sqr(oy_r - mean(oy_r)));
end

