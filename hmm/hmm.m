function [ model ] = hmm(X,Y)
% X is two dimensions array, when X(i,j) is the i th wave file/sentence
%  and of the j th phonim and
% Y is one dimensional array, when Y(i) is the language of the i th wave
%  file/sentence

%K the total number of phonim
K = 20;
%L the number of language
L = 10;

%pt the transitional probability
model.pt = zeros(K,K,L);

%pi the initial probability
model.pi = zeros(K,L);

%count
n,m = size(X);
for i=1:n;
    %initial
    model.pi(X(i,1),Y(i)) = model.pi(X(i,1),Y(i)) + 1;
    %transition
    for j=2:m;
        model.pt(X(i,j),X(i,j+1),Y(i)) = model.pt(X(i,j),X(i,j+1),Y(i));
    end
end

end

