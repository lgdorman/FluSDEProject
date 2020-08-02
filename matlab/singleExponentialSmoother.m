function smoothData = singleExponentialSmoother(data)
% Calculates single exponentially smoothed data. Typically includes weight parameter
% alpha, but for our purposes alpha=1

    alpha = 1;
    n = length(data);
    smoothData = zeros(n,1);
    smoothData(2) = data(1);
    for i = 3:n
        smoothData(i) = alpha*data(i-1) + (1-alpha)*smoothData(i-1);
    end
end

