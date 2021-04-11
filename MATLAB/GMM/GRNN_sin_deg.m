function [ dangle ] = GRNN_sin_deg (angle1, angle2)
% Compute sqr of asimuth difference in range -180 - +180 
    [N,M] = size(angle1);
    dangle = zeros(N,1);
    for idx = 1:M
        dangle = dangle + sqr(sin((angle1(:,idx) - angle2(idx)) * pi / 180.0));
    end
end

