function [B, out] = MTD_histogram(eqh, varargin)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    N = size(eqh,1);
    out = nan(N);
    if size(eqh,2) == 3
        fprintf('SDR %d\n',N);
        for idx1 = 1:(N-1)
            fprintf('%d/%d\n',idx1,N);
            for idx2 = idx1+1:N
                out(idx1,idx2) = MTD_dcrotSDR(eqh(idx1,:),eqh(idx2,:));
            end
        end
    elseif size(eqh,2) == 4
        fprintf('axes TP %d\n',N);
        for idx1 = 1:(N-1)
            fprintf('%d/%d\n',idx1,N);
            for idx2 = idx1+1:N
                out(idx1,idx2) = MTD_dcrotTP(eqh(idx1,:),eqh(idx2,:));
            end
        end
    end
    B = reshape(out,[N*N 1]);
    B(isnan(B)) = [];
    B = B * 180 / pi;
    histogram(B,'Normalization','pdf')
end

