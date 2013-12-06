function [ language ] = predict_hmm( model, X )
%X(TxP)

language = 0;
%maximum likelihood
ml = -Inf;

for i=1:size(model.lang,1);
    temp = likelihood(model.lang{i},X);
    if temp>ml;
        ml = temp;
        language = i;
    end
end

end

