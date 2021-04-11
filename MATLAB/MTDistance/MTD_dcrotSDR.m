function [ dcrot, mindex, angles, thetas, phis ] = MTD_dcrotSDR (eqh1, eqh2, varargin)
% Added by Peter Bird, 2003, as a silent function
% Based on the code of SUBROUTINE Fps4r.
% Check for case of two identical earthquakes
% (which can cause numerical problems)
% and return angle of 0:
    verbose = arparameters('verbose', false, varargin{:});
    angles = zeros(1,4);
    thetas = zeros(1,4);
    phis = zeros(1,4);

    quat1 = MTD_QuatfpsSDR (eqh1);
    quat1 = MTD_Sphcoor(quat1);
    % [quatr1, qm, icode] = MTD_Boxtest (quat1);
    % quatr1 = MTD_Sphcoor(quatr1);

    quat2 = MTD_QuatfpsSDR (eqh2);
    quat2 = MTD_Sphcoor(quat2);
    % [quatr2, qm, icode] = MTD_Boxtest (quat2);
    % quatr2 = MTD_Sphcoor(quatr2);
    if verbose
        fprintf('q1 = %f,%f,%f,%f\n',quat1)
        fprintf('q2 = %f,%f,%f,%f\n',quat2)
    end

    for i = 1:4
        [angles(i), thetas(i), phis(i)] = MTD_F4r1_pb (quat1, quat2, i, varargin{:});
    end
    [dcrot, mindex] = min(angles);
end

