function [ bet ] = betaNotUse( model, o )
% o is TxP dimensions
% model has pi (N), a (NxN), u (NxP), sigma (NxP)
% return beta (TxN)

[T,P] = size(o);
N = size(model.pi,1);
bet = zeros(T,N);

% beta T
for j=1:N;
    bet(T,j) = 1;
end

% beta t
for t=linspace(T-1,1,T-1); %basic for from T-1 to 1
    sum = 0;
    for i=1:N;
        for j=1:N;
            bet(t,i) = bet(t,i) + model.a(i,j) * b(o(t+1,:), model.u(j,:), model.sigma(j,:)) * bet(t+1,j);
        end
        sum = sum + bet(t,i);
    end
    
    %scale
    for i=1:N;
        bet(t,i) = bet(t,i)/sum;
    end
end
end
