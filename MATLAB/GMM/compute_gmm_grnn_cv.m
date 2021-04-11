% function [cv,oy_r,oy_e] = compute_gmm_grnn_cv(ip,...)
% Ground Motion Prediction Model
% General Regression Neural Network
% The function calculates the leave-one-event-out cross-validation (LOEOCV)
% Instead of removing one sample as in classical LOOCV,
% all samples of each event are removed.
% Inputs:
%   ip - input parameters
%     ip.data - data used for regression
%     ip.event_key - set of unique values to recognise the same event
%     ip.GRNN_outputs_set - value of ground motion
%     ip.GRNN_inputs - set of inputs metrics for input distances.
%        Each metric consists of fields:
%           inputs - set of input names in the ip.data
%           func - the name of the function to calculate the distance.
%                  If func is empty the Euclidean distance is computed
%     ip.GRNN_smoothing_parameters
% Outputs:
%   cv     - value for cross validation prediction risk
%   oy_r   - output real values
%   oy_e   - output estimated values
%
% (c) Jan Wiszniowki 2016.09.25
%
function [cv, oy_r, oy_e, dy_e] = compute_gmm_grnn_cv(ip,varargin)
    verbose = arparameters('verbose', 0, varargin{:});
    if verbose > 0
        fprintf('GRNN GMM: sigma=%f',ip.GRNN_smoothing_parameters(1))
        for idx = 2 : numel(ip.GRNN_smoothing_parameters)
            fprintf(', %f',ip.GRNN_smoothing_parameters(idx))
        end
        fprintf('\n')            
    end
    
    data = sortrows(ip.data,ip.event_key);
    grnn_pp = ip;
    N = length(data);

    [~,ia,ic] = unique(data,ip.event_key);
    no_events = length(ia);
    osse=0;
    oy_e = zeros(N,numel(ip.GRNN_outputs_set));
    dy_e = zeros(N,numel(ip.GRNN_outputs_set));
    for idx = 1:no_events
        idxes = (ic == idx);
        if verbose > 2
            fprintf('Compute %4d / %4d events; %d/%d records: ',idx,no_events, sum(idxes),N)
        end
        grnn_pp.data = data(~idxes,:);
        tst = data(idxes,:);
        [oy, dy] = sim_gmm_grnn(grnn_pp,tst);
        osse = osse + sum(sqr(dy));
        oy_e(idxes,:) = oy;
        dy_e(idxes,:) = dy;
        if verbose > 2
            fprintf('osse = %f\n',osse)
        end
    end
    cv = osse/N;
    if verbose > 1
        fprintf('For sigma = (%f',ip.GRNN_smoothing_parameters(1))
        for idx = 2 : numel(ip.GRNN_smoothing_parameters)
            fprintf(', %f',ip.GRNN_smoothing_parameters(idx))
        end
        fprintf(') cv = %f\n',cv)
    end
    oy_r = double(data(:,ip.GRNN_outputs_set));
end
