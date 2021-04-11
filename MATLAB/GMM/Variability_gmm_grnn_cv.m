
function [ocv] = Variability_gmm_grnn_cv(ipp, frozen, values)% Runtest
    opp = ipp;
    N = numel(opp.GRNN_inputs);
    if isfield(opp,'GRNN_smoothing_parameters')
        if N ~= numel(opp.GRNN_smoothing_parameters)
            error('Wrong number of GRNN smoothing parameters');
        end
    else
        opp.GRNN_smoothing_parameters = ones(N,1);
    end
    N = size(values,1)
    ocv = zeros(N,1);
    parfor idx = 1:N
        lpp = ipp;
        lpp.GRNN_smoothing_parameters(~frozen) = values(idx,:);
        ocv(idx) = compute_gmm_grnn_cv(lpp,'verbose', 2);
    end
end
