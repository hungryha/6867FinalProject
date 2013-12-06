function [ model ] = hmm( X, Y, N )
% X{K}(TxP)
% Y(K) should be sorted
% N the number of hidden states/phonemes
%
% output model: model.lang{L} = model from training of language l 
%  Note it is {} not ()

%L number of language
L = Y(size(Y,1));
K = size(X,1);

model.lang = cell(L,1);

starting = 1;
ending = 1;
for l=1:L;
    while Y(ending)==l;
        ending = ending + 1;
        if ending>size(X,1);
            break
        end
    end
    model.lang{l} = training(X(starting:ending-1), N);
    starting = ending;
    l
end

end

