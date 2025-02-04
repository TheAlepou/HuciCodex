clc; clear; close all;

% Define plasma properties (single particle for simplicity)
q = 1.6e-19; % Charge of particle (Coulombs)
m = 9.1e-31; % Mass of particle (kg)
v = [1e6, 0, 0]; % Initial velocity (m/s)
pos = [0, 0, 0]; % Initial position (m)

% Define magnetic and electric fields
B = [0, 0, 1]; % Magnetic field (Tesla) in the z-direction
E = [0, 0, 0]; % Electric field (V/m)

% Time settings
dt = 1e-9; % Time step (s)
t_max = 1e-6; % Total simulation time (s)
t = 0:dt:t_max;

% Initialize arrays for position and velocity
positions = zeros(length(t), 3);
velocities = zeros(length(t), 3);
positions(1, :) = pos;
velocities(1, :) = v;

% Simulation loop
for i = 2:length(t)
    % Calculate Lorentz force
    F = q * (E + cross(velocities(i-1, :), B));
    
    % Update velocity using F = ma
    a = F / m;
    velocities(i, :) = velocities(i-1, :) + a * dt;
    
    % Update position
    positions(i, :) = positions(i-1, :) + velocities(i, :) * dt;
end

% Plot particle trajectory
figure;
plot3(positions(:, 1), positions(:, 2), positions(:, 3));
xlabel('X (m)'); ylabel('Y (m)'); zlabel('Z (m)');
title('Plasma Particle Trajectory');
grid on;