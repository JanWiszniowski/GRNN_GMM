function q = MTD_F4r1 (q1, q2, icode, varargin)
%     Q = Q2*(Q1*(I,J,K,1))^(-1)
%     Since F4R1 and F4R2 yield the same results, only one subroutine
%     is needed; both programs are kept here for testing purposes.
    verbose = arparameters('verbose', false, varargin{:});

    [qr1] = MTD_Boxtest (q1, icode);
    if verbose  
        fprintf('MTD_F4r1: q1(%d) = %f, %f, %f, %f\n',icode, qr1)
    end
    q = MTD_Quatd (qr1, q2);
    
    
    [q, angl, theta, phi] = MTD_Sphcoor(q);
    if verbose  
        fprintf('          q = %f, %f, %f, %f\n',q)
        fprintf('          angl=%f, theta=%f, phi=%f\n',188*angl/pi, 180*theta/pi, 180*phi/pi)
    end
end