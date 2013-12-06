% model = gen_nearest_neighbor_model()
function [model] = gen_nearest_neighbor_model()
path = '~/courses/fall13/6.867/project/training_data/';
lang = {'de';'dutch';'el';'english';'es';'french';'he';'italian';'portuguese';'russian'};

training_sizes = [2000; 2000; 658; 2000; 2000; 2000; 200; 2000; 1991; 700]; 
samples_per_lang = min(training_sizes);
x = [];
y = [];
for i=1:10;
  display(strcat('extracting language', num2str(i)));
  for j=1:samples_per_lang;
    
    filepath = char(strcat(path,lang(i),'_training_files/',lang(i),'-',num2str(j), '.wav'));

    features = extract_feature_from_wav(filepath);
     
    x = [x;transpose(features)];
    y = [y;ones(size(features,2),1).*i];
  end
end

model = ClassificationKNN.fit(x,y);
end
