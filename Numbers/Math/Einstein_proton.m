clc;        % Clear command window
clear;      % Clear variables
close all;  % Close any open figures

fprintf('Modified Mass-Energy Equation: E = mc^2 P\n');
fprintf('------------------------------------------------\n');

% Constants
c = 299792458;  % Speed of Light (m/s)
P = 1.00784;    % Proton mass factor (relative atomic mass)

% User Input for Mass (kg)
m = input('Enter mass in kg: ');  

% Calculate Modified Energy (Joules)
E = m * c^2 * P;  

% Display Result
fprintf('For mass = %.5f kg, Proton Factor = %.5f, Energy = %.5e Joules\n', m, P, E);

% Visualization (Graphical Representation)
mass_values = linspace(0, 10, 100);   % Range of mass from 0 to 10 kg
energy_values = mass_values * c^2 * P;  % Modified energy values

figure;
plot(mass_values, energy_values, 'b', 'LineWidth', 2);
hold on;
scatter(m, E, 100, 'r', 'filled');  % Mark user input with red dot
xlabel('Mass (kg)');
ylabel('Energy (J)');
title('Modified Mass-Energy Relationship (E = mc^2 P)');
grid on;
legend('E = mc^2 P', 'User Input');
hold off;