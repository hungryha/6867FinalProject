function [value] = b(o,u,sigma)
% o,u,sigma is vector of size P
P = size(o,2);
%Mahalanobis distance
d = 0;
for i=1:P;
    d = d + ((o(i)-u(i))/sigma(i))^2;
end
d = d/2;
value = exp(-d)/((2*pi)^(P/2));
for i=1:P;
    value = value/sigma(i);
end

end

