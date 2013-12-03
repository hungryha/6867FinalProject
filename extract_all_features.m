% This function extracts all of the necessary features and return the
% feature vectors
function [x] = extract_all_features(path)
%lang = {'de';'dutch';'el';'english';'es';'french';'he';'italian';'portuguese';'russian'};
lang = {'he'};
x = [];

[len, i] = size(lang);

for i=1:len;
  for j=1:200;
      
    features = extract_feature_from_wav(char(strcat(path,lang(i),'_training_files/',lang(i),'-',num2str(j), '.wav')));
     
    x = [x;transpose(features)];
  end
end

end
