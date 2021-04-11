
function [opp, ocv] = Estimate_smooth_gmm_grnn_cv0S(ipp, frozen)
%function [opp, ocv] = Estimate_smooth_gmm_grnn_cv0S(ipp, frozen)
% Funkcja estymuje wartosci wspolczynnikow gladkosci
% GRNN GMM optymalizujac
% one event and one station out crosvalidation (OESO cv)
% Inputs:
%  ipp - input parameters
%     (see compute_gmm_grnn_cv0S)
%  frosen - table of frozen - not changeable coefficients
%     1 - frozen, 0 - optimised
%     the table size must be the same as ipp.GRNN_smoothing_parameters
% Output:
%  opp - optimal parameters
%  ocv - optimal OESO cv
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
    [osigmas,ocv] = fminsearch(@(sigmas)compute_gmm_grnn_cv0S_local(opp, sigmas, frozen), initsigma, options) ;
    opp.GRNN_smoothing_parameters(~frozen) = 10.0 .^ osigmas;

end
function ocv = compute_gmm_grnn_cv0S_local(pp, sigmas, frozen)
    pp.GRNN_smoothing_parameters(~frozen) = 10.0 .^ sigmas;
    ocv = compute_gmm_grnn_cv0S(pp,'verbose', 3);
end
% dane = ReadPGACSV('c:\Users\jwisz\Documents\GMPE\DorotaO\dane.csv');