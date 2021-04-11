
function [opp, ocv] = Estimate_GA_smooth_gmm_grnn_cv(ipp, lb, ub)% Runtest
    opp = ipp;
    N = numel(opp.GRNN_inputs);
    if isfield(opp,'GRNN_smoothing_parameters')
        if N ~= numel(opp.GRNN_smoothing_parameters)
            error('Wrong number of GRNN smoothing parameters');
        end
    else
        opp.GRNN_smoothing_parameters = ones(N,1);
    end
    nvars = length(ipp.GRNN_inputs);
    lb = log10(lb)
    ub = log10(ub)
%    initsigma = log10(opp.GRNN_smoothing_parameters(~frozen));
%     options = optimset('MaxIter', 1000, 'TolFun', 1e-5, 'TolX',1e-6,'Display','off') ;
    gaopt = gaoptimset('UseParallel',true);
%    [osigmas,ocv] = ga(@(sigmas)compute_gmm_grnn_cv_local(opp, sigmas, frozen), nvars, [], [], [], [], lb, ub) ;
    [osigmas,ocv] = ga(@(sigmas)compute_gmm_grnn_cv_local(opp, sigmas), nvars, [], [], [], [], lb, ub) ;
%    [osigmas,ocv] = ga(@(sigmas)compute_gmm_grnn_cv_local(opp, sigmas, frozen), nvars) ;
    opp.GRNN_smoothing_parameters = 10.0 .^ osigmas;

end
function ocv = compute_gmm_grnn_cv_local(pp, sigmas)
    pp.GRNN_smoothing_parameters = 10.0 .^ sigmas;
    ocv = compute_gmm_grnn_cv(pp,'verbose', 2);
end
% dane = ReadPGACSV('c:\Users\jwisz\Documents\GMPE\DorotaO\dane.csv');