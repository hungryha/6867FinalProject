% models is a 10 by 10 upper triangular array of oao svm classifiers
% tests min(200, limit) files per language
% one against one, majority vote
function[test_error, errors, classifications] = test_svm_oao(models, feature_extraction_handle)
  % representative_feature
  top_k_clusters = 5;
  num_clusters = 10;

  % representative_features_topbot 
  topcutoff = 3;
  botcutoff = 3;
  topbot_numclusters = 15;
  
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

  for i=1:length(lang)
    num_tests = test_sizes(i);
    % randomly chooses num_tests test cases for current language
    % randomly permute max_test_sizes, select test_sizes filenames
    perm = randperm(max_test_sizes(i), test_sizes(i)); 
    for j=1:num_tests;
      file_num = perm(j) + initial_filename(i);
      filepath = char(strcat(path,lang(i),'_test_files/',lang(i),'-',num2str(file_num), '.wav'));

      try

        % different feature vectors 
        if strcmp(func2str(feature_extraction_handle),'representative_features') == 1 
          features = feature_extraction_handle(filepath, top_k_clusters, num_clusters);
        elseif strcmp(func2str(feature_extraction_handle), 'representative_features_topbot') == 1
          features = feature_extraction_handle(filepath, topcutoff, botcutoff, topbot_numclusters);
        else 
        end

        [output, predictions] = get_prediction(models, transpose(features));

      catch err
        output = 0;
        predictions = [];
      end

      if output ~= i
        num_wrong = num_wrong + 1;
        errors(i) = errors(i) + 1;
      end

      if output == 0
        classifications(i, 11) = classifications(i, 11) + 1;
      else
        classifications(i, output) = classifications(i, output) + 1;
      end
    
    end
    
    % error per language
    errors(i) = errors(i) / num_tests;
    display(sprintf('Error for %s: %s', lang{i}, num2str(errors(i))));
  end 

  % total error
  test_error = num_wrong / sum(test_sizes);
end

