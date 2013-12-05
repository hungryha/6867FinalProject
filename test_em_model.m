function [] = test_em_model(params)

lang = {'dutch', 'english', 'de', 'french', 'russian', 'italian', 'es'};

test_data_mapping = containers.Map();
test_data_mapping('de') = 2001:3000;
test_data_mapping('es') = 2001:3000;
test_data_mapping('french') = 2001:3000;
test_data_mapping('dutch') = 2001:3000;
test_data_mapping('el') = 659:877;
test_data_mapping('he') = 201:267;
test_data_mapping('portuguese') = 1992:2654;
test_data_mapping('russian') = 701:933;
test_data_mapping('english') = 2001:3000;
test_data_mapping('italian') = 2001:3000;

parameters = containers.Map();

num_samples = 200;

for l=1:size(lang, 2)
    
    cur_lang = char(lang(1,l));
    disp(['Running test for language ', cur_lang])
    
    sample_bound = test_data_mapping(cur_lang);
    
    test_data_range = test_data_mapping(cur_lang);
    random_order = test_data_range(:, randperm(size(test_data_range, 2)));
    
    correct = 0;
    count = 0;
    
    for s=1:num_samples

        max_likelihood = 0;
        max_lang = '';
        
        for i=1:size(lang,2)
            iter_lang = char(lang(1, i));
            
            % get the feature vectors of a sample recording
            if strcmp(iter_lang, 'de')
                data = extract_single_wav('6867data/test_data/', '_test_files/', cur_lang, random_order(1,s), 'mel');
            else
                data = extract_single_wav('6867data/test_data/', '_test_files/', cur_lang, random_order(1,s), 'mel');
            end
            
            likelihood = 0;
            for x=1:size(data,1)
                param = params(iter_lang);
                k_likelihood = 0;
                for k=1:param.k
                    if (param.p(k) * evalgauss(data(x,:), param.mu(k,:), param.v(:,:,k)) ~= -Inf)
                        k_likelihood = k_likelihood + param.p(k) * evalgauss(data(x,:), param.mu(k,:), param.v(:,:,k));
                    end
                end
                likelihood = likelihood + k_likelihood;
            end
            if likelihood > max_likelihood || max_likelihood == 0
                max_likelihood = likelihood;
                max_lang = iter_lang;
            end
            %disp(iter_lang)
            %disp(likelihood)
        end
        
        count = count + 1;
        if strcmp(cur_lang, max_lang)
            correct = correct + 1;
        end
        
        str = [num2str(count), '. ', max_lang, '; ', num2str(correct/count*100), '%'];
        disp(str)
    end
    
    display('Classification correctness percentage for language')
    disp(cur_lang)
    disp(correct/count*100)
end