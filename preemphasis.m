% Function for Preeemphasis
function s = preemphasis(sof, beta)
    beta_sof = beta * [0; sof(1:length(sof)-1)];
    s = sof - beta_sof;
end