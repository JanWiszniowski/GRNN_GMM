function [ q3 ] = MTD_Quatd( q1, q2 )
%     Quaternion division Q3 = Q2*(Q1)^(-1), or Q2 = Q3*Q1
      qc1 = -q1;
      qc1(4) = q1(4);
      q3 = MTD_Quatp (qc1, q2);
end
