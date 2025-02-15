%% Thirium-310 Advanced Simulation (V3)
% Simulating electrical conductivity, magnetic response, AI behavior, self-healing,
% and now with chaotic motion, energy conservation, and smoother visualization.

clc; clear; close all;

%% Basic Parameters
numParticles = 100;  % Number of Thirium-310 units
timeSteps = 100;     % Time steps for simulation
dt = 0.01;           % Time step size

% Particle properties
mass = rand(numParticles,1) * 5 + 1;
charge = rand(numParticles,1) * 10;
energyLevel = rand(numParticles,1) * 100 + 50; % Randomized energy levels
position = rand(numParticles,2) * 20 - 10;
velocity = rand(numParticles,2) * 2 - 1;

% New: Adding Brownian Motion for randomness
brownianMotion = randn(numParticles, 2) * 0.1; % Small random movements

damagedParticles = zeros(numParticles,1); % Track damaged particles

% Magnetic Field Strength (Variable over space)
B = [rand() * 2, rand() * 2]; % Changes dynamically

%% Neural Network Properties
neuralWeights = rand(numParticles,1) * 5;
neuralThreshold = 10;
neuralInput = zeros(numParticles,1);
neuralOutput = zeros(numParticles,1);

%% Visualization Setup
figure;
hold on;

% Particle Trail Memory
trailLength = 10; % How many past positions to store
positionTrail = nan(numParticles, trailLength, 2);

for t = 1:timeSteps
    %% Energy Conservation Mechanism
    % Introduce gradual energy transfer instead of instant loss/gain
    energyDiffusionRate = 0.1;
    energyDecay = 0.005; % Small loss per step

    for i = 1:numParticles
        if damagedParticles(i) == 1
            distances = sqrt(sum((position - position(i,:)).^2,2));
            healers = (distances < 3) & (energyLevel > 60);
            
            if sum(healers) > 0
                healingEnergy = min(energyLevel(healers)) * energyDiffusionRate;
                energyLevel(i) = energyLevel(i) + healingEnergy;
                energyLevel(healers) = energyLevel(healers) - healingEnergy * 0.5;
                damagedParticles(i) = energyLevel(i) >= 50; % Mark as healed
            end
        end
    end

    % Decay factor to prevent unnatural energy buildup
    energyLevel = energyLevel - energyDecay;
    energyLevel = max(energyLevel, 0); % Prevent negative energy

    %% Apply Forces (Electric, Magnetic, and Randomness)
    Efield = charge ./ mass;
    forceE = Efield .* [1,1];
    
    % New: Variable Magnetic Field
    localB = B .* (0.5 + rand(numParticles, 2) * 1.5); % Changes dynamically
    forceB = cross([velocity, zeros(numParticles,1)], [localB(:,1), localB(:,2), zeros(numParticles,1)]);
    forceB = forceB(:,1:2);
    
    % New: Velocity Variation (Some molecules move faster)
    speedVariation = rand(numParticles,1) * 0.5 + 0.75; 
    velocity = velocity + (forceE + forceB) * dt .* speedVariation;

    % Brownian motion for chaotic movement
    velocity = velocity + brownianMotion;
    
    %% Update Positions
    position = position + velocity * dt;
    
    % Store position in trail
    positionTrail(:, 2:end, :) = positionTrail(:, 1:end-1, :); % Shift history
    positionTrail(:,1,:) = position; % Update newest position

    %% Neural Network Processing
    neuralInput = energyLevel ./ (mass + 1);
    neuralOutput = tanh(neuralWeights .* neuralInput - neuralThreshold);
    firingNeurons = neuralOutput > 0.5;
    
    % High-energy molecules react differently
    energyLevel(firingNeurons) = energyLevel(firingNeurons) + 5;
    
    % New: Energy Prioritization
    % If a molecule is low energy, high-energy ones react
    for i = 1:numParticles
        if energyLevel(i) < 30
            nearbyParticles = sqrt(sum((position - position(i,:)).^2,2)) < 3;
            highEnergyDonors = (energyLevel > 80) & nearbyParticles;
            if sum(highEnergyDonors) > 0
                transferAmount = 2;
                energyLevel(i) = energyLevel(i) + transferAmount;
                energyLevel(highEnergyDonors) = energyLevel(highEnergyDonors) - transferAmount * 0.5;
            end
        end
    end

    %% Visualization
    clf;
    
    % New: Smooth color transition
    scatter(position(:,1), position(:,2), 50, energyLevel, 'filled');
    colormap(jet);
    colorbar;
    
    % Particle trails
    hold on;
    for i = 1:numParticles
        plot(squeeze(positionTrail(i,:,1)), squeeze(positionTrail(i,:,2)), '-', 'Color', [0 0 0 0.3]);
    end
    hold off;
    
    title('Thirium-310 Advanced Simulation: Self-Healing, Conductivity, and AI');
    xlabel('X Position'); ylabel('Y Position');
    
    drawnow;
end