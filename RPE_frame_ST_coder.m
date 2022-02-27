% Function for Short Term Analysis
function [LARc, coeff, CurrFrmSTResd] = RPE_frame_ST_coder(sof, prevLARc)
%     alpha = 32735 * 2^(-15);
%     beta = 28180 * 2^(-15);
    A = [20; 20; 20; 20; 13.637; 15; 8.334; 8.824];
    B = [0; 0; 4; -5; 0.184; -3.5; -0.666; -2.235];

    [r, R] = auto_corr(sof);
    a = R\r;
    a = [1; -a];
    larc = coeff2LAR(a, A, B);
    coeff = LAR2coeff(prevLARc, larc, A, B);
    d = short_term_residual(sof, coeff);
    
    LARc = larc;
    CurrFrmSTResd = d;
end