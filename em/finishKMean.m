function [ dist ] = finishKMean( prev, now)
[m,k] = size(prev);
dist = 0;
for i=1:k;
    dist = dist + distance(prev(:,i),now(:,i));
end
end

