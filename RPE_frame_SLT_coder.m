function [LARc, Nc, bc, CurrFrmExFull, CurrFrmSTResd] = RPE_frame_SLT_coder(s0, PrevFrmSTResd, PrevLARc)
    H = [-134, -374, 0, 2054, 5741, 8192, 5741, 2054, 0, -374, -134] / (2^13);

    %  Calculate d for current frame based on Short Term Analysis
    [LARc, CurrFrmSTResd] = RPE_frame_ST_coder(s0, PrevLARc);
    
    Prevd =  zeros(120, 4);
    Prevd(:, 1) = PrevFrmSTResd(41:160);
    Prevd(:, 2) = [PrevFrmSTResd(81:160); CurrFrmSTResd(1:40)];
    Prevd(:, 3) = [PrevFrmSTResd(121:160); CurrFrmSTResd(1:80)];
    Prevd(:, 4) = PrevFrmSTResd(1:120);
    
    %  Find R
    R = zeros(80, 1);
    b = zeros(4, 1);
    N = zeros(4, 1);
    bc = zeros(4, 1);
    for j = 1:4
        d = CurrFrmSTResd((j-1)*40+1:j*40);
        [Nj, bj] = RPE_subframe_LTE(d, Prevd(:, j));
        N(j) = Nj;
        b(j) = bj;
    end
    
    bc(b <= 0.2) = 0;
    bc(b <= 0.5 & b > 0.2) = 1;
    bc(b <= 0.8 & b > 0.5) = 2;
    bc(b > 0.8) = 3;
    Nc = N;
    
    b(bc == 0) = 0.1;
    b(bc == 1) = 0.35;
    b(bc == 2) = 0.65;
    b(bc == 3) = 1;
    
    e = zeros(160, 1);
    for j = 1:4
        dhat = b(j) * Prevd(121-N(j):160-N(j), j);
        e((j-1)*40+1:(j*40)) = CurrFrmSTResd((j-1)*40+1:j*40) - dhat;
        ddot = b(j) * CurrFrmSTResd(121-N(j):160-N(j));
        CurrFrmSTResd((j-1)*40+1:j*40) = e((j-1)*40+1:(j*40)) +  ddot;
    end
    
    CurrFrmExFull = e;
end