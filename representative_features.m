% cluster each recording using gmm
% pick largest x cluster means(highest mixing proportions) as representative feature vectors for that recording
% result is a column vector
function [result] = representative_features(filepath, top_x_clusters, clusters_num)
% filepath = '/home/qlong/courses/fall13/6.867/project/training_data/english_training_files/english-1.wav';

  all_features = extract_feature_from_wav(filepath);

  [r,c] = size(transpose(all_features));
  result = [];
  % idx is column vector
  if r > clusters_num 
    [idx, centroids] = kmeans(transpose(all_features), clusters_num, 'emptyaction', 'singleton');

    num_unique = size(unique(idx),1);


    if r > c & r > clusters_num & num_unique == clusters_num
      try
        gmm = gmdistribution.fit(transpose(all_features), clusters_num, 'Start', idx, 'CovType', 'diagonal', 'Regularize', 0.01);

        % top_x_clusters means with highest mixing proportions
        [sorted_vals, sorted_indices] = sort(gmm.PComponents, 'descend');

        for i=1:top_x_clusters
          mu = transpose(gmm.mu(sorted_indices(i),:));
          result = [result;mu];
        end

      catch err

      end
    end
  end
end
