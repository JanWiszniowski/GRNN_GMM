%function [ dcrot ] = GRNN_dcrotSDR (eqh1, eqh2, varargin)
%
% Compute Kagan angles from nodal planes
% Inputs:
%   eqh1 - array [Strike1, Dip1,  Rake1,]
%                [Strike2, Dip2,  Rake2,]
%                ...
%                [StrikeN, DipN,  RakeN,]
%   eqh2 - single [Strike, Dip,  Rake]
%
% Result of comparing eqh2 to all values of eqh1
%
% Added by Peter Bird, 2003, as a silent function
% Based on the code of SUBROUTINE Fps4r.
% Check for case of two identical earthquakes
% (which can cause numerical problems)
% and return angle of 0:
function [ dcrot ] = GRNN_dcrotSDR (eqh1, eqh2, varargin)
    N = size(eqh1,1);
    dcrot = zeros(N,1);
    for idx = 1:N
        dcrot(idx) = MTD_dcrotSDR (eqh1(idx,:), eqh2, varargin{:});
    end
    dcrot = sqr(dcrot);
end

