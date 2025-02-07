clc;
clear;
close all;

% Simulation Parameters
T_max = 1000; % Maximum time steps
space_size = 50; % Universe grid size
entropy = zeros(space_size, space_size); % Initialize entropy map
matter_density = 1; % Initial matter density
usable_energy = 1e12; % Initial energy (arbitrary large number)
space_time_factor = 1; % Initial spatial stability
quantum_stability = 1; % Initial quantum coherence (1 = stable, 0 = collapse)

% Decay Rates
entropy_growth_rate = 0.01; % Entropy increase per step
matter_decay_rate = 0.0005; % Matter disappearing over time
energy_decay_rate = 0.005; % Energy depleting over time
space_time_collapse_rate = 0.002; % Distortion of space over time
quantum_instability_threshold = 0.1; % When quantum stability drops below this, collapse begins

% Store history for visualization
entropy_history = zeros(T_max, 1);
matter_history = zeros(T_max, 1);
energy_history = zeros(T_max, 1);
space_time_history = zeros(T_max, 1);
quantum_history = zeros(T_max, 1);

% Simulation Loop
for t = 1:T_max
    % Increase entropy everywhere
    entropy = entropy + entropy_growth_rate * rand(space_size, space_size);
    entropy_history(t) = mean(entropy(:));
    
    % Decay matter density and energy
    matter_density = max(0, matter_density - matter_decay_rate);
    usable_energy = max(0, usable_energy - energy_decay_rate * usable_energy);
    space_time_factor = max(0, space_time_factor - space_time_collapse_rate);
    quantum_stability = max(0, quantum_stability - 0.01 * rand()); % Random quantum instability
    
    % Store history
    matter_history(t) = matter_density;
    energy_history(t) = usable_energy;
    space_time_history(t) = space_time_factor;
    quantum_history(t) = quantum_stability;
    
    % Check for universe collapse condition
    if quantum_stability < quantum_instability_threshold
        fprintf('⚠️ WARNING: Quantum stability is below threshold at t = %d! Reality collapse imminent.\n', t);
        break;
    end
end

% Visualization
figure;
subplot(2,2,1);
plot(1:t, entropy_history(1:t), 'r', 'LineWidth', 2);
title('Entropy Over Time'); xlabel('Time'); ylabel('Entropy Level');

title('Matter Density Over Time'); xlabel('Time'); ylabel('Density');
subplot(2,2,2);
plot(1:t, energy_history(1:t), 'b', 'LineWidth', 2);
title('Usable Energy Over Time'); xlabel('Time'); ylabel('Energy');

subplot(2,2,3);
plot(1:t, space_time_history(1:t), 'g', 'LineWidth', 2);
title('Space-Time Stability Over Time'); xlabel('Time'); ylabel('Stability');

subplot(2,2,4);
plot(1:t, quantum_history(1:t), 'm', 'LineWidth', 2);
title('Quantum Stability Over Time'); xlabel('Time'); ylabel('Quantum Coherence');
