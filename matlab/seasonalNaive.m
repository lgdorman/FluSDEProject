function smoothData = seasonalNaive(data, nPoints)
% use data from previous year as current data

    alpha = 1;
    n = length(data);
    smoothData = zeros(nPoints,1);
    for i = 53:nPoints
        if i <= n+52
            smoothData(i) = alpha*data(i-52) + (1-alpha)*smoothData(i-1);
        else
            % projecting more than a year out, loop the estimate
            smoothData(i) = smoothData(i-52);
        end
    end
end
