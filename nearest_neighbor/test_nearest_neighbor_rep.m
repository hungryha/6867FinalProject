% tests nearest neighbor classifier using rep feature vectors
% model = gen_nearest_neighbor_rep()
function[test_error, errors] = test_nearest_neighbor_rep(model, numneighbor)
top_k_clusters = 5;
num_clusters = 10;
path = '~/courses/fall13/6.867/project/test_data/';
%lang = {'de';'dutch';'el';'english';'es';'french';'he';'italian';'portuguese';'russian'};
%initial_filename = [2001, 2001, 659, 2001, 2001, 2001, 201, 2001, 1992, 701];
lang = {'de';'dutch';'el';'english';'es';'french';'italian';'portuguese';'russian'};
initial_filename = [2001, 2001, 659, 2001, 2001, 2001, 2001, 1992, 701];

test_sizes = [1000, 1000, 219, 1000, 1000, 1000, 67, 1000, 663, 223];
x = [];
y = [];
num_wrong = 0;
model.NumNeighbors = numneighbor;
model
errors = zeros(length(lang), 1)
for i=1:length(lang);
  for j=0:199;
    file_num = j + initial_filename(i);
    file_path = char(strcat(path,lang(i),'_test_files/',lang(i),'-',num2str(file_num), '.wav'));
    try

      features = representative_features(file_path, top_k_clusters, num_clusters);
      prediction = predict(model, transpose(features));
    % gaussian not converging, count as mistake
    catch err

      prediction = 0;
    end
    

    if prediction ~= i;
      errors(i, 1) = errors(i, 1) + 1;
      num_wrong = num_wrong + 1
    end

  end
end

test_error = num_wrong / (200*length(lang));
end

