% model = gen_nearest_neighbor_model()
function [model] = gen_nearest_neighbor_pca(pca_limit)
path = '~/courses/fall13/6.867/project/training_data/';
lang = {'de';'dutch';'el';'english';'es';'french';'he';'italian';'portuguese';'russian'};
x = [];
y = [];
training_sizes = [2000; 2000; 658; 2000; 2000; 2000; 200; 2000; 1991; 700]; 
samples_per_lang = min(training_sizes);

for i=1:10;
  for j=1:samples_per_lang;
    
    features = extract_feature_from_wav(char(strcat(path,lang(i),'_training_files/',lang(i),'-',num2str(j), '.wav')));

    reduced_features = pca_features(transpose(features), pca_limit);
     
    x = [x;reduced_features];
    y = [y;ones(size(reduced_features,1),1).*i];
  end
end

model = ClassificationKNN.fit(x,y);
end
