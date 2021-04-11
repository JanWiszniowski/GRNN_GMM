function q = MTD_F4r1 (q1, q2, icode, varargin)
%     Q = Q2*(Q1*(I,J,K,1))^(-1)
%     Since F4R1 and F4R2 yield the same results, only one subroutine
%     is needed; both programs are kept here for testing purposes.
    verbose = arparameters('verbose', false, varargin{:});

    [qr1] = MTD_Boxtest (q1, icode);
    q = MTD_Quatd (qr1, q2);
    [q, angl, theta, phi] = MTD_Sphcoor(q);
    if verbose  
        fprintf('MTD_F4r1: q = %f, %f, %f, %f, ',q)
        fprintf('   angl=%f, theta=%f, phi=%f\n',angl, theta, phi)
    end
end