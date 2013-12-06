% datas is cell array containing all data from all languages
% generates matrix of pairwise svm classifiers
function[models] = gen_all_svm_oao(datas, slack)
models = cell(length(datas), length(datas));
for i=1:length(datas)
  for j=i+1:length(datas)
    display(strcat('Constructing SVM for language pair', num2str(i), num2str(j)));
    model = gen_svm_oao_rep(datas{i}, datas{j}, i, j, slack);    
    models{i,j} = model;
  end
end

end

