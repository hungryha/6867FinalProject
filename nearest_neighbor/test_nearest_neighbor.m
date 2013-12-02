% tests nearest neighbor classifier
% model = gen_nearest_neighbor_model()
% test_error(model, numneighbor)
function [test_error] = test_error(model, numneighbor)
path = '~/courses/fall13/6.867/project/test_data/';
lang = {'de';'dutch';'el';'english';'es';'french';'he';'italian';'portuguese';'russian'};
initial_filename = [2001, 2001, 659, 2001, 2001, 2001, 201, 2001, 1992, 701];
x = [];
y = [];
numcep = 20;
num_wrong = 0;
model.NumNeighbors = numneighbor;
model
for i=1:10;
  for j=0:19;
    file_num = j + initial_filename(i);
    file_path = char(strcat(path,lang(i),'_test_files/',lang(i),'-',num2str(file_num), '.wav'));
%{
    [d,sr] = wavread(file_path);
    [mm,aspc] = melfcc(d, sr, 'maxfreq', 8000, 'numcep', numcep, 'nbands', 22, 'fbtype', 'fcmel', 'dcttype', 1, 'usecmp', 1, 'wintime', 0.032, 'hoptime', 0.016, 'preemph', 0, 'dither', 1);
  
    first_deltas = deltas(mm);
    second_deltas = deltas(first_deltas);
    features = [mm;first_deltas;second_deltas];
%}
    features = extract_feature_from_wav(file_path);
    [lang_prediction, scores] = predict(model, transpose(features));


    buckets = zeros(10, 1);
    for k=1:length(lang_prediction);
      buckets(lang_prediction(k)) = buckets(lang_prediction(k)) + 1;
    end

%{  
    buckets = zeros(10, 1);
    for l=1:length(size(mm,2));
      for k=1:length(lang);
        buckets(k) = buckets(k) + scores(l, k);
      end
    end
%}

    [score, final_prediction] = max(buckets);
    if final_prediction ~= i;
      num_wrong = num_wrong + 1;
    end     
  end
end

test_error = num_wrong / 200;
end
