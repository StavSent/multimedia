function [r, R] = auto_corr(s)
    r = zeros(9, 1);
    
    for i = 0:8
        r(i+1) = sum(s(1:length(s)-i).*s(1+i:length(s)));
    end
    
    R = toeplitz(r(1:8), r(1:8));
    r = r(2:9);
end