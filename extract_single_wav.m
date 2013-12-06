% This function extracts all of the necessary features and return the
% feature vectors
function [x] = extract_single_wav(path, keyword, lang, sample, fbtype)
x = [];

features = extract_feature_from_wav(char(strcat(path,lang,keyword,lang,'-',num2str(sample), '.wav')), fbtype);
     
x = [x;transpose(features)];
