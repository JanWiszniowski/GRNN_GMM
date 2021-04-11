function [ Pendicularity ] = MTD_TestperPerpendicularityTP2(pt, varargin)
    plg_t = pt(1);
    azm_t = pt(2);
    plg_p = pt(3);
    azm_p = pt(4);
    verbose = arparameters('verbose', false, varargin{:});
    rad = 180.0 / pi;

    if verbose
        fprintf('T(%f,%f), P(%f,%f)\n',plg_t, azm_t, plg_p, azm_p)
    end
    
    t1 = cos(azm_t / rad) * cos(plg_t / rad);
    t2 = sin(azm_t / rad) * cos(plg_t / rad);
    t3 = sin(plg_t / rad);
    p1 = cos(azm_p / rad) * cos(plg_p / rad);
    p2 = sin(azm_p / rad) * cos(plg_p / rad);
    p3 = sin(plg_p / rad);
    perp = t1 * p1 + t2 * p2 + t3 * p3;
    if abs(perp) > 2.0e-02
        fprintf('**** T- AND P-AXES ARE NOT ORTHOGONAL: (%f,%f,%f)*(%f,%f,%f)=%f\n', t1, t2, t3, p1, p2, p3, perp)
        Pendicularity = 0;
    else
        if verbose
            fprintf('**** T- AND P-AXES ARE ORTHOGONAL: (%f,%f,%f)*(%f,%f,%f)=%f\n', t1, t2, t3, p1, p2, p3, perp)
        end
        Pendicularity = 1;
    end
