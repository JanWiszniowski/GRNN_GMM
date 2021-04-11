function [out] = MTD_histogramNxN(eqh, varargin)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    N = size(eqh,1);
    out = nan(N);
    if size(eqh,2) == 3
        fprintf('SDR %d\n',N);
        for idx1 = 1:N
            fprintf('%d/%d\n',idx1,N);
            for idx2 = 1:N
                out(idx1,idx2) = MTD_dcrotSDR(eqh(idx1,:),eqh(idx2,:));
            end
        end
    elseif size(eqh,2) == 4
        fprintf('axes TP %d\n',N);
        for idx1 = 1:N
            fprintf('%d/%d\n',idx1,N);
            for idx2 = 1:N
                out(idx1,idx2) = MTD_dcrotTP(eqh(idx1,:),eqh(idx2,:));
            end
        end
    end
    out = out * 180 / pi;
end

