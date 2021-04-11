% function [cv,oy_r,oy_e] = compute_gmm_grnn_cv0S(ip,...)
% Ground Motion Prediction Model
% General Regression Neural Network
% Calculates Cross-Validation (CV)
% Instead of removing one sample as in classical CV,
% all samples of one event and one station are removed.
% The method is called OESO (One Event and one Station Out) CV
% Inputs:
%   ip - input parameters
%     ip.data - data used for regression
%     ip.event_key - unique values to recognise the same event
%     ip.station_key -  unique values to recognise the same statation
%     ip.GRNN_outputs_set - value of ground motion
%     ip.GRNNdist_set - GMPE inputs for non Euclidean distance with
%                       distance function
%     ip.GRNN_smoothing_parameters
% Outputs:
%   cv     - value for cross validation prediction risk
%   oy_r   - output real values
%   oy_e   - output estimated values
%
% (c) Jan Wiszniowki 2016.09.25
%
function [cv] = compute_gmm_grnn_cv0S(ip,varargin)
    verbose = arparameters('verbose', 0, varargin{:});
    if verbose > 0
        fprintf('GRNN GMM: sigma=%f',ip.GRNN_smoothing_parameters(1))
        for idxsp = 2 : numel(ip.GRNN_smoothing_parameters)
            fprintf(', %f',ip.GRNN_smoothing_parameters(idxsp))
        end
        fprintf('\n')            
    end
    
    data1 = sortrows(ip.data,ip.event_key);
%     grnn_pp = ip;
    N = length(data1);
    [~,ia0,ic0] = unique(data1, ip.event_key);
    [~,iaS,icS] = unique(data1, ip.station_key); 
    no_events = length(ia0);
    no_stations = length(iaS);
    oN = zeros(no_stations,1);
    osse = zeros(no_stations,1);
    data = cell(no_stations,1);
    for idxS = 1:no_stations 
        data{idxS} = data1;
    end
    parfor idxS = 1:no_stations 
        idxesS = (icS == idxS);
        for idx0 = 1:no_events
            idxes0 = (ic0 == idx0);
            idxes = idxes0 | idxesS ;
            if verbose > 2
                fprintf('Compute %4d / %4d events, %4d / %4d stations; %d,%d,%d/%d records: ',idx0, no_events, idxS, no_stations, sum(idxesS), sum(idxes0), sum(idxes),N)
            end
            grnn_pp = ip;
            grnn_pp.data = data{idxS}(~idxes,:);
            tst = data{idxS}(idxes,:);
            [~, dy] = sim_gmm_grnn(grnn_pp,tst);
            osse(idxS) = osse(idxS) + sum(sqr(dy));
            oN(idxS) = oN(idxS) + length(dy);
            if verbose > 2
                fprintf('osse = %f\n',osse(idxS)/oN(idxS))
            end
        end
    end
    cv = sum(osse)/sum(oN);
    if verbose > 1
        fprintf('For sigma = (%f',ip.GRNN_smoothing_parameters(1))
        for idx = 2 : numel(ip.GRNN_smoothing_parameters)
            fprintf(', %f',ip.GRNN_smoothing_parameters(idx))
        end
        fprintf(') cv = %f\n',cv)
    end
end
