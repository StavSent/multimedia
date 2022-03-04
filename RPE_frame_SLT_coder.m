function [LARc, Nc, bc, CurrFrmExFull, CurrFrmSTResd] = RPE_frame_SLT_coder(s0, PrevFrmSTResd, PrevLARc)
    H = [-134, -374, 0, 2054, 5741, 8192, 5741, 2054, 0, -374, -134] / (2^13);

    %  Calculate d for current frame based on Short Term Analysis
    [LARc, CurrFrmSTResd] = RPE_frame_ST_coder(s0, PrevLARc);
    
    %  Find R
    R = zeros(80, 1);
    b = zeros(4, 1);
    N = zeros(4, 1);
    bc = zeros(4, 1);
    for j = 1:4
        for l = 40:120
            %  Is this periodic?
            PrevFrmSTResdPadded = [PrevFrmSTResd(length(PrevFrmSTResd)-l:length(PrevFrmSTResd)); PrevFrmSTResd];
            R(l) = sum(CurrFrmSTResd(((j-1)*40)+1:(j*40)) .* PrevFrmSTResdPadded(((j-1)*40)+1:(j*40)));
        end
        [~, index] = max(R);
        N(j) = index + 40;
        PrevFrmSTResdPadded = [PrevFrmSTResd(length(PrevFrmSTResd)-N(j):length(PrevFrmSTResd)); PrevFrmSTResd];
        b(j) = sum(CurrFrmSTResd(((j-1)*40)+1:(j*40)) .* PrevFrmSTResdPadded(((j-1)*40)+1:(j*40)));
        b(j) = b(j) / sum(PrevFrmSTResdPadded(((j-1)*40)+1:(j*40)) .^ 2);
    end
    
    bc(b <= 0.2) = 0;
    bc(b <= 0.5 & b > 0.2) = 1;
    bc(b <= 0.8 & b > 0.5) = 2;
    bc(b > 0.8) = 3;
    Nc = N;
    
    e = zeros(160, 1);
    x = zeros(160, 1);
    for j = 1:4
        PrevFrmSTResdPadded = [PrevFrmSTResd(length(PrevFrmSTResd)-N(j):length(PrevFrmSTResd)); PrevFrmSTResd];
        e((j-1)*40+1:(j*40)) = CurrFrmSTResd(((j-1)*40)+1:(j*40)) - b(j) * PrevFrmSTResdPadded(((j-1)*40)+1:(j*40));
        
        ePadded = [zeros(5, 1); e((j-1)*40+1:(j*40)); zeros(5, 1)];
        for i = 1:40
            x((j-1)*40+i) = H * ePadded(i+10:-1:i);
        end
    end
   
    xm = zeros(13, 4);
    xm(:, 1) = 
end