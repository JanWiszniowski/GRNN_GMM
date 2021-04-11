function [ dangle ] = GRNN_azimuth (angle1, angle2, varargin)
% Compute sqr of asimuth difference in range -pi - +pi 
    N = size(angle1,1);
    dangle = NaN(N,1);
    for idx = 1:N
        deltaangle = angle1(idx)-angle2 + 4.0 * pi;
        while deltaangle > pi
            deltaangle = deltaangle - 2.0 * pi;
        end
        dangle(idx) = sqr(deltaangle);

    end
end

