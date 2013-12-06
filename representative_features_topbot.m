% cluster each recording using gmm
% pick largest x cluster means(highest mixing proportions) as representative feature vectors for that recording
% result is a column vector
% concatenate top cutoff and lowest botcutoff  clusters
function [result] = representative_features_topbot(filepath, topcutoff , botcutoff, clusters_num)
% filepath = '/home/qlong/courses/fall13/6.867/project/training_data/english_training_files/english-1.wav';

  all_features = extract_feature_from_wav(filepath);

  [r,c] = size(transpose(all_features));
  result = [];
  % idx is column vector
  if r > clusters_num 
    [idx, centroids] = kmeans(transpose(all_features), clusters_num, 'emptyaction', 'singleton');

    num_unique = size(unique(idx),1);


    if r > c & r > clusters_num & num_unique == clusters_num
%{
      try

        gmm = gmdistribution.fit(transpose(all_features), clusters_num, 'Start', idx, 'CovType', 'diagonal', 'Regularize', 0.01);

        % take means with highest topcutoff mixing proportions
        [sorted_vals, sorted_indices] = sort(gmm.PComponents, 'descend');

        for i=1:topcutoff
          mu = transpose(gmm.mu(sorted_indices(i),:));
          result = [result;mu];
        end

        % take means with lowest botcutoff mixing proportions
        for i=clusters_num-botcutoff+1:clusters_num
          mu = transpose(gmm.mu(sorted_indices(i),:));
          result = [result;mu];
        end 


      catch err
      end
%}
      result = cluster_and_concat(transpose(all_features), topcutoff, botcutoff, clusters_num, idx);
    end
  else
    result = cluster_and_concat(transpose(all_features), topcutoff, botcutoff, clusters_num, 'randSample');
  end

end

function [result] = cluster_and_concat(data, topcutoff, botcutoff, clusters_num, start_type)

  result = [];
  try
    gmm = gmdistribution.fit(data, clusters_num, 'Start', start_type, 'CovType', 'diagonal', 'Regularize', 0.01);
    % take means with highest topcutoff mixing proportions
    [sorted_vals, sorted_indices] = sort(gmm.PComponents, 'descend');

    for i=1:topcutoff
      mu = transpose(gmm.mu(sorted_indices(i),:));
      result = [result;mu];
    end

    % take means with lowest botcutoff mixing proportions
    for i=clusters_num-botcutoff+1:clusters_num
      mu = transpose(gmm.mu(sorted_indices(i),:));
      result = [result;mu];
    end 

  catch err
  end

end
