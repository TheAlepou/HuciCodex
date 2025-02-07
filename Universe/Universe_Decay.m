clc;
clear;
close all;

% Time settings for the simulation
time_steps = 1000; % Total time steps to simulate
time = linspace(0, 1e10, time_steps); % Normalized time scale

% Entropy Decay (Heat Death)
entropy = 1 - exp(-0.001 * time); % Exponential approach to max entropy

% Dimensional Collapse
dimensions = 11 - (10 * (time / max(time)).^2); % Simulating dimensional reduction

% Consciousness Decay (Collective intelligence erosion)
consciousness_level = exp(-0.0005 * time); % Exponential decay of higher awareness

% Cosmic Code Corruption (Reality destabilization)
code_corruption = 1 - exp(-0.0007 * time); % Gradual increase in cosmic errors

% Visualization
figure;
subplot(2,2,1);
plot(time, entropy, 'r', 'LineWidth', 2);
xlabel('Time'); ylabel('Entropy');
title('Entropy Increase - Heat Death'); grid on;

subplot(2,2,2);
plot(time, dimensions, 'b', 'LineWidth', 2);
xlabel('Time'); ylabel('Dimensions');
title('Dimensional Collapse'); grid on;

subplot(2,2,3);
plot(time, consciousness_level, 'g', 'LineWidth', 2);
xlabel('Time'); ylabel('Consciousness Level');
title('Consciousness Decay'); grid on;

subplot(2,2,4);
plot(time, code_corruption, 'm', 'LineWidth', 2);
xlabel('Time'); ylabel('Cosmic Code Corruption');
title('Reality Destabilization'); grid on;

sgtitle('Decay of the Universe - Multi-Theory Model');