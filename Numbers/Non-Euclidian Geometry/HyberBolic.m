% Hyperbolic Non-Euclidean Dimension Simulation
% This MATLAB script simulates a warped, hyperbolic space
% Variables are provided for modification, but multiplication is locked

clc; clear; close all;

% Modifiable Parameters (Feel free to change these!)
curve = 1.2; % Curvature of space
warpFactor = 0.8; % Degree of hyperbolic warping
timeShift = 0.5; % Temporal distortion factor
dimDepth = 3; % Dimensional depth scaling
rotationFactor = 0.7; % Rotation effect strength
scaleFactor = 1.1; % General scaling

domain = linspace(-2,2,50);
[X, Y] = meshgrid(domain, domain);

% Locked Non-Euclidean Transformations
Z = sinh(curve * X) + cosh(warpFactor * Y) - tanh(timeShift * X .* Y);
Z = Z .* dimDepth + rotationFactor * atan(Y) - scaleFactor * sin(X);

% Plotting the Hyperbolic Dimension
figure;
surf(X, Y, Z, 'EdgeColor', 'none');
colormap(jet);
lighting phong;
shading interp;
camlight;
axis off;
title('HyperBolic Non-Euclidean Space');

% Interactive Rotation
rotate3d on;
