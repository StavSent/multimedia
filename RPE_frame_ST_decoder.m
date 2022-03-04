function sro = RPE_frame_ST_decoder(LARc, CurrFrmSTResd, PrevLARc)
    A = [20; 20; 20; 20; 13.637; 15; 8.334; 8.824];
    B = [0; 0; 4; -5; 0.184; -3.5; -0.666; -2.235];
    beta = 28180 * 2^(-15);
    
    coeff = LAR2coeff(PrevLARc, LARc, A, B);
    coeff = -coeff(2:9, :);
    sr = zeros(160:1);
%     sr(1:13) = d(1:13) + [[0; s(1:12)], [0; 0; s(1:11)], [0; 0; 0; s(1:10)],...
%               [0; 0; 0; 0; s(1:9)], [0; 0; 0; 0; 0; s(1:8)],...
%               [0; 0; 0; 0; 0; 0; s(1:7)], [0; 0; 0; 0; 0; 0; 0; s(1:6)],...
%               [0; 0; 0; 0; 0; 0; 0; 0; s(1:5)]] * coeff(:, 1);
%     sr(14:27) = d(14:27) + [s(13:26), s(12:25), s(11:24), s(10:23),... 
%                s(9:22), s(8:21), s(7:20), s(6:19)] * coeff(:, 2);
%     sr(28:40) = d(28:40) + [s(27:39), s(26:38), s(25:37), s(24:36),... 
%                s(23:35), s(22:34), s(21:33), s(20:32)] * coeff(:, 3);
%     sr(41:160) = d(48:160) + [s(47:159), s(46:158), s(45:157), s(44:156),... 
%                s(43:155), s(42:154), s(41:153), s(40:152)] * coeff(:, 4);
    sr(1) = CurrFrmSTResd(1);
    sr(2) = CurrFrmSTResd(2) + sr(1) * coeff(1, 1);
    sr(3) = CurrFrmSTResd(3) + (sr(2:-1:1) * coeff(1:2, 1));
    sr(4) = CurrFrmSTResd(4) + (sr(3:-1:1) * coeff(1:3, 1));
    sr(5) = CurrFrmSTResd(5) + (sr(4:-1:1) * coeff(1:4, 1));
    sr(6) = CurrFrmSTResd(6) + (sr(5:-1:1) * coeff(1:5, 1));
    sr(7) = CurrFrmSTResd(7) + (sr(6:-1:1) * coeff(1:6, 1));
    sr(8) = CurrFrmSTResd(8) + (sr(7:-1:1) * coeff(1:7, 1));
    for i = 9:160
        if (i <= 13) 
            sr(i) = CurrFrmSTResd(i) + sr(i-1:-1:i-8) * coeff(:, 1);
        elseif (i <= 27)
            sr(i) = CurrFrmSTResd(i) + sr(i-1:-1:i-8) * coeff(:, 2);
        elseif (i <= 40)
            sr(i) = CurrFrmSTResd(i) + sr(i-1:-1:i-8) * coeff(:, 3);
        elseif (i <= 160)
            sr(i) = CurrFrmSTResd(i) + sr(i-1:-1:i-8) * coeff(:, 4);
        end
    end
           
    % Postprocessing
    sro = zeros(length(sr), 1);
    sro(1) = sr(1);
    for i = 2:length(sr)
        sro(i) = sr(i) + beta * sro(i-1);
    end
end