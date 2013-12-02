% outputs a vector of the k means
% input:
% k -- the number of clusters we want to have
% data -- an array of d dimensional vectors, each vector
%         representing a data point
function [result] = kmeans(k, data)

[m, n] = size(data);
k_means = zeros(m, k);

% initialize using k-means++
num_means = 0;
mean_index = randi([1, n]);
k_means(:, 1) = data(:, mean_index);
while num_means < k
  % construct the probabilities
  P = ones(n, 1);
  for i = 1:n
      for j = 1:k
          dist = sqrt(sum((data(:, i) - k_means(:, j)).^2));
          if (sum(k_means(:, j)) > 0) & (P(i, 1) > dist)
              P(i, 1) = dist;
          end
      end
  end
  P = P/sum(P);
  % pick the mean with the most probability
  index = sum(rand() > cumsum(P)) + 1;
  num_means = num_means + 1;
  k_means(:, num_means) = data(:, index);
end

% iterative k-means clustering

prev_kmin = zeros(m, k);
while prev_kmin ~= k_means
  prev_kmin = k_means;

  % this is actually the sum of the vectors for each cluster
  new_cluster = zeros(m, k);
  count = zeros(k, 1);

  % re-cluster
  for i = 1:n
    data_point = data(:,i);
    min_distance = sum((data_point - k_means(:, 1)).^2);
    min_cluster = 1;
    for j = 1:k
      distance = sum((data_point - k_means(:, j)).^2);
      if distance < min_distance
        min_distance = distance;
        min_cluster = j;
      end
    end
    
    new_cluster(:, min_cluster) = new_cluster(:, min_cluster) + data_point;
    count(min_cluster, 1) = count(min_cluster, 1) + 1;
  end

  % recalculate the k means
  for i = 1:k
      k_means(:, i) = new_cluster(:, i) / count(i, 1);
  end
end

result = k_means;