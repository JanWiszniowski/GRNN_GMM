function [ q3 ] = MTD_Quatp( q1, q2 )
%  Calculates product of two quaternions Q3 = Q2*Q1,
%  see F. Klein v.1 p.61, or Altmann, 1986, p.156,
%  or Biedenharn and Louck, 1981, p. 185.
%  Quaternion is taken here  --  q1*i + q2*j + q3*k + q4
      q3(1) =  q1(4) * q2(1) + q1(3) * q2(2) - q1(2) * q2(3) + q1(1) * q2(4);
      q3(2) = -q1(3) * q2(1) + q1(4) * q2(2) + q1(1) * q2(3) + q1(2) * q2(4);
      q3(3) =  q1(2) * q2(1) - q1(1) * q2(2) + q1(4) * q2(3) + q1(3) * q2(4);
      q3(4) = -q1(1) * q2(1) - q1(2) * q2(2) - q1(3) * q2(3) + q1(4) * q2(4);
end
