function larc = coeff2LAR(rc, A, B)
    lar = rc;
    lar(abs(rc) < 0.675) = lar(abs(rc) < 0.675);
    lar(abs(rc) < 0.95 & abs(rc) >= 0.675) = sign(lar(abs(rc) < 0.95 & abs(rc) >= 0.675)) .* ((2 * abs(lar(abs(rc) < 0.95 & abs(rc) >= 0.675))) - 0.675);
    lar(abs(rc) <= 1 & abs(rc) >= 0.95) = sign(lar(abs(rc) <= 1 & abs(rc) >= 0.95)) .* ((8 * abs(lar(abs(rc) <= 1 & abs(rc) >= 0.95))) - 6.375);

    % Quantised LAR
    % possibly make Nint as is in gsmts (p.21)
    larc = round((A .* lar) .* B);
end