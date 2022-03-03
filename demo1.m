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
    [LARc, CurrFrmSTResd] = RPE_frame_ST_coder(so, prevLARc);
    sro = RPE_frame_ST_decoder(CurrFrmSTResd, LARc, prevLARc);
    sr_final(i:i+159) = sro;
    prevLARc = LARc;
end

sound(sr_final, Fs, 16);
% diffs = sr_final - y;
