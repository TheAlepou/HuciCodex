% Einstein's Energy Equation Simulation
% E = mc^2

clc;        % Clear command window
clear;      % Clear variables
close all;  % Close any open figures

fprintf('Einstein’s Mass-Energy Equivalence Formula: E = mc^2\n');
fprintf('-----------------------------------------------\n');

% Speed of Light (m/s)
c = 299792458;  

% User Input for Mass (kg)
m = input('Enter mass in kg: ');  

% Calculate Energy (Joules)
E = m * c^2;

% Display Result
fprintf('For mass = %.2f kg, Energy = %.2e Joules\n', m, E);

% Visualization (Graphical Representation)
mass_values = linspace(0, 10, 100);  % Range of mass from 0 to 10 kg
energy_values = mass_values * c^2;   % Corresponding energy values

figure;
plot(mass_values, energy_values, 'b', 'LineWidth', 2);
hold on;
scatter(m, E, 100, 'r', 'filled');  % Mark input mass with red dot
xlabel('Mass (kg)');
ylabel('Energy (J)');
title('Mass-Energy Relationship');
grid on;
legend('E=mc^2', 'User Input');
hold off;