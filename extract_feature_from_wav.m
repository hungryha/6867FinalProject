% extracts feature vectors from one wav file
% numcep melfcc, numcep deltas, numcep deltadeltas
function [features] = extract_feature_from_wav(filepath)
numcep = 20;
[d,sr] = wavread(filepath);
[mm,aspc] = melfcc(d, sr, 'maxfreq', 8000, 'numcep', numcep, 'nbands', 22, 'fbtype', 'fcmel', 'dcttype', 1, 'usecmp', 1, 'wintime', 0.032, 'hoptime', 0.016, 'preemph', 0, 'dither', 1);
first_deltas = deltas(mm);
second_deltas = deltas(first_deltas);
features = [mm;first_deltas;second_deltas];

end
