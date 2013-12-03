function [ language ] = predict( model, X )
%model the hmm model: have pt(i,j,l) and pi(i,l) when ith record, jth
% phonim, l language
%X one dimension array for classify what language
language = 0;
%maximum likelihood
ml = -Inf;

n,m,l = size(model);

for i=1:l;
    sum = log(model.pi(X(1),l));
    for j=2:size(X,1);
        sum = sum+ log(model.pt(X(j),X(j+1),l));
    end
    
    if sum>ml;
        ml = sum;
        language = l;
    end
end
end

