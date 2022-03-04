[y, Fs] = audioread("./test.wav");
alpha = 32735 * 2^(-15);
beta = 28180 * 2^(-15);
A = [20; 20; 20; 20; 13.637; 15; 8.334; 8.824];
B = [0; 0; 4; -5; 0.184; -3.5; -0.666; -2.235];
% sound(y, Fs, 16);

sr_final = zeros(length(y), 1);
PrevLARc = zeros(8, 1);
[~, PrevFrmSTResd] = RPE_frame_ST_coder(y(1:160), PrevLARc);

for i = 160:160:length(y)
    if (i+160 > length(y))
        break;
    end
 
    s0 = y(i:i+159);
    [LARc, Nc, bc, CurrFrmExFull, CurrFrmSTResd] = RPE_frame_SLT_coder(s0, PrevFrmSTResd, PrevLARc);
    sr_final(i:i+159) = sro;
    PrevLARc = LARc;
    PrevFrmSTResd = CurrFrmSTResd;
end

sound(sr_final, Fs, 16);
% diffs = sr_final - y;