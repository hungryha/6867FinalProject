function [ model ] = training( O, N ) 
% O is {K}(TxP) when K is the number of records, T is vary, the length of records 
%  and P is the dimension of feature vector(observation)
% N the number of hidden state/ phoneme
%
% return model: pi (N), a (NxN), u (NxP), sigma (NxP)
%  pi: initial probability
%  a: trasitional probability
%  u,sigma: emission probability

K = size(O,1);
P = size(O{1},2);

%pick at 1/4 to 3/4 of each record
for i=1:K;
    T = size(O{i},1);
    O{i} = O{i}(floor(3*T/8)+1:floor(5*T/8),:);
end
 
model.pi = ones(N,1).*(1/N);
model.a = ones(N,N).*(1/(N^2));
model.u = zeros(N,P);
model.sigma = ones(N,P);

%random
sum =0;
for i=1:N;
    model.pi(i) = (rand()*0.2+0.9)/N;
    sum = sum + model.pi(i);
end
for i=1:N;
    model.pi(i) = model.pi(i)/sum;
end

sum=0;
for i=1:N;
    for j=1:N;
        model.a(i,j) = (rand()*0.2+0.9)/(N^2);
        sum = sum + model.a(i,j);
    end
end
for i=1:N;
    for j=1:N;
        model.a(i,j) = model.a(i,j)/sum;
    end
end

for i=1:N;
    for j=1:P;
        model.u(i,j) = (rand()-0.5)/5;
    end
end

for i=1:N;
    for j=1:P;
        model.sigma(i,j) = 0.9 + rand()*0.2;
    end
end

ml = -Inf;
'Start training'
newML = fullLogLikelihood(model,O);
newML

count = 0 ;
while newML-ml>=1 & count<5 ;
    count = count + 1;
    newModel.pi = zeros(N,1);
    newModel.a = zeros(N,N);
    newModel.u = zeros(N,P);
    newModel.sigma = zeros(N,P);

    [pqgo,pqqgo] = getP(model,O) ;
    %pqgo = pqgo(model,O);
    %pqqgo = pqqgo(model,O);

    %update pi
    for i=1:N;
        for l=1:K;
            newModel.pi(i) = newModel.pi(i) + pqgo{l}(1,i);
        end
        newModel.pi(i) = newModel.pi(i)/K;
    end

    %update a
    for i=1:N;
        for j=1:N;
            sum = 0;
            for l=1:K;
                T = size(O{l},1);
                for t=1:T-1;
                    newModel.a(i,j) = newModel.a(i,j) + pqqgo{l}(t,i,j);
                    sum = sum + pqgo{l}(t,i);
                end
            end
            newModel.a(i,j) = newModel.a(i,j)/sum;
        end
    end
    
    %update u
    for i=1:N;
        for n=1:P;
            sum = 0;
            for l=1:K;
                T = size(O{l},1);
                for t=1:T;
                    newModel.u(i,n) = newModel.u(i,n) + pqgo{l}(t,i)*O{l}(t,n);
                    sum = sum + pqgo{l}(t,i);
                end
            end
            newModel.u(i,n) = newModel.u(i,n)/sum;
        end
    end
    
    %update sigma
    for i=1:N;
        for n=1:P;
            sum = 0;
            for l=1:K;
                T = size(O{l},1);
                for t=1:T;
                    newModel.sigma(i,n) = newModel.sigma(i,n) + pqgo{l}(t,i)*((O{l}(t,n) - newModel.u(i,n))^2);
                    sum = sum + pqgo{l}(t,i);
                end
            end
            newModel.sigma(i,n) = newModel.sigma(i,n)/sum;
            newModel.sigma(i,n) = newModel.sigma(i,n)^0.5;
        end
    end
    ml = newML;
    newML = fullLogLikelihood(newModel, O);
    newML
    %newModel.pi
    %newModel.a
    %newModel.u
    %newModel.sigma
    model = newModel;
end
end

function [prob] = fullLogLikelihood(model, O)
% return the likelihood of the model  to the O{K}(TxP)
K = size(O,1);
prob = 0;
for i=1:K;
    prob = prob + likelihood(model,O{i});
end
end

function [prob] = pqgo(model,O)
% prob {K}(TxN)
%  prob(l,t,i) = P(qt=i|O{l})
K = size(O,1);
[N,P] = size(model.u);
prob = cell(K,1);

for l=1:K;
    [alp,bet,c] = getAlphaBeta(model,O{l});
    T = size(O{l},1);
    C = zeros(T,N);
    for t=1:T;
        sum = 0;
        for i=1:N;
            C(t,i) = alp(t,i)*bet(t,i);
            sum = sum + C(t,i);
        end
        
        for i=1:N;
            C(t,i) = C(t,i)/sum;
        end
    end
    prob{l} = C;
end

end

function [prob] = pqqgo(model, O)
% prob {K}(T-1xNxN)
%  prob(l,t,i,j) = P(qt=i,qt+1=j|O{l})
K = size(O,1);
[N,P] = size(model.u);
prob = cell(K,1);

for l=1:K;
    [alp,bet,c] = getAlphaBeta(model,O{l});
    T = size(O{l},1);
    C = zeros(T,N,N);
    for t=1:T-1;
        sum = 0;
        for i=1:N;
            for j=1:N;
                C(t,i,j) = alp(t,i) * model.a(i,j) * bet(t+1,j) * b(O{l}(t+1,:), model.u(j,:), model.sigma(j,:));
                sum = sum + C(t,i,j);
            end
        end
        
        for i=1:N;
            for j=1:N;
                C(t,i,j) = C(t,i,j)/sum;
            end
        end
    end
    prob{l} = C;
end

end
   
function [pqgo, pqqgo] = getP(model, O)
K = size(O,1);
[N,P] = size(model.u);
pqgo = cell(K,1);
pqqgo = cell(K,1);

for l=1:K;
    [alp,bet,c] = getAlphaBeta(model,O{l});
    T = size(O{l},1);
    C = zeros(T,N);
    for t=1:T;
        sum = 0;
        for i=1:N;
            C(t,i) = alp(t,i)*bet(t,i);
            sum = sum + C(t,i);
        end
        
        for i=1:N;
            C(t,i) = C(t,i)/sum;
        end
    end
    pqgo{l} = C;

    C = zeros(T,N,N);
    for t=1:T-1;
        sum = 0;
        for i=1:N;
            for j=1:N;
                C(t,i,j) = alp(t,i) * model.a(i,j) * bet(t+1,j) * b(O{l}(t+1,:), model.u(j,:), model.sigma(j,:));
                sum = sum + C(t,i,j);
            end
        end
        
        for i=1:N;
            for j=1:N;
                C(t,i,j) = C(t,i,j)/sum;
            end
        end
    end
    pqqgo{l} = C;
end

end
