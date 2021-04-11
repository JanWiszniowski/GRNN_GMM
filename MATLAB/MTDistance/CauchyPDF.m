function [ opdf ] = CauchyPDF(k, angles )
    fi = angles(angles>=0 & angles <=180) * pi / 180;
    opdf = 4*k/pi * (1-cos(fi)).* (1 + k^2 + (k^2-1)*cos(fi)) .^ -2 / 57.297371062513029;
end

