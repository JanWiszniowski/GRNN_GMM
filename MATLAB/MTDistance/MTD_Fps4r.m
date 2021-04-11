function [] = MTD_Fps4r (eqh1, eqh2, varargin)
    verbose = arparameters('verbose', false, varargin{:});
    if verbose
        fprintf('egh1 = %f, %f, %f, %f\n',eqh1)
        fprintf('egh2 = %f, %f, %f, %f\n',eqh2)
    end
    
    quat1 = MTD_QuatfpsTP(eqh1(1),eqh1(2),eqh1(3),eqh1(4), varargin{:});
    [quat1, angl1, theta1, phi1] = MTD_Sphcoor (quat1);
    [quatr1, qm, icode] = MTD_Boxtest (quat1);
    [quatr1,angl2, theta2, phi2] = MTD_Sphcoor (quatr1);
    if verbose
        fprintf('quat1 = %f, %f, %f, %f\n',quat1)
        fprintf('   angl=%f, theta=%f, phi=%f\n',angl1, theta1, phi1)
        fprintf('quatr1 = %f, %f, %f, %f\n',quatr1)
        fprintf('   angl=%f, theta=%f, phi=%f\n',angl2, theta2, phi2)
        fprintf('qm = %f, %f, %f, %f\n',qm)
        fprintf('icode = %d\n',icode)
        
    end

    quat2 = MTD_QuatfpsTP(eqh2(1),eqh2(2),eqh2(3),eqh2(4), varargin{:});
    [quat2, angl1, theta1, phi1] = MTD_Sphcoor (quat2);
    [quatr2, qm, icode] = MTD_Boxtest (quat2);
    [quatr2,angl2, theta2, phi2] = MTD_Sphcoor (quatr2);
    if verbose
        fprintf('quat2 = %f, %f, %f, %f\n',quat2)
        fprintf('   angl=%f, theta=%f, phi=%f\n',angl1, theta1, phi1)
        fprintf('quatr2 = %f, %f, %f, %f\n',quatr2)
        fprintf('   angl=%f, theta=%f, phi=%f\n',angl2, theta2, phi2)
        fprintf('qm = %f, %f, %f, %f\n',qm)
        fprintf('icode = %d\n',icode)
        
    end
    if  verbose
        fprintf('For 1\n')
    end
    q1a = MTD_F4r1 (quat1, quat2, 1, varargin{:});
    q1b = MTD_F4r2 (quat1, quat2, 1, varargin{:});

    if  verbose
        fprintf('For 2\n')
    end
    q2a = MTD_F4r1 (quat1, quat2, 2, varargin{:});
    q2b = MTD_F4r2 (quat1, quat2, 2, varargin{:});

    if  verbose
        fprintf('For 3\n')
    end
    q3a = MTD_F4r1 (quat1, quat2, 3, varargin{:});
    q3b = MTD_F4r2 (quat1, quat2, 3, varargin{:});

    if  verbose
        fprintf('For 4\n')
    end
    q4a = MTD_F4r1 (quat1, quat2, 4, varargin{:});
    q4b = MTD_F4r2 (quat1, quat2, 4, varargin{:});
end