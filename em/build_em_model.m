function [data, parameters] = build_em_model()

%lang = {'de';'dutch';'el';'english';'es';'french';'he';'italian';'portuguese';'russian'};
lang = {'english'};
data = containers.Map();
parameters = containers.Map();

for l=1:size(lang, 2)
    cur_lang = char(lang(1, l));
    
    display('Starting feature extraction for language ')
    disp(cur_lang)
    x = extract_features_per_lang('6867data/training_data/', '_training_files/', cur_lang, 1, 500);
    data(cur_lang) = x;
    
    display('Feature extraction done')
    
    display('K = 40')
    means = kmeans(30, x);
    max_param = em(x, 30, means);
    
%     for k=40:40
%         display('K = ')
%         disp(k)
%         means = kmeans(k, x);
%         param = em(x, k, means);
%         if param.loglik > max_param.loglik
%             max_param = param;
%         end
%     end
    parameters(cur_lang) = max_param;
end
