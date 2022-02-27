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
    [LARc, coeff, CurrFrmSTResd] = RPE_frame_ST_coder(s, prevLARc);
    prevLARc = LARc;
    sro = short_term_synthesis(CurrFrmSTResd, s, coeff, beta);
    sr_final(i:i+159) = sro;
end

sound(sr_final, Fs, 16);
