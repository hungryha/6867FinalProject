%use Qian's template

% tests nearest neighbor classifier
% model = gen_nearest_neighbor_model()
% test_error(model, numneighbor)
function [test_error] = test_hmm(model)
path = 'C:/Users/Laphonchai/Desktop/6.867/6867data/test_data/';
lang = {'de';'dutch';'el';'english';'es';'french';'italian';'portuguese';'russian'};
initial_filename = [2001, 2001, 659, 2001, 2001, 2001, 2001, 1992, 701];
num_wrong = 0;
langSize = length(lang);
recordPerLang = 100;
total = langSize*recordPerLang;
percent = zeros(langSize,1);
for i=1:langSize;
  bucket = zeros(10,1);
  for j=0:(recordPerLang-1);
    file_num = j + initial_filename(i);
    if i==1;
        language = 'de';
    elseif i==2;
        language = 'dutch';
    elseif i==3;
        language = 'el';
    elseif i==4;
        language = 'english';
    elseif i==5;
        language = 'es';
    elseif i==6;
        language = 'french';
    elseif i==7;
        language = 'italian';
    elseif i==8;
        language = 'portuguese';
    elseif i==9;
        language = 'russian';
    end
    file_path = char(strcat(path,language,'_test_files/',language,'-',num2str(file_num), '.wav'));
    
    features = transpose(extract_feature_from_wav(file_path));
    %reduce
    starting = floor(size(features,1)*3/8)+1;
    ending = floor(size(features,1)*5/8);
    predict = predict_hmm(model,features(starting:ending,:));
    
    bucket(predict) = bucket(predict) + 1;
    if predict ~= i;
      num_wrong = num_wrong + 1;
      percent(i) = percent(i) + 1;
    end     
  end
  percent(i) = percent(i)/recordPerLang; 
  lang(i)
  bucket
end
percent
test_error = num_wrong / total;
lang
end
