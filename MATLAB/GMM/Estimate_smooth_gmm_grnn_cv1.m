function [opp, ocv] = Estimate_smooth_gmm_grnn_cv1(ipp, frozen)
%function [opp, ocv] = Estimate_smooth_gmm_grnn_cv1(ipp, frozen)
% The function estimates the values of the smoothness coefficients
% of the General Regresion Neural Network (GRNN) Ground Motion Model (GMM)
% by the leave-one-out cross-validation (LOOCV)
% Inputs:
%  ipp - input parameters
%     (see compute_gmm_grnn_cv1)
%  frosen - table of frozen - not changeable smoothness coefficients
%     1 - frozen (not used in optimization), 0 - being optimized
%     the table size must be the same as ipp.GRNN_smoothing_parameters
% Output:
%  opp - optimal parameters
%  ocv - optimal LOESOCV value
%
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
    [osigmas,ocv] = fminsearch(@(sigmas)compute_gmm_grnn_cv1_local(opp, sigmas, frozen), initsigma, options) ;
    opp.GRNN_smoothing_parameters(~frozen) = 10.0 .^ osigmas;

end
function ocv = compute_gmm_grnn_cv1_local(pp, sigmas, frozen)
    pp.GRNN_smoothing_parameters(~frozen) = 10.0 .^ sigmas;
    ocv = compute_gmm_grnn_cv1(pp,'verbose', 2);
end
