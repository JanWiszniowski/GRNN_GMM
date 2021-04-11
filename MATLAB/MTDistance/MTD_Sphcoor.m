function [quat, angl, theta, phi ] = MTD_Sphcoor (quat)
% function [ angl, theta, phi ] = MTD_Sphcoor (quat)
%     For the rotation quaternion QUAT the subroutine finds the
%     rotation angle (ANGL) of a counterclockwise rotation and
%     spherical coordinates (colatitude THETA, and azimuth PHI) of the
%     rotation pole (intersection of the axis with reference sphere);
%     THETA=0 corresponds to the vector pointing down.
    if quat(4) < 0.0
        quat = -quat;
    end
    q4n = sqrt(1.0 - quat(4) .^ 2);
    costh = 1.0;
    if abs(q4n) > 1.0e-10
        costh = quat(3) / q4n;
    end
    if abs(costh) > 1.0
        costh = floor(costh);
    end
    theta = acos(costh);
    angl = 2.0 * acos(quat(4));
    phi = 0.0;
    if abs(quat(1)) > 1.0e-10 || abs(quat(2)) > 1.0e-10
        phi = atan2(quat(2), quat(1));
    end
    if phi < 0.0 
        phi = phi + 360.0;
    end
end