% model = gen_nearest_neighbor_model()
function [model] = gen_nearest_neighbor_model()
path = '~/courses/fall13/6.867/project/training_data/';
lang = {'de';'dutch';'el';'english';'es';'french';'he';'italian';'portuguese';'russian'};
x = [];
y = [];
%numcep = 20;
for i=1:10;
  for j=1:200;
    
%{
    [d,sr] = wavread(char(strcat(path,lang(i),'_training_files/',lang(i),'-',num2str(j), '.wav')));
    [mm,aspc] = melfcc(d, sr, 'maxfreq', 8000, 'numcep', numcep, 'nbands', 22, 'fbtype', 'fcmel', 'dcttype', 1, 'usecmp', 1, 'wintime', 0.032, 'hoptime', 0.016, 'preemph', 0, 'dither', 1);
    first_deltas = deltas(mm);
    second_deltas = deltas(first_deltas);
    features = [mm;first_deltas;second_deltas];
%}
    features = extract_feature_from_wav(char(strcat(path,lang(i),'_training_files/',lang(i),'-',num2str(j), '.wav')));
     
    x = [x;transpose(features)];
    y = [y;ones(size(features,2),1).*i];
  end
end

model = ClassificationKNN.fit(x,y);
end
