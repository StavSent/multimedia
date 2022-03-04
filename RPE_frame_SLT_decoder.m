function [s0, CurrFrmSTResd] = RPE_frame_SLT_decoder(LARc, Nc, bc, CurrFrmExFull, PrevFrmSTResd, PrevLARc)
    b = zeros(4, 1);
    b(bc == 0) = 0.1;
    b(bc == 1) = 0.35;
    b(bc == 2) = 0.65;
    b(bc == 3) = 1;
    N = Nc;
    
%     mirrorIdx = length(CurrFrmSTResd):-1:1;
%     mirroredCurrFrmSTResd = [CurrFrmSTResd(mirrorIdx); CurrFrmSTResd];
    CurrFrmSTResd = zeros(length(PrevFrmSTResd), 1);
    for j = 1:4
        if (j ~= 4)
            CurrFrmSTResd((j-1)*40+1:j*40) = CurrFrmExFull((j-1)*40+1:(j*40)) + b(j) * PrevFrmSTResd(121-N(j):160-N(j));
        else
            CurrFrmSTResd((j-1)*40+1:j*40) = CurrFrmExFull((j-1)*40+1:(j*40)) + b(j) * CurrFrmSTResd(121-N(j):160-N(j));
        end 
    end
    s0 = RPE_frame_ST_decoder(LARc, CurrFrmSTResd, PrevLARc);
end