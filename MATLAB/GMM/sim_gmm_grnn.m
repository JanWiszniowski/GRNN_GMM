function [out_Y, out_dY] = sim_gmm_grnn(grnndata, tst)
% function [out_Y, out_dY] = sim_gmm_grnn(grnndata, testdata, varargin)
% Simulate the improved GRNN, Ouput is applaying the IGRNN biult
% of grnndata on the testdata.
% Inputs:
%   grnndata - input parameters
%       grnndata.data - data used for regression
%       grnndata.outputs_set - values of ground motion
%       grnndata.GRNN_inputs - struct - GMPE inputs for both
%           Euclidean (empty distance function),
%           and non Euclidean distance with non empty distance function
%   tst - test data (the same form as in grnndata.data)

%    verbose = arparameters('verbose', false, varargin{:});
    
    % For GRNN
    grnn_F = grnndata.GRNN_inputs;
    N_grnn_F = numel(grnn_F);
    for idx = 1:N_grnn_F
        grnn_F(idx).X = double(grnndata.data(:,grnn_F(idx).inputs));
    end
    grnn_Y = double(grnndata.data(:,grnndata.GRNN_outputs_set));
    
    % For test
    tst_F = struct('X',cell(size(grnn_F)));
    for idx = 1:N_grnn_F
        tst_F(idx).X = double(tst(:,grnn_F(idx).inputs));
    end
    tst_Y = double(tst(:,grnndata.GRNN_outputs_set));
    out_Y = zeros(size(tst_Y));

    sigma2 = sqr(grnndata.GRNN_smoothing_parameters);
    M = size(grnn_Y,1);
    d = zeros(M, N_grnn_F);
    for oidx = 1:size(tst_Y,1) 
        for idx = 1:N_grnn_F
            s2 = sigma2(idx);
            testX = tst_F(idx).X(oidx,:); 
            trainX =grnn_F(idx).X;
            if isempty(grnn_F(idx).func)
                if size(tst_F(idx).X,2) == 1
                    d(:,idx) = sqr(trainX - testX) ./ s2 ;
                else
                    for idx1 = 1:M % Adding row by row
                        d(idx1,idx) = sum(sqr(trainX(idx1,:) - testX)) ./ s2;
                    end
                end                        
            else
                if isfield(grnn_F(idx),'varargin')
                    if isempty(grnn_F(idx).varargin)
                        d(:,idx) = feval(grnn_F(idx).func, trainX, testX) ./ s2;
                    else
                        d(:,idx) = feval(grnn_F(idx).func, trainX, testX, grnn_F(idx).varargin{:}) ./ s2;
                    end
                else
                    d(:,idx) = feval(grnn_F(idx).func, trainX, testX) ./ s2;
                end
            end
        end

        K = exp(-sum(d,2)) + 1e-6/M;
        sumK = sum(K);
        out_Y(oidx,:) = sum(grnn_Y .* K, 1) / sumK;
    end
    out_dY = out_Y-tst_Y;
end
