[y, Fs] = audioread("./test.wav");
alpha = 32735 * 2^(-15);
beta = 28180 * 2^(-15);
A = [20; 20; 20; 20; 13.637; 15; 8.334; 8.324];
B = [0; 0; 4; -5; 0.184; -3.5; -0.666; -2.235];
% % sound(y, Fs, 16);

prevLARc = zeros(8, 1);

for i = 1:160:length(y)
    if (i+160 > length(y))
        break;
    end
    
    if (i > 2) 
        break;
    end
    
    so = y(i:i+159);
    sof = offset_comp(so, alpha);
    s = preemphasis(sof, beta);
    [r, R] = auto_corr(s);
    a = R\r;
    a = [1; -a];
    rc = poly2rc(a);
    larc = coeff2LAR(rc, A, B);
    coeff = LAR2coeff(prevLARc, larc, A, B);
    prevLARc = larc;
    d = short_term_prediction(s, coeff);
end

