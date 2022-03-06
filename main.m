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


% sound(y, Fs, 16);

sr_final2 = zeros(length(y), 1);
[~, PrevFrmSTResd] = RPE_frame_ST_coder(y(1:160), PrevLARc);

for i = 161:160:length(y)
    if (i+160 > length(y))
        break;
    end
    s0 = y(i:i+159);
    [LARc, Nc, bc, CurrFrmExFull, CurrFrmSTResd] = RPE_frame_SLT_coder(s0, PrevFrmSTResd, PrevLARc);
    [s0, CurrFrmSTResd] = RPE_frame_SLT_decoder(LARc, Nc, bc, CurrFrmExFull, PrevFrmSTResd, PrevLARc);
    sr_final2(i:i+159) = s0;
    PrevLARc = LARc;
    PrevFrmSTResd = CurrFrmSTResd;
end

diff = sr_final - sr_final2;
