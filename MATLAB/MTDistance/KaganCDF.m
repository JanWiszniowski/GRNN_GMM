function [ opdf ] = KaganCDF(angles )
    angl = angles(angles>=0 & angles <=180) * pi / 180;
    f2 = 2*acos(3 ^ (-1/2));
%    fprintf('Fi2= %f\n',f2*180/pi)
    opdf = zeros(size(angl));
    idx = angl>=0 & angl <= pi/2;
    opdf(idx) = (4/pi) .* (1-cos(angl(idx)));
    idx = angl > pi/2 & angl <= f2;
    pang = angl(idx);
    opdf(idx) = (4/pi) .* (3*sin(pang) +2*cos(pang)-2);
    idx = angl > f2 & angl <= 2*pi/3;
    pang = angl(idx);
    ac =(1+cos(pang)) ./ (-2*cos(pang));
    opdf(idx) = (4/pi) .* (3*sin(pang) + 2*cos(pang) - 2 - (6/pi) * (2*sin(pang).* acos(ac .^ (1/2)) - (1-cos(pang)) .* acos(ac)));
    opdf = opdf / 57.295780069364923;
    d = angles(2:end) - angles(1:end-1);
    opdf = cumsum(opdf(1:end-1).*d);
end

