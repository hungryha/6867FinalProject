% one against one svm model
% uses representative feature vectores
% data1 num_obs x feature_dim
function [model] = gen_svm_oao_rep(data1, data2, lang_index1, lang_index2, slack)

path = '~/courses/fall13/6.867/project/training_data/';
lang = {'de';'dutch';'el';'english';'es';'french';'he';'italian';'portuguese';'russian'};
training_sizes = [2000; 2000; 658; 2000; 2000; 2000; 200; 2000; 1991; 700];

num_obs1 = size(data1, 1);
num_obs2 = size(data2, 1);
num_obs = min(num_obs1, num_obs2);

d1 = data1(1:num_obs, :);
d2 = data2(1:num_obs, :);
data = [d1;d2];
group1 = ones(num_obs, 1).*lang_index1;
group2 = ones(num_obs, 1).*lang_index2;
groups = [group1;group2];
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

