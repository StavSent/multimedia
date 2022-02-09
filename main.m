[y, Fs] = audioread("./test.wav");
alpha = 32735 * 2^(-15);
beta = 28180 * 2^(-15);
A = [20; 20; 20; 20; 13.637; 15; 8.334; 8.824];
B = [0; 0; 4; -5; 0.184; -3.5; -0.666; -2.235];
% sound(y, Fs, 16);

sr_final = zeros(length(y), 1);
prevLARc = zeros(8, 1);

for i = 1:160:length(y)
    if (i+160 > length(y))
        break;
    end
 
    so = y(i:i+159);
    sof = offset_comp(so, alpha);
    s = preemphasis(sof, beta);
    [r, R] = auto_corr(s);
    a = R\r;
    a = [1; -a];
    larc = coeff2LAR(a, A, B);
    coeff = LAR2coeff(prevLARc, larc, A, B);
    prevLARc = larc;
    d = short_term_residual(s, coeff);
    sr = short_term_synthesis(d, sof, coeff);
    sr_final(i:i+159) = sr;
end

sound(sr_final, Fs, 16);
