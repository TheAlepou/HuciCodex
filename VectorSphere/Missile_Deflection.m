clc;
clear;
close all;

% Define missile properties
missile_pos = [-100, 0, 0];  % Initial position (far left)
missile_velocity = [500, 0, 0];  % Supersonic velocity (m/s) toward city
missile_mass = 1000;  % Larger missile mass (kg)

% Barrier properties
barrier_position = [0, 0, 0];  % Location of barrier
zpe_available = 2.50e10;  % ZPE energy available (J)

% Define "safe zone" for redirection
safe_zone_direction = [0, 500, 0];  % Redirect missile upwards

% Initialize missile_velocity_redirected to avoid errors
missile_velocity_redirected = missile_velocity; % Default to the initial velocity

% Calculate original kinetic energy of missile
kinetic_energy_original = 0.5 * missile_mass * norm(missile_velocity)^2;

% Debugging - Kinetic energy calculation
fprintf('Original kinetic energy of missile: %.2e J\n', kinetic_energy_original);

% Time simulation
dt = 0.01;  % Time step (seconds)
time = 0;  % Initialize time

while missile_pos(1) < barrier_position(1)
    % Update missile position
    missile_pos = missile_pos + missile_velocity * dt;
    time = time + dt;
end

% Missile has reached the barrier
fprintf('Missile reached the barrier at time: %.2f seconds\n', time);

% Calculate redirection vector
missile_velocity_redirected = safe_zone_direction;

% Calculate new kinetic energy after redirection
kinetic_energy_redirected = 0.5 * missile_mass * norm(missile_velocity_redirected)^2;

% Energy required for redirection (accounts for momentum change)
energy_required = 0.5 * missile_mass * norm(missile_velocity - missile_velocity_redirected)^2;

% Debugging - Energy calculation
fprintf('Energy required for redirection: %.2e J\n', energy_required);
fprintf('ZPE available: %.2e J\n', zpe_available);

% Check if ZPE can handle the energy
if energy_required <= zpe_available
    fprintf('Missile redirected to safe zone! Energy required: %.2e J\n', energy_required);
    missile_velocity = missile_velocity_redirected; % Update missile velocity
else
    fprintf('ZPE insufficient! Missile not fully redirected. Energy required: %.2e J\n', energy_required);
    missile_velocity_redirected = missile_velocity; % Missile continues on original path
end

% Plot simulation
figure;
quiver3(missile_pos(1), missile_pos(2), missile_pos(3), missile_velocity(1), missile_velocity(2), missile_velocity(3), 'r', 'LineWidth', 2, 'DisplayName', 'Incoming Missile');
hold on;
quiver3(barrier_position(1), barrier_position(2), barrier_position(3), missile_velocity_redirected(1), missile_velocity_redirected(2), missile_velocity_redirected(3), 'b', 'LineWidth', 2, 'DisplayName', 'Redirected Missile');
xlabel('X');
ylabel('Y');
zlabel('Z');
legend;
grid on;
title('Missile Deflection System Simulation');