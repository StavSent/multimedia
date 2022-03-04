function larc = coeff2LAR(a, A, B)
    rc = poly2rc(a);

    lar = rc;
    lar(abs(rc) < 0.675) = lar(abs(rc) < 0.675);
    lar(abs(rc) < 0.95 & abs(rc) >= 0.675) = sign(lar(abs(rc) < 0.95 & abs(rc) >= 0.675)) .* ((2 * abs(lar(abs(rc) < 0.95 & abs(rc) >= 0.675))) - 0.675);
    lar(abs(rc) <= 1 & abs(rc) >= 0.95) = sign(lar(abs(rc) <= 1 & abs(rc) >= 0.95)) .* ((8 * abs(lar(abs(rc) <= 1 & abs(rc) >= 0.95))) - 6.375);

    % Quantised LAR
    larc = (A .* lar) + B;
    larc = round(larc + (sign(larc) * 0.5));
end