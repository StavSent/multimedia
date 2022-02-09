function [r, R] = auto_corr(s)
    r = zeros(9, 1);
    
    for i = 0:8
        r(i+1) = sum(s(1:length(s)-i).*s(1+i:length(s)));
    end
    
    R = [r(1) r(2) r(3) r(4) r(5) r(6) r(7) r(8);
         r(2) r(1) r(2) r(3) r(4) r(5) r(6) r(7);
         r(3) r(2) r(1) r(2) r(3) r(4) r(5) r(6);
         r(4) r(3) r(2) r(1) r(2) r(3) r(4) r(5);
         r(5) r(4) r(3) r(2) r(1) r(2) r(3) r(4);
         r(6) r(5) r(4) r(3) r(2) r(1) r(2) r(3);
         r(7) r(6) r(5) r(4) r(3) r(2) r(1) r(2);
         r(8) r(7) r(6) r(5) r(4) r(3) r(2) r(1);];
     r = r(2:9);
end