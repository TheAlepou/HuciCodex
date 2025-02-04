clc;
clear;
close all;

% Define original vector
V = [3, 4, 0];  % Original vector (e.g., velocity)

% Transformation matrix for redirection (rotate 90 degrees)
theta = pi/2; % 90-degree rotation
M = [cos(theta), -sin(theta), 0; sin(theta), cos(theta), 0; 0, 0, 1];

% Manipulated vector (reflection and redirection)
V_reflected = -V;          % Reflect the vector
V_redirected = M * V';     % Redirect the vector (matrix multiplication)

% Energy cost for manipulation (arbitrary formula)
E_manipulation = norm(V_redirected - V)^2;

% Plot the vectors
figure;
quiver3(0, 0, 0, V(1), V(2), V(3), 'b', 'LineWidth', 2, 'DisplayName', 'Original Vector');
hold on;
quiver3(0, 0, 0, V_reflected(1), V_reflected(2), V_reflected(3), 'r', 'LineWidth', 2, 'DisplayName', 'Reflected Vector');
quiver3(0, 0, 0, V_redirected(1), V_redirected(2), V_redirected(3), 'g', 'LineWidth', 2, 'DisplayName', 'Redirected Vector');
xlabel('X');
ylabel('Y');
zlabel('Z');
legend;
grid on;
title('Vector Manipulation');