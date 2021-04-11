
function [opp, ocv] = Estimate_smooth_gmm_grnn_parcv(ipp, frozen)
% Runtest using paralel computing
    opp = ipp;
    N = numel(opp.GRNN_inputs);
    if isfield(opp,'GRNN_smoothing_parameters')
        if N ~= numel(opp.GRNN_smoothing_parameters)
            error('Wrong number of GRNN smoothing parameters');
        end
    else
        opp.GRNN_smoothing_parameters = ones(N,1);
    end
    if nargin < 2
        frozen = zeros(size(opp.GRNN_smoothing_parameters));
    end
    initsigma = log10(opp.GRNN_smoothing_parameters(~frozen));
    options = optimset('MaxIter', 1000, 'TolFun', 1e-5, 'TolX',1e-6,'Display','off') ;
    [osigmas,ocv] = fminsearch(@(sigmas)compute_gmm_grnn_parcv_local(opp, sigmas, frozen), initsigma, options) ;
    opp.GRNN_smoothing_parameters(~frozen) = 10.0 .^ osigmas;

end
function ocv = compute_gmm_grnn_parcv_local(pp, sigmas, frozen)
    pp.GRNN_smoothing_parameters(~frozen) = 10.0 .^ sigmas;
    ocv = compute_gmm_grnn_parcv(pp,'verbose', 2);
end
% dane = ReadPGACSV('c:\Users\jwisz\Documents\GMPE\DorotaO\dane.csv');