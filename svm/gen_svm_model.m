% one against all svm model
function [data, groups] = gen_svm_oaa_model(language_index, pca_limit)

path = '~/courses/fall13/6.867/project/training_data/';
lang = {'de';'dutch';'el';'english';'es';'french';'he';'italian';'portuguese';'russian'};
data = [];
groups = [];

group_label = 2;
for i=1:10;
  for j=1:200;

    if i == language_index;
      group_label = 1; 
    else
      group_label = 2;
    end
 
    % feature_dim x frames
    features = extract_feature_from_wav(char(strcat(path,lang(i),'_training_files/',lang(i),'-',num2str(j), '.wav')));
    

    % frames x pca_limit
    reduced_features = pca_features(transpose(features), pca_limit);

    % each row is an observation
    % ex. 100 x 72
    data = [data;reduced_features];

    % column vector of labels
    % 2 for "all other", 1 for target language
    groups = [groups;ones(size(reduced_features,1),1).*group_label]; 
      
  end
end
%model = svmtrain(data, groups, 'Kernel_Function', kernel_function);

end

