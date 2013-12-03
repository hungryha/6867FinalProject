function [param] = em(x, m, init_means)

param = initialize(x, m, init_means);
[param,L] = one_em_iter(x,param);

L0 = L-abs(L);
while (L-L0>abs(L)*1e-6),
  %Stop iteration when the increase of loglikelihood is small enough
  L0 = L;
  [param,L] = one_em_iter(x,param);
end;

param.loglik = L;

% --------------------------------------------
function [param] = initialize(x,m,init_means)

param.k = m;

[n, len] = size(x);

% randomly select m points as initial means.
for k=1:m
    param.mu(k,:) = init_means(k, :); 
end

% initialize variances based on the variance of the whole data set v.
% note that in principle all v_k (k=1..l) can't be greater than v.

param.v = zeros(len,len,m);
count = zeros(m, 1);

for i=1:n
    min_k = 1;
    min_dist = (x(i,:) - param.mu(1,:)).^2;
    for k=1:m
        dist = (x(i,:) - param.mu(k,:)).^2;
        if (dist < min_dist)
            min_dist = dist;
            min_k = k;
        end
    end
    param.v(:,:,min_k) = param.v(:,:,min_k) + (x(i,:) - param.mu(min_k,:))'*(x(i,:) - param.mu(min_k,:));
    count(min_k, 1) = count(min_k, 1) + 1;
end

for k=1:m
    param.v(:,:,k) = param.v(:,:,k) / count(min_k, 1);
end


% for k=1:m
%     for i=1:n
%         param.v(:,:,k) = param.v(:,:,k) + (x(i,:) - param.mu(k,:))'*(x(i,:) - param.mu(k,:));
%     end
% end

param.p = ones(m,1)/m;

% --------------------------------------------
function [param,loglik] = one_em_iter(x,param);

[n, len] = size(x);

m = length(param.p);

%logp is a n x (m*l) matrix
%n is the number of data points

logp = zeros(n,m);

%ind is the index for mixture component
for k=1:m,
    %evalgauss returns a column vector that contains the log probability of each data
    %point with respect to certain mixture component.
    logp(:,k)=evalgauss(x,param.mu(k,:),param.v(:,:,k))+log(param.p(k));
end;

logpmax = max(logp,[],2);

% we also want to return the log-likelihood of the data

% Compute the log sum in this way to reduce numerical errors.
% Think of the case when we have two log-probabilities: -1001 and -1002
% It would be better to do [-1001 + log(1+e^-1)] rather than [log(e^-1001+e^-1002)]
loglik = sum(logpmax + log(sum(exp(logp-logpmax*ones(1,m)),2)));

%The softmax function compute the posterior probability of each mixture component.
%pos(n,ind) denotes the posterior porbability of ind^th mixture component the on the n^th data point.
pos = softmax(logp); % posterior assignments

% solve for p and q
% param.p is a column vector that stores all p_j (j=1...m)
% param.q is a column vector that stores all q_k (k=1...l)

%%%%%%%%%%%%%%%Solving p Here%%%%%%%%%%%%%%%%%%%%


n_j = zeros(m, 1);

for k = 1:m
    for i = 1:n
        n_j(k, 1) = n_j(k, 1) + pos(i, k);
    end
end

param.p = n_j / n;

%%%%%%%%%%%%Finish Solving for p and q%%%%%%%%%%%%%%%%%%

% solve for the means (fixed variances)
% param.mu is a column vector that stores all mu_j (j=1...m)


%%%%%%%%%%%%%Solving for mu Here%%%%%%%%%%%%%%%%%%

for k = 1:m
  param.mu(k,1) = 0;
  for i = 1:n
      param.mu(k,:) = param.mu(k,:) + pos(i,k) * x(i,:);
  end
  param.mu(k,:) = param.mu(k,:) / n_j(k,1);
end

%%%%%%%%%%%Finish Solving for mu%%%%%%%%%%%%%%%%%%

% solve for the variances (fixed means)
% S stores the statistics of each variance parameters

for k = 1:m
  param.v(:,:,k) = zeros(len, len);
  for i = 1:n
      param.v(:,:,k) = param.v(:,:,k) + pos(i,k) * (x(i,:) - param.mu(k,:))' * (x(i,:) - param.mu(k,:));
  end
  param.v(:,:,k) = param.v(:,:,k) / n_j(k,1);
end