function [ output ] = compute1R2(pp)
% R^2 ceofficeint of determination computed from ground motion data
    [cv, oy_r, oy_e, dy_e] = compute_gmm_grnn_cv1(pp,'verbose',2);
    output =  1 - sum(sqr(oy_e - oy_r)) / sum(sqr(oy_r - mean(oy_r)));
end

