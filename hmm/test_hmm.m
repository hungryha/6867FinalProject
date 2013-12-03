%use Qian's template

% tests nearest neighbor classifier
% model = gen_nearest_neighbor_model()
% test_error(model, numneighbor)
function [test_error] = test_hmm(model)
path = 'C:/Users/Laphonchai/Desktop/6.867/6867data/test_data/';
lang = {'de';'dutch';'el';'english';'es';'french';'he';'italian';'portuguese';'russian'};
initial_filename = [2001, 2001, 659, 2001, 2001, 2001, 201, 2001, 1992, 701];
num_wrong = 0;
langSize = length(lang);
recordPerLang = 3;
total = langSize*recordPerLang;
for i=1:langSize;
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
        language = 'he';
    elseif i==8;
        language = 'italian';
    elseif i==9;
        language = 'portuguese';
    elseif i==10;
        language = 'russian';
    end
    file_path = char(strcat(path,language,'_test_files/',language,'-',num2str(file_num), '.wav'));
    
    features = transpose(extract_feature_from_wav(file_path));
    phonemeFeature = zeros(size(features,1),1);
    for k=1:size(features,1);
        phonemeFeature(k) = getNearest(model.means, features(i));
    end
    lang = predict(model,phonemeFeature);
    if lang ~= i;
      num_wrong = num_wrong + 1;
    end     
    i
  end
end

test_error = num_wrong / total;
end
