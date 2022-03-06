[y, Fs] = audioread("./test.wav");
% sound(y, Fs, 16);

sr_final = zeros(length(y), 1);
PrevLARc = zeros(8, 1);
[~, PrevFrmSTResd] = RPE_frame_ST_coder(y(1:160), PrevLARc);

for i = 161:160:length(y)
    if (i+160 > length(y))
        break;
    end
    s0 = y(i:i+159);
    [LARc, Nc, bc, CurrFrmExFull, CurrFrmSTResd] = RPE_frame_SLT_coder(s0, PrevFrmSTResd, PrevLARc);
    [s0, CurrFrmSTResd] = RPE_frame_SLT_decoder(LARc, Nc, bc, CurrFrmExFull, PrevFrmSTResd, PrevLARc);
    sr_final(i:i+159) = s0;
    PrevLARc = LARc;
    PrevFrmSTResd = CurrFrmSTResd;
end

sound(sr_final, Fs, 16);
% diffs = sr_final - y;