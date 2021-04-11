function [ dcrot, angles ] = MTD_dcrot(eqn1, eqh1, eqn2, eqh2, varargin)
% Added by Peter Bird, 2003, as a silent function
% Based on the code of SUBROUTINE Fps4r.
% Check for case of two identical earthquakes
% (which can cause numerical problems)
% and return angle of 0:
    verbose = arparameters('verbose', false, varargin{:});
    angles = zeros(1,4);
    thetas = zeros(1,4);
    phis = zeros(1,4);

    if strcmp(eqn1,'TP')
        quat1 = MTD_QuatfpsTP (eqh1(1),eqh1(2),eqh1(3),eqh1(4),varargin{:});
    elseif strcmp(eqn1,'SDR')
        quat1 = MTD_QuatfpsSDR (eqh1);
    else
        error('Wrong call parameters')
    end
    quat1 = MTD_Sphcoor(quat1);
    if strcmp(eqn2,'TP')
        quat2 = MTD_QuatfpsTP (eqh2(1),eqh2(2),eqh2(3),eqh2(4),varargin{:});
    elseif strcmp(eqn2,'SDR')
        quat2 = MTD_QuatfpsSDR (eqh2);
    else
        error('Wrong call parameters')
    end
    quat2 = MTD_Sphcoor(quat2);
    if verbose
        fprintf('q1 = %f,%f,%f,%f; %f\n',quat1, sum(quat1.^2))
        fprintf('q2 = %f,%f,%f,%f; %f\n',quat2, sum(quat1.^2))
    end

    for i = 1:4
        [angles(i), thetas(i), phis(i)] = MTD_F4r1_pb (quat1, quat2, i, varargin{:});
    end
    [dcrot, mindex] = min(angles);

end