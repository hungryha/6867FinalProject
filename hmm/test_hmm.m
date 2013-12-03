%use Qian's template

% tests nearest neighbor classifier
% model = gen_nearest_neighbor_model()
% test_error(model, numneighbor)
function [test_error] = test_hmm(model)
path = '~/courses/fall13/6.867/project/test_data/';
lang = {'de';'dutch';'el';'english';'es';'french';'he';'italian';'portuguese';'russian'};
initial_filename = [2001, 2001, 659, 2001, 2001, 2001, 201, 2001, 1992, 701];
x = [];
y = [];
numcep = 20;
num_wrong = 0;
total = 200;
for i=1:10;
  for j=0:19;
    file_num = j + initial_filename(i);
    file_path = char(strcat(path,lang(i),'_test_files/',lang(i),'-',num2str(file_num), '.wav'));
    features = extract_feature_from_wav(file_path);
    
    lang = predict(model,X);
    if lang ~= i;
      num_wrong = num_wrong + 1;
    end     
  end
end

test_error = num_wrong / total;
end
