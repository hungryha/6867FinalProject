% datas is cell array containing all data from all languages
% generates matrix of one against all classifiers
function[models] = gen_svms_oaa(datas, slack)
models = cell(length(datas), 1);
for i=1:length(datas)
  models{i} = gen_svm_oaa(i, datas, slack);
end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function[model] = gen_svm_oaa(lang_index, datas, slack)

num_obs = size(datas{lang_index}, 1);
target_data = datas{lang_index};

% number of samples to select from each language
select_sizes = zeros(1, length(datas));

% pick num_obs samples evenly from the other 9 languages
num_others = floor(num_obs / (length(datas) - 1));

for i=1:10
  if i ~= lang_index
    select_sizes(1,i) = min(num_others, size(datas{i},1));
  end
end

leftovers = num_obs - sum(select_sizes);
li = 1;
index = 0;
while leftovers > 0
  li = index + 1; 
  if li ~= lang_index & select_sizes(1,li) < size(datas{li}, 1)
    select_sizes(1,li) = select_sizes(1,li) + 1;
    leftovers = leftovers - 1;
  end  
  index = mod(index+1,10);

end

others_data = [];
for i=1:length(datas);
  % randomly select num_samples rows from data{i}
  perm = randperm(size(datas{i},1),select_sizes(i));
  for j=1:select_sizes(i)
    others_data = [others_data; datas{i}(perm(j), :)];
  end
end

data = [target_data;others_data];
group1 = ones(num_obs, 1).*lang_index;
group2 = zeros(num_obs, 1);
groups = [group1;group2];
% train svm with target_data and others_data
model = [];
for i=1:10
  display(strcat('Trying kernel function poly degree ', num2str(i)));
  try
    model = svmtrain(data, groups, 'Kernel_Function', 'polynomial', 'polyorder', i, 'boxconstraint', slack)
    break
  catch err
  end;
end;

if size(model,1) == 0
  try model = svmtrain(data, groups, 'Kernel_Function', 'rbf', 'boxconstraint', slack);
  catch err
  end;
end

end
