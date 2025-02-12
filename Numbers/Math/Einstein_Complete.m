clc;        % Clear command window
clear;      % Clear variables
close all;  % Close any open figures

fprintf('Relativistic Energy Equation: E^2 = (mc^2)^2 + (pc)^2\n');
fprintf('------------------------------------------------------\n');

% Constants
c = 299792458;  % Speed of light (m/s)

% User Inputs
m = input('Enter mass in kg: ');  % Rest mass
v = input('Enter velocity in m/s: ');  % Velocity

% Calculate momentum (p = mv)
p = m * v;

% Calculate Energy Components
rest_energy = m * c^2;       % Rest energy (mc^2)
momentum_energy = p * c;     % Momentum energy (pc)

% Total Energy
total_energy = sqrt(rest_energy^2 + momentum_energy^2);

% Display Results
fprintf('Rest Energy = %.2e J\n', rest_energy);
fprintf('Momentum Energy = %.2e J\n', momentum_energy);
fprintf('Total Energy = %.2e J\n', total_energy);

% Visualization
mass_values = linspace(0, 10, 100);  % Range of mass from 0 to 10 kg
velocity_values = linspace(0, c, 100);  % Range of velocity from 0 to speed of light
[mass_grid, velocity_grid] = meshgrid(mass_values, velocity_values);
momentum_grid = mass_grid .* velocity_grid;
energy_grid = sqrt((mass_grid .* c^2).^2 + (momentum_grid .* c).^2);

figure;
surf(mass_grid, velocity_grid, energy_grid, 'EdgeColor', 'none');
xlabel('Mass (kg)');
ylabel('Velocity (m/s)');
zlabel('Energy (J)');
title('Relativistic Energy Surface');
colorbar;