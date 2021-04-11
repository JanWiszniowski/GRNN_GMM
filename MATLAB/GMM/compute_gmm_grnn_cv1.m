% function [cv,oy_r,oy_e] = compute_gmm_grnn_cv1(ip,...)
% Ground Motion Preduction Equation
% General Regression Neural Network
% The function calculates the leave-one-out cross-validation (LOOCV)
% Inputs:
%   ip - input parameters
%     ip.data - data used for regression
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
%   oy_e   _ output estimated values
%
% (c) Jan Wiszniowki 2016.09.25
function [cv, oy_r, oy_e, dy_e] = compute_gmm_grnn_cv1(ip,varargin)
    verbose = arparameters('verbose', 0, varargin{:});
    if verbose > 0
        fprintf('GRNN GMM: sigma=%f',ip.GRNN_smoothing_parameters(1))
        for idx = 2 : numel(ip.GRNN_smoothing_parameters)
            fprintf(', %f',ip.GRNN_smoothing_parameters(idx))
        end
        fprintf('\n')            
    end
    
    data = ip.data;
    grnn_pp = ip;
    N = size(data,1);
    osse=0;
    oy_e = zeros(N,numel(ip.GRNN_outputs_set));
    dy_e = zeros(N,numel(ip.GRNN_outputs_set));
    for idx = 1:N;
        if verbose > 2
            fprintf('Compute %d/%d records: ',idx,N)
        end
        grnn_pp.data = data;
        grnn_pp.data(idx,:) = [];
        tst = data(idx,:);
        [oy, dy] = sim_gmm_grnn(grnn_pp,tst);
        osse = osse + sum(sqr(dy));
        oy_e(idx,:) = oy;
        dy_e(idx,:) = dy;
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
