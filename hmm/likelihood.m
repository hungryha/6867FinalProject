function [ prob ] = likelihood( model, o )
% o (TxP)
% return the likelihood of this observation to the model
[T,P] = size(o);
N = size(model.pi,1);
[alp,bet,c] = getAlphaBeta(model, o);
prob = 0;
for i=1:T;
    prob = prob + log(c(i));
end
end

