%% Thirium-310 Advanced Simulation
% This script simulates Thirium-310 with electrical conductivity,
% magnetic field response, neural network properties, and self-healing.

clc; clear; close all;

%% Basic Parameters
% Number of particles (Thirium-310 units)
numParticles = 100;
timeSteps = 1000;
dt = 0.01; % Time step

% Particle properties
mass = rand(numParticles,1) * 5 + 1; % Random mass between 1 and 6
charge = rand(numParticles,1) * 10; % Random charge
energyLevel = rand(numParticles,1) * 100 + 50; % Random energy (50-150)
position = randn(numParticles,2) * 2; % Initial positions
velocity = rand(numParticles,2) * 2 - 1; % Initial velocities

damagedParticles = zeros(numParticles,1); % Track damaged particles

% Magnetic Field Strength (Tesla)
B = [0, max(mass) * 5]; % Stronger field

%% Neural Network (simulated adaptive intelligence)
neuralWeights = rand(numParticles,1) * 5;
neuralFiringThreshold = 5;
neuralInput = zeros(numParticles,1);
neuralOutput = zeros(numParticles,1);

figure;
for t = 1:timeSteps
    % Apply forces (self-repairing and interaction behavior)
    Efield = charge ./ mass; % Electric field effect
    forceE = Efield .* [1,1];
    % Convert velocity into 3D space by appending a zero z-component
    velocity3D = [velocity, zeros(numParticles,1)];
    
    % Convert B into a 3D vector
    B3D = repmat([B(1), B(2), 0], numParticles, 1);
    
    % Compute cross product
    forceB3D = cross(velocity3D, B3D);
    
    % Extract only the x-y components
    forceB = forceB3D(:,1:2);
    velocity = velocity + (forceE + forceB) * dt;
    
    % Update positions
    position = position + velocity * dt;
    
    % Damage simulation (random energy loss)
    energyLoss = energyLevel * 0.005; % Only 0.5% lost per step
    energyLevel = energyLevel - energyLoss;
    damagedParticles(energyLevel < 30) = 1; % Mark particles as damaged

    energyLevel(energyLevel < 5) = 5; % Prevent particles from reaching zero energy
    
    % Self-healing Mechanism
    for i = 1:numParticles
        if damagedParticles(i) == 1
            distances = sqrt(sum((position - position(i,:)).^2,2));
            healers = (distances < 5) & (energyLevel > 30); % More particles qualify
    
            if sum(healers) > 0
                healingEnergy = mean(energyLevel(healers)) * 0.3; % Boost healing efficiency
                energyLevel(i) = energyLevel(i) + healingEnergy;
                energyLevel(healers) = energyLevel(healers) - healingEnergy * 0.1; % Reduce drain on healers
          
                % Reduce the amount of energy given per step
                healingEnergy = healingEnergy * 0.05; % Healing slowed down to 5% per step
                
                % Reduce energy loss per step
                energyLoss = energyLoss * 0.1; % Slower decay
                
                % Cap the maximum energy level per particle
                energyLevel = min(energyLevel, 100);  % Max limit of 100 (adjust as needed)

                damagedParticles(i) = energyLevel(i) >= 50; % Mark as healed
                energyLevel = min(energyLevel + rand(numParticles,1) * 2, 150); % Small boost per step
            end
        end
    end
    
    % Neural Network Processing (AI-like behavior)
    neuralInput = energyLevel ./ (mass + 1);
    neuralOutput = tanh(neuralWeights .* neuralInput - neuralFiringThreshold);
    firingNeurons = neuralOutput > 0.5;

    % Boost healing for active neurons (adaptive response)
    energyLevel(firingNeurons) = energyLevel(firingNeurons) + 5;
    
    energyLevel(isnan(energyLevel) | isinf(energyLevel)) = 50; % Reset invalid values

    % Plot real-time visualization
    scatter(position(:,1), position(:,2), 50, energyLevel, 'filled');
    colormap(jet);
    colorbar;
    title('Thirium-310 Simulation: Self-Healing, Conductivity, and Neural Response');
    xlabel('X Position'); ylabel('Y Position');
    drawnow;
end
