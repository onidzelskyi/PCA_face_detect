%% Initialization
clear ; close all; clc

%% Variables
B = [0;0];
P = [0 0 1];

%% Read test image
I = rgb2gray(imread('affine.png'));

%% Scale
A = [2 0; 0 3];

% 1. Self implemented affine transform
if 1==0
    imshow(affine(I,A));
end

% 2. Or using by Image Processing Toolbox
if 1==0
    A = [2 0; 0 3];
    M = [A,B;P];
    T = affine2d(M);
    J = imwarp(I,T);
    imshow(J);
end

%% Shear
A = [1 2; 1 1];

% 1. Self implemented affine transform
if 1==0
    imshow(affine(I,A));
end

% 2. Or using by Image Processing Toolbox
if 1==0
    M = [A,B;P];
    T = affine2d(M);
    J = imwarp(I,T);
    imshow(J);
end

%% Rotation
Theta = 45;
clockwise = 0;
A = [cosd(Theta) (2*clockwise-1)*sind(Theta); (-2*clockwise+1)*sind(Theta) cosd(Theta)];

% 1. Self implemented affine transform
if 1==0
    imshow(affine(I,A));
end

% 2. Or using by Image Processing Toolbox
if 1==1
    M = [A,B;P];
    T = affine2d(M);
    J = imwarp(I,T);
    imshow(J);
end
