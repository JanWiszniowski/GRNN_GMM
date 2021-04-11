function [ opdf ] = KaganCauchyPDF(k, angles )
    angl = angles(angles>=0 & angles <=180);
    b = CauchyPDF(k, angl) .* KaganPDF(angl)
    opdf = b / sum(b) *10
end

