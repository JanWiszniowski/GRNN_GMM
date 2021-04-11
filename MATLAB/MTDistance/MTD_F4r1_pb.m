function [ angl, theta, phi, qm ] = MTD_F4r1_pb (q1, q2, icode, varargin)
%     Q = Q2*(Q1*(I,J,K,1))**(-1)
%     created by Peter Bird, 2003, to provide a silent
%     alternative to SUBROUTINE F4r1.
%     Instead of WRITEing the result ANGL,
%     it returns it as the value of F4r1_pb.
    verbose = arparameters('verbose', false, varargin{:});
    [qr1, qm] = MTD_Boxtest (q1, icode);
    q = MTD_Quatd (qr1, q2);
    [q, angl, theta, phi ] = MTD_Sphcoor (q);
    if verbose
        fprintf('q1(%d) = %f,%f,%f,%f\n',icode,qr1)
        fprintf('q = %f,%f,%f,%f\n',q)
        fprintf('angl = %f\n',angl * 180 / pi)
    end
end