function [B, out] = MTD_histogram2(eqh, varargin)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    N = size(eqh,1);
    out = nan(N);
    verbose = arparameters('verbose', false, varargin{:});
    if size(eqh,2) == 3
        fprintf('SDR %d\n',N);
        for idx1 = 1:(N-1)
            if verbose
                fprintf('%d/%d\n',idx1,N)
            end
            for idx2 = idx1+1:N
                if any(isnan([eqh(idx1,:),eqh(idx2,:)]))
                    fprintf('Pair %d %d ignored. NaN values\n',idx1,idx2)
                else
                    out(idx1,idx2) = kagan(eqh(idx1,:),eqh(idx2,:));
                end
            end
        end
    elseif size(eqh,2) == 4
        error('input must be Nx3 (SRD)')
    end
    B = reshape(out,[N*N 1]);
    B(isnan(B)) = [];
    histogram(B,'Normalization','pdf')
end

