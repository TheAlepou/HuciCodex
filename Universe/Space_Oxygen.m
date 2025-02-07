% Oxygen Production from Planetary Atmospheres Simulation
clc; clear; close all;

% Define planetary atmospheres (Composition in fraction)
planets = {'Mars', 'Venus', 'Titan', 'Europa', 'Kepler-442b', 'TOI-700d'};
CO2 = [0.96, 0.965, 0.0001, 0, 0.85, 0.70];  % CO2 fractions
H2O = [0, 0, 0, 0.99, 0, 0];  % H2O ice fractions
CH4 = [0, 0, 0.05, 0, 0, 0];  % CH4 fractions

% Define extraction efficiency
efficiency_CO2 = 0.3;  % 30% for CO2 electrolysis
efficiency_H2O = 0.8;  % 80% for water electrolysis
efficiency_CH4 = 0.2;  % 20% for methane cracking

% Compute oxygen production for each planet
O2_yield = (CO2 * efficiency_CO2) + (H2O * efficiency_H2O) + (CH4 * efficiency_CH4);

% Display results in MATLAB console
fprintf('Estimated Oxygen Production (normalized units):\n');
for i = 1:length(planets)
    fprintf('%s: %.4f\n', planets{i}, O2_yield(i));
end

% Plot results
figure;
bar(O2_yield, 'b');
set(gca, 'xticklabel', planets);
xlabel('Planetary Body');
ylabel('Estimated O2 Yield (normalized units)');
title('Simulated Oxygen Production from Planetary Atmospheres');
grid on;