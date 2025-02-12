clc;        % Clear command window
clear;      % Clear variables
close all;  % Close any open figures

fprintf('Comparing Original and Modified Mass-Energy Equations\n');
fprintf('-----------------------------------------------------\n');

% Constants
c = 299792458;  % Speed of light (m/s)
P = 1.00784;    % Proton mass factor (modified version)

% User Input for Mass (kg)
m = input('Enter mass in kg: ');  

% Calculate Energies
E_original = m * c^2;         % Standard E = mc^2
E_modified = m * c^2 * P;     % Modified E = mc^2 P

% Display Results
fprintf('For mass = %.2f kg:\n', m);
fprintf('  Original Energy (E = mc^2): %.2e J\n', E_original);
fprintf('  Modified Energy (E = mc^2 P): %.2e J\n', E_modified);

% Visualization
mass_values = linspace(0, 10, 100);  % Range of mass from 0 to 10 kg
energy_original = mass_values * c^2;       % Original energy values
energy_modified = mass_values * c^2 * P;  % Modified energy values

figure;
plot(mass_values, energy_original, 'b--', 'LineWidth', 2);  % Original (dashed blue line)
hold on;
plot(mass_values, energy_modified, 'r-', 'LineWidth', 2);   % Modified (solid red line)
scatter(m, E_original, 100, 'bo', 'filled');               % User input (original)
scatter(m, E_modified, 100, 'ro', 'filled');               % User input (modified)
xlabel('Mass (kg)');
ylabel('Energy (J)');
title('Comparison of Original and Modified Mass-Energy Equations');
legend('E = mc^2', 'E = mc^2 P', 'User Input (Original)', 'User Input (Modified)');
grid on;
hold off;