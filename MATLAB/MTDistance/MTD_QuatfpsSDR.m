function [ QUAT, ICOD ] = MTD_QuatfpsSDR(EQH)
% function [ quat, icod ] = MTD_QuatfpsSDR(EQH)
%     Three input data:
%       strike direction   (phi_s -- EQH(1)),
%       dip angle          (delta -- EQH(2)),
%       slip angle -- rake (lambda -- EQH(3)),
%      Harvard convention: Strike, dip, and rake for best double
%      couple -- repeated for second nodal plane.
    RAD = 180.0 / pi;
    QUAT = nan(1,4);
    ERR = 1.0e-15;
    IC = 1 ;
    DD = EQH(1);
    DA = EQH(2);
    SA = EQH(3);
    DD = DD/RAD;
    DA = DA/RAD;
    SA = SA/RAD;
    CDD = cos(DD);
    SDD = sin(DD);
    CDA = cos(DA);
    SDA = sin(DA);
    CSA = cos(SA);
    SSA = sin(SA);
    S1 = CSA*CDD + CDA*SDD*SSA;
    S2 = CSA*SDD - SSA*CDA*CDD;
    S3 = - SSA*SDA;
    V1 = - SDA*SDD;
    V2 = SDA*CDD;
    V3 = - CDA;
    AN1 = S2*V3 - V2*S3;
    AN2 = V1*S3 - S1*V3;
    AN3 = S1*V2 - V1*S2;
    D2 = 1.0/sqrt(2.0);
    T1 = (V1 + S1)*D2;
    T2 = (V2 + S2)*D2;
    T3 = (V3 + S3)*D2;
    P1 = (V1 - S1)*D2;
    P2 = (V2 - S2)*D2;
    P3 = (V3 - S3)*D2;
    U0 = (T1 + P2 + AN3 + 1.0)/4.0;
    U1 = (T1 - P2 - AN3 + 1.0)/4.0;
    U2 = (-T1 + P2 - AN3 + 1.0)/4.0;
    U3 = (-T1 - P2 + AN3 + 1.0)/4.0;
    UM = max([U0, U1, U2, U3]);
    if UM == U0
        ICOD = 1*IC;
        U0 = sqrt(U0);
        U3 = (T2 - P1)/(4.0*U0);
        U2 = (AN1 - T3)/(4.0*U0);
        U1 = (P3 - AN2)/(4.0*U0);
    elseif UM == U1
        ICOD = 2*IC;
        U1 = sqrt(U1);
        U2 = (T2 + P1)/(4.0*U1);
        U3 = (T3 + AN1)/(4.0*U1);
        U0 = (P3 - AN2)/(4.0*U1);
    elseif UM == U2
        ICOD = 3*IC;
        U2 = sqrt(U2);
        U1 = (T2 + P1)/(4.0*U2);
        U0 = (AN1 - T3)/(4.0*U2);
        U3 = (P3 + AN2)/(4.0*U2);
    elseif UM == U3
        ICOD = 4*IC;
        U3 = sqrt(U3);
        U0 = (T2 - P1)/(4.0*U3);
        U1 = (T3 + AN1)/(4.0*U3);
        U2 = (P3 + AN2)/(4.0*U3);
    end
    TEMP = U0*U0 + U1*U1 + U2*U2 + U3*U3;
    if abs(TEMP - 1.0) > ERR
        fprintf('error\n')
    end
    QUAT(1) = U1;
    QUAT(2) = U2;
    QUAT(3) = U3;
    QUAT(4) = U0;
end

