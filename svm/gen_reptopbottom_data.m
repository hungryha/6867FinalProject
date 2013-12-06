function[data] = gen_reptopbottom_data(lang_index)
num_clusters = 15;
topcutoff = 3;
botcutoff = 3;

path = '~/courses/fall13/6.867/project/training_data/';
lang = {'de';'dutch';'el';'english';'es';'french';'he';'italian';'portuguese';'russian'};
training_sizes = [2000; 2000; 658; 2000; 2000; 2000; 200; 2000; 1991; 700];
data = [];

for i=1:training_sizes(lang_index)
  filepath = char(strcat(path,lang(lang_index),'_training_files/',lang(lang_index),'-',num2str(i), '.wav'));
  % column vector
  features = representative_features_topbot(filepath, topcutoff, botcutoff, num_clusters);

  [r1,c1] = size(features);
  if r1 > 0
    % each row is an observation
    data = [data;transpose(features)];

  end

end

end

