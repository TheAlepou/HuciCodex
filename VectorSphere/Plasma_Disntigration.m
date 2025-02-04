clc;
clear;
close all;

% Constants and Initializations
missile_mass = 1000; % in kg
missile_velocity = [500, 0, 0]; % in m/s
missile_energy = 0.5 * missile_mass * norm(missile_velocity)^2; % Kinetic energy in Joules
zpe_available = 2.5e+09; % ZPE available in Joules
barrier_position = [0, 0, 0];

% Efficiency Parameters
disintegration_efficiency = 0.8; % 80% efficient plasma disintegration
reconstruction_efficiency = 0.75; % 75% efficient reconstruction

% Debugging: Initial Values
fprintf('Initial Missile Energy: %.2e Joules\n', missile_energy);
fprintf('Initial ZPE Available: %.2e Joules\n', zpe_available);

% Plasma Disintegration
energy_required_disintegration = missile_energy / disintegration_efficiency;
fprintf('Energy Required for Disintegration: %.2e Joules\n', energy_required_disintegration);

if zpe_available >= energy_required_disintegration
    fprintf('Disintegration successful!\n');
    zpe_available = zpe_available - energy_required_disintegration;
    disintegrated_material = missile_mass; % Assume full disintegration into plasma
else
    fprintf('ZPE insufficient for disintegration.\n');
    disintegrated_material = 0;
end
fprintf('Remaining ZPE After Disintegration: %.2e Joules\n', zpe_available);

% Reconstruction
if disintegrated_material > 0
    % Reconstruct materials into useful outputs
    energy_for_reconstruction = energy_required_disintegration * reconstruction_efficiency;
    fprintf('Energy Available for Reconstruction: %.2e Joules\n', energy_for_reconstruction);
    
    reconstructed_energy = energy_for_reconstruction * 0.5; % Half stored as clean energy
    oxygen_produced = (energy_for_reconstruction * 0.5) / 200; % Arbitrary factor for oxygen production
    
    fprintf('Reconstruction successful!\n');
    fprintf('Clean Energy Stored: %.2e Joules\n', reconstructed_energy);
    fprintf('Fresh Oxygen Produced: %.2f kg\n', oxygen_produced);
else
    fprintf('Reconstruction failed due to lack of disintegrated materials.\n');
    reconstructed_energy = 0;
    oxygen_produced = 0;
end

% Debugging: Final Energy States
fprintf('Final ZPE Available: %.2e Joules\n', zpe_available);
fprintf('Clean Energy Stored: %.2e Joules\n', reconstructed_energy);
fprintf('Fresh Oxygen Produced: %.2f kg\n', oxygen_produced);

% Visualization
figure;
labels = {'Disintegration Energy', 'Reconstructed Energy', 'Remaining ZPE'};
values = [energy_required_disintegration, reconstructed_energy, zpe_available];
pie(values, labels);
title('Energy Distribution in VectorSphere');

% Final Output Summary
fprintf('Final Results:\n');
fprintf(' - Disintegration Energy: %.2e Joules\n', energy_required_disintegration);
fprintf(' - Reconstructed Energy: %.2e Joules\n', reconstructed_energy);
fprintf(' - Remaining ZPE: %.2e Joules\n', zpe_available);
fprintf(' - Fresh Oxygen Produced: %.2f kg\n', oxygen_produced);