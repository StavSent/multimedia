function [s0, CurrFrmSTResd] = RPE_frame_SLT_decoder(LARc, Nc, bc, CurrFrmExFull, PrevFrmSTResd, PrevLARc)
    b = zeros(4, 1);
    b(bc == 0) = 0.1;
    b(bc == 1) = 0.35;
    b(bc == 2) = 0.65;
    b(bc == 3) = 1;
    N = Nc;
    
    SFhistory = PrevFrmSTResd;
    for j = 1:4
        SFhistory = [SFhistory; CurrFrmExFull((j-1)*40+1:(j*40)) + b(j) * SFhistory(121+40*j-N(j):160+40*j-N(j))];
    end
    CurrFrmSTResd = SFhistory(161:320);
    s0 = RPE_frame_ST_decoder(LARc, CurrFrmSTResd, PrevLARc);
end