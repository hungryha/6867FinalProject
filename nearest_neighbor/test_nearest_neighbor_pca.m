% tests nearest neighbor classifier
% model = gen_nearest_neighbor_model()
% test_error(model, numneighbor)
function [test_error, errors, classifications] = test_nearest_neighbor_pca(model, numneighbor, pca_limit)
path = '~/courses/fall13/6.867/project/test_data/';
lang = {'de';'dutch';'el';'english';'es';'french';'he';'italian';'portuguese';'russian'};
initial_filename = [2000, 2000, 658, 2000, 2000, 2000, 200, 2000, 1991, 700];
max_test_sizes = [1000, 1000, 219, 1000, 1000, 1000, 67, 1000, 663, 223];

test_sizes = zeros(10,1);
for i=1:length(lang)
  test_sizes(i,1) = min(100, max_test_sizes(i));
end

num_wrong = 0;
errors = zeros(length(lang), 1);
% shows svm classification for each lang
% row = target language, col = classifications
% 11 is for other
classifications = zeros(11,11);


model.NumNeighbors = numneighbor;
model


for i=1:10;
  num_tests = test_sizes(i);
  % randomly chooses num_tests test cases for current language
  % randomly permute max_test_sizes, select test_sizes filenames
  perm = randperm(max_test_sizes(i), test_sizes(i)); 

  for j=1:num_tests
    file_num = perm(j) + initial_filename(i);
    file_path = char(strcat(path,lang(i),'_test_files/',lang(i),'-',num2str(file_num), '.wav'));

    try
      features = extract_feature_from_wav(file_path);
      reduced_features = pca_features(transpose(features), pca_limit);
      lang_prediction = predict(model, reduced_features);


      buckets = zeros(10, 1);
      for k=1:length(lang_prediction);
        buckets(lang_prediction(k)) = buckets(lang_prediction(k)) + 1;
      end

      [score, final_prediction] = max(buckets);
    catch err
      final_prediction = 11;
    end

    if final_prediction ~= i;
      num_wrong = num_wrong + 1;
      errors(i) = errors(i) + 1;
    end     

    classifications(i, final_prediction) = classifications(i, final_prediction) + 1;
  end
  % error per language
  errors(i) = errors(i) / num_tests;
  display(sprintf('Error for %s: %s', lang{i}, num2str(errors(i))));


end

test_error = num_wrong / sum(test_sizes);
end
