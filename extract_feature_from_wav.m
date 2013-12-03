% extracts feature vectors from one wav file
% numcep melfcc, numcep deltas, numcep deltadeltas
function [features] = extract_feature_from_wav(filepath)
numcep = 12;
fbtype = 'bark';
wintime = 0.25;
hoptime = 0.10;
nbands = 26;
[d,sr] = wavread(filepath);
[mm,aspc] = melfcc(d, sr, 'maxfreq', 8000, 'numcep', numcep, 'nbands', nbands, 'fbtype', fbtype, 'dcttype', 1, 'usecmp', 1, 'wintime', wintime, 'hoptime', hoptime, 'preemph', 0, 'dither', 1);
first_deltas = deltas(mm);
second_deltas = deltas(first_deltas);
features = [mm;first_deltas;second_deltas];
end
