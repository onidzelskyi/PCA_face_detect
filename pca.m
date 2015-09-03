function [] = pca(mode)

%% Clear 
close all; close all; clc

%% Variables
X = [];
X_test = [];
M = 0;
N = 0;

%% Load data and test images
if strcmp(mode, 'demo') % demo mode
    load('demo.mat'); % load all precalculated data
    M = 112;
    N = 92;
else
    if strcmp(mode, 'digits') % digits mode
        load('digits.mat'); % load 5000 examples of hand written digits 20x20
        M = 20;
        N = 20;
    else % orl mode
        load('orl.mat'); % load 400 examples of faces by 112x92 and 40 test images 112x92
        M = 112;
        N = 92;
    end
    
    %% Normalize images
    mu = mean(X); % mean image
    A = bsxfun(@minus, X, mu); % normalized images

    %% Eigenfaces and eigenvalues
    % For orl faces PCA reduced from 10304 to 399
    % For handwritten digits 400 to 6
    L = [];
    [U,S,~] = svd((A'*A)/size(X,1));
    for i=1:size(U,1)
        if S(i,i)>1 % select only valuable features
            L = [L U(:,i)];
        end
    end
    eigenfaces = A*L; % reduced images
end


%% Test image
for t=1:size(X_test,1)
    test_image = X_test(t,:);
    test_image = test_image - mu;
    p = test_image * L;
    
    d = bsxfun(@minus, eigenfaces,p);
    dist = arrayfun(@(idx) norm(d(idx,:)), 1:size(d,1)).^2;
    [a,b] = min(dist);
    if strcmp(mode,'digits')
        imshow([reshape(X(b,:),[M,N]), reshape(X_test(t,:),[M,N])]);
    else
        imshow(uint8([reshape(X(b,:),[M,N]), reshape(X_test(t,:),[M,N])]));
    end
    pause;
end

end