function [ alp, bet, c ] = getAlphaBeta( model, o )
% o is TxP dimensions
% model has pi (N), a (NxN), u (NxP), sigma (NxP)
% return alpha (TxN)

[T,P] = size(o);
N = size(model.pi,1);
alp = zeros(T,N);
c = zeros(T,1);

% alpha 1
for j=1:N;
    alp(1,j) = model.pi(j) * b(o(1,:), model.u(j,:), model.sigma(j,:));
    c(1) = c(1) + alp(1,j);
end
%scale/normalize
for j=1:N;
    alp(1,j) = alp(1,j)/c(1);
end

%alpha t
for t=2:T;
    for i=1:N;
        for j=1:N;
            alp(t,i) = alp(t,i) + alp(t-1,j) * model.a(j,i);
        end
        alp(t,i) = alp(t,i) * b(o(t,:), model.u(i,:), model.sigma(i,:));
        c(t) = c(t) + alp(t,i);
    end
    
    %scale
    for i=1:N;
        alp(t,i) = alp(t,i)/c(t);
    end
end

bet = zeros(T,N);

% beta T
for j=1:N;
    bet(T,j) = 1;
end

% beta t
for t=linspace(T-1,1,T-1); %basic for from T-1 to 1
    for i=1:N;
        for j=1:N;
            bet(t,i) = bet(t,i) + model.a(i,j) * b(o(t+1,:), model.u(j,:), model.sigma(j,:)) * bet(t+1,j);
        end
    end
    
    %scale
    for i=1:N;
        bet(t,i) = bet(t,i)/c(t+1);
    end
end

end