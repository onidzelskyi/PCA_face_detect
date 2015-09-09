function [] = pca(mode, show, errors)

if ~exist('show', 'var') show=0; end;
if ~exist('errors', 'var') errors=0; end;

%% Clear 
close all; close all; clc

%% Variables
X = [];
X_test = [];
M = 0;
N = 0;
coeff = 0;

%% Load data and test images
if strcmp(mode, 'demo') % demo mode
    load('demo.mat'); % load all precalculated data
    M = 112;
    N = 92;
    coeff = 40;
else
    if strcmp(mode, 'digits') % digits mode
        load('digits.mat'); % load 5000 examples of hand written digits 20x20
        M = 20;
        N = 20;
        coeff = 10;
    else % orl mode
        load('orl.mat'); % load 400 examples of faces by 112x92 and 40 test images 112x92
        M = 112;
        N = 92;
        coeff = 40;
    end
    
    %% Normalize images
    mu = mean(X); % mean image
    A = bsxfun(@minus, X, mu); % normalized images

    %% Eigenfaces and eigenvalues
    % For orl faces PCA reduced from 10304 to 399
    % For handwritten digits 400 to 6
    L = [];
    [U,S,~] = svd((A'*A)/size(X,1));
    for k=1:size(S)
        s = sum(sum(S(1:k,1:k)))/sum(S(:));
        if s>=0.99 
            fprintf('Number of principal components K: %d,\tvariance: %f\n',k,s);
            break;
        end
    end
    L = U(:,1:k);
    eigenfaces = A*L; % reduced images
end


%% Test image

% accuracy
accuracy = zeros(1,size(X,1));

coeff = 10;

for t=1:size(X_test,1)
    test_image = X_test(t,:);
    test_image = test_image - mu;
    p = test_image * L;
    
    d = bsxfun(@minus, eigenfaces,p);
    dist = arrayfun(@(idx) norm(d(idx,:)), 1:size(d,1)).^2;
    [a,b] = min(dist);
    % accuracy
    a1 = fix(t/coeff);
    a2 = fix(b/coeff);
    if b-fix(b/coeff)*coeff==t-fix(t/coeff)*coeff
        accuracy(t) = 1;
    else
        if errors==1
            if strcmp(mode,'digits')
                imshow([reshape(X(b,:),[M,N]), reshape(X_test(t,:),[M,N])]);
            else
                imshow(uint8([reshape(X(b,:),[M,N]), reshape(X_test(t,:),[M,N])]));
            end
            pause;
        end
    end
    if 1==show
        if strcmp(mode,'digits')
            imshow([reshape(X(b,:),[M,N]), reshape(X_test(t,:),[M,N])]);
        else
            imshow(uint8([reshape(X(b,:),[M,N]), reshape(X_test(t,:),[M,N])]));
        end
        pause;
    end
end
fprintf('Accuracy: %f\n',sum(accuracy)/size(accuracy,2));
end