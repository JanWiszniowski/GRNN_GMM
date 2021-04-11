% function [cv,oy_r,oy_e] = compute_gmm_grnn_cv(ip,...)
% Ground Motion Prediction Model
% General Regression Neural Network
% Calculates Cross-Validation (CV) usin paralel computing
% Instead of removing one sample as in classical CV,
% all samples of each event are removed.
% The method is called OEO (One Event Out) CV
% Inputs:
%   ip - input parameters
%     ip.data - data used for regression
%     ip.event_key - unique values to recognise the same event
%     ip.GRNN_outputs_set - value of ground motion
%     ip.GRNNdist_set - GMPE inputs for non Euclidean distance with
%                       distance function
% Outputs:
%   cv     - value for cross validation prediction risk
%   oy_r   - output real values
%   oy_e   - output estimated values
%
% (c) Jan Wiszniowki 2016.09.25
%
function [cv, oy_r, oy_e, dy_e] = compute_gmm_grnn_parcv(ip,varargin)
    verbose = arparameters('verbose', 0, varargin{:});
    if verbose > 0
        fprintf('GRNN GMM: sigma=%f',ip.GRNN_smoothing_parameters(1))
        for idx = 2 : numel(ip.GRNN_smoothing_parameters)
            fprintf(', %f',ip.GRNN_smoothing_parameters(idx))
        end
        fprintf('\n')            
    end
    data = sortrows(ip.data,ip.event_key);
    N = length(data);

    [~,ia,ic] = unique(data,ip.event_key);
    no_events = length(ia);
    osse=0;
    oy_e = zeros(N,numel(ip.GRNN_outputs_set));
    dy_e = zeros(N,numel(ip.GRNN_outputs_set));
    tst = cell(no_events,1);
    oy = cell(no_events,1);
    dy = cell(no_events,1);
    grnn_pp = cell(no_events,1);
    for idx = 1:no_events
        idxes = (ic == idx);
        tst{idx} = data(idxes,:);
        grnn_pp{idx} = ip;
        grnn_pp{idx}.data = data(~idxes,:);
    end
    parfor idx = 1:no_events
        if verbose > 2
            fprintf('Compute %4d / %4d events; %d/%d records\n',idx,no_events, sum(idxes),N)
        end
        [oy{idx}, dy{idx}] = sim_gmm_grnn(grnn_pp{idx},tst{idx});
    end
    for idx = 1:no_events
        idxes = (ic == idx);
        osse = osse + sum(sqr(dy{idx}));
        oy_e(idxes,:) = oy{idx};
        dy_e(idxes,:) = dy{idx};
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
