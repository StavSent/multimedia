[y, Fs] = audioread("./test.wav");
% sound(y, Fs, 16);

sr_final = zeros(length(y), 1);
PrevLARc = zeros(8, 1);

for i = 1:160:length(y)
    if (i+160 > length(y))
        break;
    end

    s0 = y(i:i+159);
    [LARc, CurrFrmSTResd] = RPE_frame_ST_coder(s0, PrevLARc);
    s0 = RPE_frame_ST_decoder(LARc, CurrFrmSTResd, PrevLARc);
    sr_final(i:i+159) = s0;
    PrevLARc = LARc;
end

sound(sr_final, Fs, 16);