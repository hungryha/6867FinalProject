function [data, parameters] = build_em_model()

%lang = {'de';'dutch';'el';'english';'es';'french';'he';'italian';'portuguese';'russian'};
lang = {'russian', 'es', 'english', 'french', 'italian', 'dutch', 'de', 'portuguese'};

fbtype = 'bark';

num_clusters = containers.Map();
num_clusters('russian') = 25;
num_clusters('es') = 25;
num_clusters('english') = 35;
num_clusters('french') = 25;
num_clusters('italian') = 25;
num_clusters('dutch') = 30;
num_clusters('de') = 40;
num_clusters('portuguese') = 25;

train_data_mapping = containers.Map();
train_data_mapping('de') = [1:2000];
train_data_mapping('es') = [1:2000];
train_data_mapping('french') = [1:2000];
train_data_mapping('dutch') = [1:2000];
train_data_mapping('el') = [1:658];
train_data_mapping('he') = [1:200];
train_data_mapping('portuguese') = [1:2991];
train_data_mapping('russian') = [1:700];
train_data_mapping('english') = [1:2000];
train_data_mapping('italian') = [1:2000];

data = containers.Map();
parameters = containers.Map();

training_samples = 500;

for l=1:size(lang, 2)
    cur_lang = char(lang(1, l));
    
    display('Starting feature extraction for language ')
    disp(cur_lang)
    
    training_data_range = train_data_mapping(cur_lang);
    random_order = training_data_range(:, randperm(size(training_data_range, 2)));
    
    x = [];
    
    for i=1:training_samples
        x = [x; extract_single_wav('6867data/training_data/', '_training_files/', cur_lang, random_order(1,i), fbtype)];
    end
    
    data(cur_lang) = x;
    
    display('Feature extraction done')
    
    k = num_clusters(cur_lang);
    display(['Running EM with K = ', num2str(k)])
    means = kmeans(k, x);
    max_param = em(x, k, means)
   
    parameters(cur_lang) = max_param;
end