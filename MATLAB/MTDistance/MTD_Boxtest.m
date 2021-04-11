function [ q2, qm, icode] = MTD_Boxtest (q1, icode)
%     for ICODE=0 finds minimal rotation quaternion
%     for ICODE=N finds rotation quaternion Q2 = Q1*(i,j,k,1),
%     for N=1,2,3,4
    quat = [1.0, 0.0, 0.0, 0.0
            0.0, 1.0, 0.0, 0.0
            0.0, 0.0, 1.0, 0.0];
    if nargin < 2
      icode = 0;
    end
    if icode == 0
        [qm1,icode] = max(abs(q1));
    end
    q2 = q1;
    if icode ~= 4
        q2 = MTD_Quatp(quat(icode,:), q1);
    end
    if q2(4) < 0.0
        q2 = -q2;
    end
    qm = q2(4);
end