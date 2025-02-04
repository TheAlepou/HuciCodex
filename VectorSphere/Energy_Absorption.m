clc; clear; close all;

% Define Missile Properties
m = 500; % Mass of missile in kg
v = 1200; % Velocity of missile in m/s
E_kinetic = 0.5 * m * v^2; % Kinetic Energy (Joules)
E_explosion = 5e12; % Estimated explosion energy in Joules (small-scale nuke)
E_total = E_kinetic + E_explosion;

% Define VectorSphere Energy Absorption Parameters
absorption_efficiency = 0.85; % 85% of energy is absorbed
E_absorbed = E_total * absorption_efficiency;
E_wasted = E_total - E_absorbed;

% Energy Redirection
E_stored = E_absorbed * 0.7; % 70% stored for power grid
E_redirected = E_absorbed * 0.3; % 30% redirected back as a counterattack

% Display Results
fprintf('Missile Detected! \n');
fprintf('Kinetic Energy: %.2e Joules \n', E_kinetic);
fprintf('Explosion Energy: %.2e Joules \n', E_explosion);
fprintf('Total Incoming Energy: %.2e Joules \n', E_total);
fprintf('\nVectorSphere Absorption:\n');
fprintf('Absorbed Energy: %.2e Joules (%.0f%% Efficiency)\n', E_absorbed, absorption_efficiency*100);
fprintf('Stored for Power: %.2e Joules \n', E_stored);
fprintf('Redirected as Counterattack: %.2e Joules \n', E_redirected);
fprintf('Energy Lost: %.2e Joules \n', E_wasted);

% Visualization
figure;
labels = {'Stored Energy', 'Redirected Energy', 'Lost Energy'};
values = [E_stored, E_redirected, E_wasted];
explode = [0.1, 0.1, 0];
pie(values, explode, labels);
title('VectorSphere Energy Distribution');
