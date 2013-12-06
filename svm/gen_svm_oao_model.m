% one against one svm model
function [data, groups] = gen_svm_oao_model(lang_index1, lang_index2, pca_limit)

path = '~/courses/fall13/6.867/project/training_data/';
lang = {'de';'dutch';'el';'english';'es';'french';'he';'italian';'portuguese';'russian'};
training_sizes = {2000; 2000; 658; 2000; 2000; 2000; 200; 2000; 1991; 700};
data = [];
groups = [];

numsamples = min(training_sizes(lang_index1), training_sizes(lang_index2));

% for lang_index1
for j=1:numsamples;

  % feature_dim x frames
  features = extract_feature_from_wav(char(strcat(path,lang(lang_index1),'_training_files/',lang(lang_index1),'-',num2str(j), '.wav')));
  
  

  % frames x pca_limit
  reduced_features = pca_features(transpose(features), pca_limit);

  % each row is an observation
  % ex. 100 x 72
  data = [data;reduced_features];

  % column vector of labels
  % 2 for "all other", 1 for target language
  groups = [groups;ones(size(reduced_features,1),1).*lang_index1]; 
    
end
%model = svmtrain(data, groups, 'Kernel_Function', kernel_function);

% for lang_index2
for j=1:numsamples;

  % feature_dim x frames
  features = extract_feature_from_wav(char(strcat(path,lang(lang_index2),'_training_files/',lang(lang_index2),'-',num2str(j), '.wav')));
  

  % frames x pca_limit
  reduced_features = pca_features(transpose(features), pca_limit);

  % each row is an observation
  % ex. 100 x 72
  data = [data;reduced_features];

  % column vector of labels
  % 2 for "all other", 1 for target language
  groups = [groups;ones(size(reduced_features,1),1).*lang_index2]; 
    
end

end

