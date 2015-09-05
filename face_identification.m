function [] = face_identification()
    %% Identify person from group of persons
    % group - photo of a group of persons
    % single - photo of a single person which face identified from group
    
    % Clear workspace
    clear all; clc; close all;
    
    % Black box
    faceDetector = vision.CascadeObjectDetector;
    
    %% 1. Group 
    % 1.1. Read image 
    % 1.2. Extract faces from image
    % 1.3. Unfold faces matrices to a vectors
    % 1.4. Normalize faces    
    g = [];
    G = imread('group.jpeg');
    gboxes = step(faceDetector, G);
    for i=1:size(gboxes,1)
        p = imresize(G(gboxes(i,2):gboxes(i,2)+gboxes(i,4),gboxes(i,1):gboxes(i,1)+gboxes(i,3)),[mean(gboxes(:,3)),NaN]);
        g = [g; double(reshape(p,[1, size(p,1)^2]))];
    end
    % Normalize images
    g = bsxfun(@minus, g, mean(g));
    
    %% 2. Single
    % 2.1. Read image 
    % 2.2. Extract faces from image
    % 2.3. Unfold faces matrices to a vectors
    % 2.4. Normalize faces    
    Single = imread('single.jpeg');
    sboxes = step(faceDetector, Single);
    s = imresize(Single(sboxes(1,2):sboxes(1,2)+sboxes(1,4),sboxes(1,1):sboxes(1,1)+sboxes(1,3)),[mean(gboxes(:,3)),NaN]);
    s = double(reshape(s,[1,size(s,1)^2]));
    % Normalize images
    s = bsxfun(@minus, s, mean(s));
    
    %% 3. PCA
    % For faces PCA reduced from 1600 to 7
    L = [];
    [U,S,~] = svd((g'*g)/size(g,1));
    for i=1:size(U,1)
        if S(i,i)>1 % select only valuable features
            L = [L U(:,i)];
        end
    end
    eigenfaces = g*L; % reduced images
    
    %% 4. Identification
    d = bsxfun(@minus, eigenfaces,s*L);
    dist = arrayfun(@(idx) norm(d(idx,:)), 1:size(d,1)).^2;
    [a,b] = min(dist);
    GFaces = insertObjectAnnotation(G, 'rectangle', gboxes(b,:), 'Target');
    SFaces = insertObjectAnnotation(Single, 'rectangle', sboxes(1,:), 'Source');
    subplot(1,2,1); subimage(GFaces);
    subplot(1,2,2); subimage(SFaces);
end