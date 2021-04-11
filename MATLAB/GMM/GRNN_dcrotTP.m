%function [ dcrot ] = GRNN_dcrotTP (eqh1, eqh2, varargin)
%
% Compute Kagan angles from pricipal axes
% Inputs:
%   eqh1 - array [Plunge_T1, Azimuth_T1,  Plunge_P1,  Azimuth_P1]
%                [Plunge_T2, Azimuth_T2,  Plunge_P2,  Azimuth_P2]
%                ...
%                [Plunge_Tn, Azimuth_Tn,  Plunge_Pn,  Azimuth_Pn]
%   eqh2 - single [Plunge_T, Azimuth_T,  Plunge_P,  Azimuth_P]
%
% Result of comparing eqh2 to all values of eqh1
%
% Method added by Peter Bird, 2003, as a silent function
% Based on the code of SUBROUTINE Fps4r.
% Check for case of two identical earthquakes
% (which can cause numerical problems)
% and return angle of 0:
function [ dcrot ] = GRNN_dcrotTP (eqh1, eqh2, varargin)
    N = size(eqh1,1);
    dcrot = zeros(N,1);
    for idx = 1:N
        dcrot(idx) = MTD_dcrotTP (eqh1(idx,:), eqh2, varargin{:});
    end
    dcrot = sqr(dcrot);
end

