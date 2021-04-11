%function [ ndist ] = GRNN_Euclidean (x, y, varargin)
%
% Compute squred Euclidean distances
% ndist(idx) = sum(sqr(x(idx,:) - y));
% Inputs:
%   x - array  [x(1,1), x(1,2), x(1,3)]
%              [x(2,1), x(2,2), x(2,3)]
%              ...
%              [x(N,1), x(N,2), x(N,3)]
%   y - single [y(1), y(2), y(3)]
%
% Result of comparing y to all rows of x
%

function [ ndist ] = GRNN_Euclidean (x, y, varargin)
    N = size(x,1);
    ndist = NaN(N,1);
    for idx = 1:N % Adding row by row
        ndist(idx) = sum(sqr(x(idx,:) - y));
    end
end

