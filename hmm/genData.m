function [X, Y] = genData()
% Important! X has to use in X{i}(j) which is the the feature vector
%  for i record with jth window size  !!!! Note that it is {} and ()
% Y(i) is the language for record i
lang = {'de';'dutch';'el';'english';'es';'french';'he';'italian';'portuguese';'russian'};
path = 'C:/Users/Laphonchai/Desktop/6.867/6867data/';

langSize = size(lang,1);
samplePerLang = 200; %some langs has only 200
total = langSize*samplePerLang;
X = cell(total,1);
Y = zeros(total,1);

for l=1:langSize;
  for i=1:samplePerLang;
    finalPath = char(strcat(path,'training_data/',lang(l),'_training_files/',lang(l),'-',num2str(i), '.wav'));
    features = extract_feature_from_wav(finalPath);
    X{(l-1)*samplePerLang + i} = transpose(features);
    Y((l-1)*samplePerLang + i) = l;
  end
  l
end

end
