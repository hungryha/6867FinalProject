function[data] = gen_all_rep_data(lang_index)
top_k_clusters = 5;
num_clusters = 10;
%{
datas = cell(10, 1);

for i=1:10
  display(strcat('extracting language', num2str(i)));
  data = gen_lang_rep_data(i, top_k_clusters, num_clusters);
  datas{i} = data;
end
%}
data = gen_lang_rep_data(lang_index, top_k_clusters, num_clusters)
end

function[data] = gen_lang_rep_data(lang_index,top_k_clusters, num_clusters)
path = '~/courses/fall13/6.867/project/training_data/';
lang = {'de';'dutch';'el';'english';'es';'french';'he';'italian';'portuguese';'russian'};
training_sizes = [2000; 2000; 658; 2000; 2000; 2000; 200; 2000; 1991; 700];
data = [];

for i=1:training_sizes(lang_index)
  filepath = char(strcat(path,lang(lang_index),'_training_files/',lang(lang_index),'-',num2str(i), '.wav'));
  % column vector
  features = representative_features(filepath, top_k_clusters, num_clusters);

  [r1,c1] = size(features);
  if r1 > 0
    % each row is an observation
    data = [data;transpose(features)];

  end

end
end
