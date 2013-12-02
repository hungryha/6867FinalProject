function [param] = em(x,m,l)

param = initialize(x,m,l);
[param,L] = one_em_iter(x,param);

L0 = L-abs(L);
while (L-L0>abs(L)*1e-6),
  %Stop iteration when the increase of loglikelihood is small enough
  L0 = L;
  [param,L] = one_em_iter(x,param);
end;

param.loglik = L;

% --------------------------------------------
function [param] = initialize(x,m,l)

[n, len] = size(x);

[xr,I] = sort(rand(n,1));
param.mu = zeros(m, len);

% randomly select m points as initial means.
for j=1:m
    param.mu(j,:) = x(I(j),:); 
end
param.p = ones(m,1)/m;

% initialize variances based on the variance of the whole data set v.
% note that in principle all v_k (k=1..l) can't be greater than v.
v = var(x);
param.v = zeros(l,len);
for k=1:l
    for i = 1:len
        param.v(k,i) = v(1,i)/2^k;
    end
end

param.q = ones(l,1)/l;

% --------------------------------------------
function [param,loglik] = one_em_iter(x,param);

[n, len] = size(x);

m = length(param.p);
l = length(param.q);

%convert the data points into a row vector.
%x = reshape(x,length(x),len);

%logp is a n x (m*l) matrix
%n is the number of data points

logp = zeros(size(x,1),m*l);

%ind is the index for mixture component
ind = 1;
for j=1:m,
  for k=1:l,
    %evalgauss returns a column vector that contains the log probability of each data
    %point with respect to certain mixture component.
    logp(:,ind)=evalgauss(x,param.mu(j,:),param.v(k,:))+log(param.p(j)*param.q(k));
    ind = ind+1;
  end;
end;

logpmax = max(logp,[],2);

% we also want to return the log-likelihood of the data

% Compute the log sum in this way to reduce numerical errors.
% Think of the case when we have two log-probabilities: -1001 and -1002
% It would be better to do [-1001 + log(1+e^-1)] rather than [log(e^-1001+e^-1002)]
loglik = sum(logpmax + log(sum(exp(logp-logpmax*ones(1,m*l)),2)));

%The softmax function compute the posterior probability of each mixture component.
%pos(n,ind) denotes the posterior porbability of ind^th mixture component the on the n^th data point.
pos = softmax(logp); % posterior assignments

% solve for p and q
% param.p is a column vector that stores all p_j (j=1...m)
% param.q is a column vector that stores all q_k (k=1...l)

%%%%%%%%%%%%%%%Solving p and q Here%%%%%%%%%%%%%%%%%%%%

n = size(x);

for y = 1:m
  param.p(y) = 0;
  for i = 1:n
    for z = 1:l
      param.p(y) = param.p(y) + pos(i, (y-1)*l+z);
    end
  end
  param.p(y) = param.p(y) / n(1);
end


for z = 1:l
  param.q(z) = 0;
  for i = 1:n
    for y = 1:m
      param.q(z) = param.q(z) + pos(i, (y-1)*l+z);
    end
  end
  param.q(z) = param.q(z) / n(1);
end

%%%%%%%%%%%%Finish Solving for p and q%%%%%%%%%%%%%%%%%%

% solve for the means (fixed variances)
% param.mu is a column vector that stores all mu_j (j=1...m)

%%%%%%%%%%%%%Solving for mu Here%%%%%%%%%%%%%%%%%%

for y = 1:m
  top = 0;
  bottom = 0;
  for i = 1:n
    for z = 1:l
      top = top + pos(i, (y-1)*l + z) * x(i) / param.v(z)^2;
      bottom = bottom + pos(i, (y-1)*l + z) / param.v(z)^2;
    end
  end
  param.mu(y) = top/bottom;
end


%%%%%%%%%%%Finish Solving for mu%%%%%%%%%%%%%%%%%%

% solve for the variances (fixed means)
% S stores the statistics of each variance parameters
S = zeros(l,len);
ind = 1;
for j=1:m,
  for k=1:l,
      for idx = 1:n
          for i = 1:len
              S(k,i) = S(k,i) + pos(idx,ind)'*(x(idx,i)-param.mu(j))^2;
          end
      end
    ind = ind + 1;
  end;
end;

ntot = sum(reshape(sum(pos,1),l,m),2);

%Estimate the variance
for i = 1:len
    param.v(i,:) = S(i,:)/ntot(i,1);
end

% --------------------------------------------
function [loglik] = evalgauss(x,mu,v)
[n, len] = size(x);
loglik = ones(n, 1);
for i = 1:n
    for j = 1:len
        lik = -0.5*(x(i,j)-mu(j))^2/v(j) - 0.5*log(2*pi*v(j)^2);
        loglik(i,1) = loglik(i,1) * lik;
    end
end