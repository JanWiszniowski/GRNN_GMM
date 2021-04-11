function [ dcrot, mindex, angles, thetas, phis ] = MTD_dcrotTP (eqh1, eqh2, varargin)
% Added by Peter Bird, 2003, as a silent function
% Based on the code of SUBROUTINE Fps4r.
% Check for case of two identical earthquakes
% (which can cause numerical problems)
% and return angle of 0:
    verbose = arparameters('verbose', false, varargin{:});
    angles = zeros(1,4);
    thetas = zeros(1,4);
    phis = zeros(1,4);

    tolerance = arparameters('tolerance', 0.1, varargin{:});
    if abs(eqh1(1)) <  tolerance % horizontal T axis for eqh1
        matched_Ts = (abs(eqh2(1)) < tolerance) && (mod(abs(eqh1(2) - eqh2(2)), 180.0) < tolerance);
    else
        matched_Ts = (abs(eqh2(1) - eqh1(1)) < tolerance) && (mod(abs(eqh1(2) - eqh2(2)), 360.0) < tolerance);
    end
    if abs(eqh1(3)) <  tolerance % horizontal T axis for eqh1
        matched_Ps = (abs(eqh2(3)) < tolerance) && (mod(abs(eqh1(4) - eqh2(4)), 180.0) < tolerance);
    else
        matched_Ps = (abs(eqh2(3) - eqh1(3)) < tolerance) && (mod(abs(eqh1(4) - eqh2(4)), 360.0) < tolerance);
    end
    if matched_Ts && matched_Ps
        if verbose
            fprintf('The same angle with tolerance %f\n',tolerance)
        end
        dcrot = 0.0;
        mindex = 0;
        angles = [0, 0, 0, 0];
        phis = angles;
        thetas = angles;
        return
    end

    quat1 = MTD_QuatfpsTP (eqh1(1),eqh1(2),eqh1(3),eqh1(4),varargin{:});
    quat1 = MTD_Sphcoor(quat1);
    % [quatr1, qm, icode] = MTD_Boxtest (quat1);
    % quatr1 = MTD_Sphcoor(quatr1);

    quat2 = MTD_QuatfpsTP (eqh2(1),eqh2(2),eqh2(3),eqh2(4),varargin{:});
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

