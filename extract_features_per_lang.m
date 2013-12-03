% This function extracts all of the necessary features and return the
% feature vectors
function [x] = extract_features_per_lang(path, keyword, lang, sample_start, sample_end)
x = [];

for j=sample_start:sample_end;
    features = extract_feature_from_wav(char(strcat(path,lang,keyword,lang,'-',num2str(j), '.wav')));
     
    x = [x;transpose(features)];

end
