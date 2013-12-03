function [loglik] = evalgauss(x,mu,v)
[n, len] = size(x);
loglik = ones(n, 1);
if all(eig(v)) > 0
    for i = 1:n
        x_data = x(i, :);
        e = -0.5*(x_data - mu) * inv(v) * (x_data - mu)';
        base = 1/((2*pi)^(len/2) * det(v) ^ 0.5);
        loglik(i, 1) = log(base * exp(e));
    end
else
    for i = 1:n
        x_data = x(i, :);
        e = -0.5*(x_data - mu) * pinv(v) * (x_data - mu)';
        eigs = eig(2*pi*v);
        prod = 1;
        for j=1:size(eigs,1)
            if eigs(j,1) > 0
                prod = prod * eigs(j,1);
            end
        end
        
        base = 1/(prod ^ 0.5);
        loglik(i, 1) = log(base * exp(e));
    end
end