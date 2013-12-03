function [] = test_em_model(params)

lang = {'english', 'russian', 'french'};

test_data_mapping = containers.Map();
test_data_mapping('de') = [2001, 2100];
test_data_mapping('es') = [2001, 2100];
test_data_mapping('french') = [2001, 2100];
test_data_mapping('dutch') = [2001, 2100];
test_data_mapping('el') = [659, 759];
test_data_mapping('he') = [201, 267];
test_data_mapping('portuguese') = [1992, 2092];
test_data_mapping('russian') = [701, 801];
test_data_mapping('english') = [2001, 2100];

parameters = containers.Map();

num_samples = 10;

for l=1:size(lang, 2)
    
    cur_lang = char(lang(1,l));
    sample_bound = test_data_mapping(cur_lang);
    
    correct = 0;
    for s=sample_bound(1):sample_bound(1)+num_samples-1
        data = extract_single_wav('6867data/test_data/', '_test_files/', cur_lang, s);
        if mod(size(data, 1), 2) == 1
            data = data(1:size(data, 1)-1, :);
        end
        max_likelihood = 0;
        max_lang = '';
        
        for i=1:size(lang,2)
            iter_lang = char(lang(1, i));
            likelihood = 0;
            for x=1:size(data,1)
                param = params(iter_lang);
                k_likelihood = 0;
                for k=2:param.k
                    k_likelihood = k_likelihood + param.p(k) * evalgauss(data(x,:), param.mu(k,:), param.v(:,:,k));
                end
                likelihood = likelihood + k_likelihood;
            end
            if likelihood > max_likelihood || max_likelihood == 0
                max_likelihood = likelihood;
                max_lang = iter_lang;
            end
        end
        
        if strcmp(cur_lang, max_lang)
            correct = correct + 1;
        end
    end
    
    display('Classification correctness percentage for language')
    disp(cur_lang)
    disp(correct/(num_samples)*100)
end