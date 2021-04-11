function [ quat ] = MTD_QuatTP(plg_t_ax, azm_t_ax, plg_p_ax, azm_p_ax)
)
%  Quaternion division Q3 = Q2*Q1^-1, or Q2 = Q3*Q1,
%  see F. Klein v.1 p.61, or Altmann, 1986, p.156,
%  or Biedenharn and Louck, 1981, p. 185.
%  Quaternion is taken here  --  q1*i + q2*j + q3*k + q4
      SUBROUTINE Quatfps (quat, eqh, icode)
      IMPLICIT REAL * 8 (a - h, o - z)
      REAL * 8 quat(4)
      INTEGER * 2 eqh(4)
      LOGICAL verbose
      COMMON / mom / rad, perp
      COMMON / pb2003 / verbose

%     THIS ROUTINE CALCULATES ROTATION QUATERNION CORRESPONDING TO
%                   EARTHQUAKE FOCAL MECHANISM

%     icode=0 -- four input data:  plunge and azimuth of T-axis
%                                  plunge and azimuth of P-axis
%     Since plunge and azimuth of 2 axes are redundant for calculation,
%     (four degrees of freedom vs three degrees that are necessary)
%     and have low accuracy (integer angular degrees), we calculate
%     plane_normal (V) and slip_vector (S) axes, in order that all axes
%     be orthogonal.

%     icode=1 -- three input data: slip angle (SA), dip angle (DA),
%                                  dip direction (DD)

%     PERP variable checks orthogonality
%     of T- and P-axes, it should be small (@<0.01 or so).
      rad = 180.0 / pi;

      ERR = 1.0D-15
      ic = 1

      t1 = cos(azm_t_ax / rad) * cos(plg_t_ax / rad);
      t2 = sin(azm_t_ax / rad) * cos(plg_t_ax / rad);
      t3 = sin(plg_t_ax / rad);
      p1 = cos(azm_p_ax / rad) * cos(plg_p_ax / rad);
      p2 = sin(azm_p_ax / rad) * cos(plg_p_ax / rad);
      p3 = sin(plg_p_ax / rad);
      perp = t1 * p1 + t2 * p2 + t3 * p3;
      if perp > 2.0e-4
          error(' **** T- AND P-AXES ARE NOT ORTHOGONAL')
      end

      v1 = t1 + p1
      v2 = t2 + p2
      v3 = t3 + p3
      s1 = t1 - p1
      s2 = t2 - p2
      s3 = t3 - p3
      anormv = DSQRT(v1 * v1 + v2 * v2 + v3 * v3)
      v1 = v1 / anormv
      v2 = v2 / anormv
      v3 = v3 / anormv
      anorms = DSQRT(s1 * s1 + s2 * s2 + s3 * s3)
      s1 = s1 / anorms
      s2 = s2 / anorms
      s3 = s3 / anorms

%       GO TO 250
%   200 CONTINUE
% 
%       dd = eqh(1)
%       da = eqh(2)
%       sa = eqh(3)
%       dd = dd / rad
%       da = da / rad
%       sa = sa / rad
%       cdd = DCOS(dd)
%       sdd = DSIN(dd)
%       cda = DCOS(da)
%       sda = DSIN(da)
%       csa = DCOS(sa)
%       ssa = DSIN(sa)
%       s1 = csa * cdd + cda * sdd * ssa
%       s2 = csa * sdd - ssa * cda * cdd
%       s3 = - ssa * sda
%       v1 = - sda * sdd
%       v2 = sda * cdd
%       v3 = - cda
% 
% %      S1 = CSA*SDD - SSA*CDA*CDD
% %      S2 = - CSA*CDD - SSA*CDA*SDD
% %      S3 = - SSA*SDA
% %      V1 = SDA*CDD
% %      V2 = SDA*SDD
% %      V3 = - CDA

  250 CONTINUE
      an1 = s2 * v3 - v2 * s3
      an2 = v1 * s3 - s1 * v3
      an3 = s1 * v2 - v1 * s2
%      SINV3 = S1*V2*AN3 + S2*V3*AN1 + V1*AN2*S3 -
%     1 S3*V2*AN1 - S1*AN2*V3 - AN3*V1*S2
      d2 = 1.0D0 / DSQRT(2.0D0)
      t1 = (v1 + s1) * d2
      t2 = (v2 + s2) * d2
      t3 = (v3 + s3) * d2
      p1 = (v1 - s1) * d2
      p2 = (v2 - s2) * d2
      p3 = (v3 - s3) * d2
      IF (verbose) WRITE (6, 100) t1, t2, t3, p1, p2, p3, an1, an2, an3
  100 FORMAT (' T1, T2, T3, P1, P2, P3, AN1, AN2, AN3 = ', /, 9G13.4)

      u0 = (t1 + p2 + an3 + 1.0D0) / 4.0D0
      u1 = (t1 - p2 - an3 + 1.0D0) / 4.0D0
      u2 = (-t1 + p2 - an3 + 1.0D0) / 4.0D0
      u3 = (-t1 - p2 + an3 + 1.0D0) / 4.0D0
      um = DMAX1(u0, u1, u2, u3)
      IF (um == u0) GO TO 10
      IF (um == u1) GO TO 20
      IF (um == u2) GO TO 30
      IF (um == u3) GO TO 40
      IF (verbose) WRITE (6, 150)

   10 CONTINUE
      icod = 1 * ic
      u0 = DSQRT(u0)
      u3 = (t2 - p1) / (4.0D0 * u0)
      u2 = (an1 - t3) / (4.0D0 * u0)
      u1 = (p3 - an2) / (4.0D0 * u0)
      GO TO 50
   20 CONTINUE
      icod = 2 * ic
      u1 = DSQRT(u1)
      u2 = (t2 + p1) / (4.0D0 * u1)
      u3 = (t3 + an1) / (4.0D0 * u1)
      u0 = (p3 - an2) / (4.0D0 * u1)
      GO TO 50
   30 CONTINUE
      icod = 3 * ic
      u2 = DSQRT(u2)
      u1 = (t2 + p1) / (4.0D0 * u2)
      u0 = (an1 - t3) / (4.0D0 * u2)
      u3 = (p3 + an2) / (4.0D0 * u2)
      GO TO 50
   40 CONTINUE
      icod = 4 * ic
      u3 = DSQRT(u3)
      u0 = (t2 - p1) / (4.0D0 * u3)
      u1 = (t3 + an1) / (4.0D0 * u3)
      u2 = (p3 + an2) / (4.0D0 * u3)
   50 CONTINUE
      temp = u0 * u0 + u1 * u1 + u2 * u2 + u3 * u3

      IF (DABS(temp - 1.0D0) > ERR) THEN
      WRITE (6, 150)
  150 FORMAT (' **** ERROR *****')
      WRITE (6, 90) t1, t2, t3, p1, p2, p3
   90 FORMAT (' T1, T2, T3, P1, P2, P3 = ', /, 6G18.9)
      WRITE (6, 80) an1, an2, an3
   80 FORMAT (' AN1, AN2, AN3 = ', 3G18.9)
      WRITE (6, 120) temp, u1, u2, u3, u0
  120 FORMAT (' TEMP, U1, U2, U3, U0 = ', 5G18.9)
      END IF
      quat(1) = u1
      quat(2) = u2
      quat(3) = u3
      quat(4) = u0
      IF (verbose) WRITE (6, 130) quat, icod
  130 FORMAT (' QUAT = ', 4G18.9, ' ICOD =', I5)

      RETURN
      END SUBROUTINE Quatfps
end

