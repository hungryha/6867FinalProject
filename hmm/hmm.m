function [ model ] = hmm(X,Y,means)
% X is two dimensions array, when X{i}(j) is the i th wave file/sentence
%  and of the j th phoneme and
% Y is one dimensional array, when Y(i) is the language of the i th wave
%  file/sentence

%K the total number of phoneme
K = size(means,1);
%L the number of language
L = 10;

%pt the transitional probability
pt = zeros(K,K,L);

%pi the initial probability
pi = zeros(K,L);

%means the means for each language mfcc
model.means = means;

%count
n = length(X);
for i=1:n;
    %initial
    pi(X{i}(1),Y(i)) = pi(X{i}(1),Y(i)) + 1;
    %transition
    for j=2:size(X{i},1);
        pt(X{i}(j-1),X{i}(j),Y(i)) = pt(X{i}(j-1),X{i}(j),Y(i)) + 1;
    end
end

model.pt = normalize(pt);

%normalize pi
for k=1:L;
    sum = 0;
    for i=1:K;
        sum = sum + pi(i,k);
    end
    if sum~=0;
        for i=1:K;
            pi(i,k) = pi(i,k)/sum;
        end
    end
end
model.pi = pi;

end

