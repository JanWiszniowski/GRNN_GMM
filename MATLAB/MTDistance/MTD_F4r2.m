function q = MTD_F4r2 (q1, q2, icode, varargin)
%      SUBROUTINE F4r2 (q1, q2, q, icode)
%     Q = (Q2*(I,J,K,1))*Q1**(-1)
    verbose = arparameters('verbose', false, varargin{:});

    [qr2] = MTD_Boxtest (q2, icode);
    q = MTD_Quatd (q1, qr2);
    [q, angl, theta, phi] = MTD_Sphcoor (q);
    if verbose  
        fprintf('MTD_F4r2: q = %f, %f, %f, %f, ',q)
        fprintf('   angl=%f, theta=%f, phi=%f\n',angl, theta, phi)
    end
end
