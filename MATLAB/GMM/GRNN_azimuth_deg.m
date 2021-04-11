function [ dangle ] = GRNN_azimuth_deg (angle1, angle2)
% Compute sqr of asimuth difference in range -180 - +180 
    N = size(angle1,1);
    dangle = NaN(N,1);
    for idx = 1:N
        deltaangle = angle1(idx,:)-angle2 + 720.0;
        cond = deltaangle >= 180.0;
        while any(cond)
            deltaangle(cond) = deltaangle(cond) - 360.0;
            cond = deltaangle >= 180.0;
        end
        dangle(idx) = sum(sqr(deltaangle));
    end
end

