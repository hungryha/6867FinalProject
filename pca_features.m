% reduces dimensiality of feature vectors
% full_data = frames x features_dim
% reduced_data = frames x limit
function [reduced_data] = pca_features(full_data, limit)
  coeff = pca(full_data);
  reduced_data = full_data*coeff;
  reduced_data = reduced_data(:,1:limit);
end
