function coeff = LAR2coeff(prevLARc, larc, A, B) 
    LAR = (larc - B) ./ A;
    prevLAR = (prevLARc - B) ./ A;
    
    coeff = zeros(8, 4);
    poly = zeros(9, 4);
    coeff(:, 1) = (0.75 * prevLAR) + (0.25 * LAR);
    coeff(:, 2) = (0.5 * prevLAR) + (0.5 * LAR);
    coeff(:, 3) = (0.25 * prevLAR) + (0.75 * LAR);
    coeff(:, 4) = LAR;
    
    rc = zeros(8, 4);
    for i = 1:4
        coeffi = coeff(:, i);
        rci = coeffi;
        rci(abs(coeffi) < 0.675) = rci(abs(coeffi) < 0.675);
        rci(abs(coeffi) < 1.225 & abs(coeffi) >= 0.675) = sign(rci(abs(coeffi) < 1.225 & abs(coeffi) >= 0.675)) .* ((0.5 * abs(rci(abs(coeffi) < 1.225 & abs(coeffi) >= 0.675))) - 0.3375);
        rci(abs(coeffi) < 1.625 & abs(coeffi) >= 1.225) = sign(rci(abs(coeffi) < 1.625 & abs(coeffi) >= 1.225)) .* ((0.125 * abs(rci(abs(coeffi) < 1.625 & abs(coeffi) >= 1.225))) + 0.796875);
        rc(:, i) = rci;
    end
    
    poly(:, 1) = rc2poly(rc(:, 1));
    poly(:, 2) = rc2poly(rc(:, 2));
    poly(:, 3) = rc2poly(rc(:, 3));
    poly(:, 4) = rc2poly(rc(:, 4));
    
    coeff = poly;
end