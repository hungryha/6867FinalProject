%three dimensional, normalize according to first and third dimension (row and language)
function [normal] = nomalize(X)
n,m,l = size(X);
normal = zeros(n,m,l);
for k=1:l;
    for i=1:n;
        sum = 0;
        for j=1:m;
            sum = sum + X(i,j,k);
        end

        for j=1:m;
            normal(i,j,k) = X(i,j,k)/sum;
        end
    end
end
end
