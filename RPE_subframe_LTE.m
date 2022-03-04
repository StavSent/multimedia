function [N, b] = RPE_subframe_LTE(d, Prevd)
    R = zeros(81, 1);
    
    for l = 40:120
        R(l-39) = sum(d .* Prevd(121-l:160-l));
    end
    [maxR, index] = max(R);
    N = index + 39;
    b = maxR / sum(Prevd(index:N).^2);
end