% Function for Offset Compensation
function sof = offset_comp(so, alpha)
    % Create Zero Like array of input to make calculations faster
    sof = zeros(length(so), 1);
    
    so_diff = diff(so);
    so_diff = [so(1); so_diff];
    sof(1) = so_diff(1);
    for i = 2:length(sof)
        sof(i) = so_diff(i) + (alpha * sof(i-1));
    end
end