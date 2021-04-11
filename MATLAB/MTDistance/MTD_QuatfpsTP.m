function [ quat, icod ] = MTD_QuatfpsTP(plg_t, azm_t, plg_p, azm_p, varargin)
% function [ quat, icod ] = MTD_QuatfpsTP(plg_t, azm_t, plg_p, azm_p)
%  Quaternion division Q3 = Q2*Q1^-1, or Q2 = Q3*Q1,
%  see F. Klein v.1 p.61, or Altmann, 1986, p.156,
%  or Biedenharn and Louck, 1981, p. 185.
%  Quaternion is taken here  --  q1*i + q2*j + q3*k + q4
%
%     THIS ROUTINE CALCULATES ROTATION QUATERNION CORRESPONDING TO
%                   EARTHQUAKE FOCAL MECHANISM
%
%     input data plg_t, azm_t:  plunge and azimuth of T-axis
%                plg_p, azm_p:  plunge and azimuth of P-axis
%     Since plunge and azimuth of 2 axes are redundant for calculation,
%     (four degrees of freedom vs three degrees that are necessary)
%     and have low accuracy (integer angular degrees), we calculate
%     plane_normal (V) and slip_vector (S) axes, in order that all axes
%     be orthogonal.
%     The orthogonality
%     of T- and P-axes, it should be small (@<0.01 or so).
    rad = 180.0 / pi;
    verbose = arparameters('verbose', false, varargin{:});
    ERR = 1.0e-15;
    ic = 1;
    if verbose
        fprintf('T(%f,%f), P(%f,%f)\n',plg_t, azm_t, plg_p, azm_p)
    end
    
    t1 = cos(azm_t / rad) * cos(plg_t / rad);
    t2 = sin(azm_t / rad) * cos(plg_t / rad);
    t3 = sin(plg_t / rad);
    p1 = cos(azm_p / rad) * cos(plg_p / rad);
    p2 = sin(azm_p / rad) * cos(plg_p / rad);
    p3 = sin(plg_p / rad);
    perp = t1 * p1 + t2 * p2 + t3 * p3;
    if abs(perp) > 2.0e-02
        error('**** T- AND P-AXES ARE NOT ORTHOGONAL: (%f,%f,%f)*(%f,%f,%f)=%f', t1, t2, t3, p1, p2, p3, perp)
    end
    v1 = t1 + p1;
    v2 = t2 + p2;
    v3 = t3 + p3;
    s1 = t1 - p1;
    s2 = t2 - p2;
    s3 = t3 - p3;
    anormv = sqrt(v1 * v1 + v2 * v2 + v3 * v3);
    v1 = v1 / anormv;
    v2 = v2 / anormv;
    v3 = v3 / anormv;
    anorms = sqrt(s1 * s1 + s2 * s2 + s3 * s3);
    s1 = s1 / anorms;
    s2 = s2 / anorms;
    s3 = s3 / anorms;
    
    an1 = s2 * v3 - v2 * s3;
    an2 = v1 * s3 - s1 * v3;
    an3 = s1 * v2 - v1 * s2;
    d2 = 1.0 / sqrt(2.0);
    t1 = (v1 + s1) * d2;
    t2 = (v2 + s2) * d2;
    t3 = (v3 + s3) * d2;
    p1 = (v1 - s1) * d2;
    p2 = (v2 - s2) * d2;
    p3 = (v3 - s3) * d2;
    if verbose
        fprintf('T1=%f, T2=%f, T3=%f, P1=%f, P2=%f, P3=%f, AN1=%f, AN2=%f, AN3=%f\n', t1, t2, t3, p1, p2, p3, an1, an2, an3)
    end
    u0 = (t1 + p2 + an3 + 1.0) / 4.0;
    u1 = (t1 - p2 - an3 + 1.0) / 4.0;
    u2 = (-t1 + p2 - an3 + 1.0) / 4.0;
    u3 = (-t1 - p2 + an3 + 1.0) / 4.0;
    um = max([u0, u1, u2, u3]);
    if um == u0
        icod = 1 * ic;
        u0 = sqrt(u0);
        u3 = (t2 - p1) / (4.0 * u0);
        u2 = (an1 - t3) / (4.0 * u0);
        u1 = (p3 - an2) / (4.0 * u0);
    elseif um == u1
        icod = 2 * ic;
        u1 = sqrt(u1);
        u2 = (t2 + p1) / (4.0 * u1);
        u3 = (t3 + an1) / (4.0 * u1);
        u0 = (p3 - an2) / (4.0 * u1);
    elseif um == u2
        icod = 3 * ic;
        u2 = sqrt(u2);
        u1 = (t2 + p1) / (4.0 * u2);
        u0 = (an1 - t3) / (4.0 * u2);
        u3 = (p3 + an2) / (4.0 * u2);
    elseif um == u3
        icod = 4 * ic;
        u3 = sqrt(u3);
        u0 = (t2 - p1) / (4.0 * u3);
        u1 = (t3 + an1) / (4.0 * u3);
        u2 = (p3 + an2) / (4.0 * u3);
    else
        error(' **** Can not find max u')
    end
    temp = u0 * u0 + u1 * u1 + u2 * u2 + u3 * u3;
    if abs(temp - 1.0) > ERR
        error(' **** |u| != 1')
    end
    quat(1) = u1;
    quat(2) = u2;
    quat(3) = u3;
    quat(4) = u0;
end

