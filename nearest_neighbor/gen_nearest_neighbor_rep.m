% model = gen_nearest_neighbor_model()
function [model] = gen_nearest_neighbor_rep()
top_k_clusters = 5;
num_clusters = 10;
path = '~/courses/fall13/6.867/project/training_data/';
lang = {'de';'dutch';'el';'english';'es';'french';'italian';'portuguese';'russian'};
training_sizes = [2000; 2000; 658; 2000; 2000; 2000; 2000; 1991; 700]; 
training_samples = min(training_sizes);
x = [];
y = [];
%numcep = 20;
for i=1:length(lang);
  display(strcat('Extracting Language ', num2str(i)));
  for j=1:training_samples;
    filepath = char(strcat(path,lang(i),'_training_files/',lang(i),'-',num2str(j), '.wav'));

    % column vector
    try
      features = representative_features(filepath, top_k_clusters, num_clusters);
     
    catch err

      features = [];
    end
    x = [x;transpose(features)];
    y = [y;ones(size(features,2),1).*i];
  end
end

model = ClassificationKNN.fit(x,y);
end
