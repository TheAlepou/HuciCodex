clc; clear; close all;

% Constants
hbar = 1.054571817e-34; % Planck’s constant (J·s)
m = 9.10938356e-31; % Electron mass (kg)
grid_size = 100; % Grid resolution
dx = 1e-9; % Spatial step size (meters)
dt = 1e-18; % Time step (seconds)
timesteps = 100; % Number of evolution steps

% Define spatial grid
x = linspace(-grid_size/2, grid_size/2, grid_size) * dx;
y = linspace(-grid_size/2, grid_size/2, grid_size) * dx;
[X, Y] = meshgrid(x, y);

% Step 1: Initialize Quantum Wavefunction (Gaussian Packet)
sigma = 10 * dx; % Width of wave packet
psi = exp(-(X.^2 + Y.^2) / (2 * sigma^2)); % Gaussian wavefunction
psi = psi / norm(psi(:)); % Normalize wavefunction

% Step 2: Define Reality Warper’s Potential Field (V)
warper_strength = 1e-18; % Warper’s energy disturbance
V = exp(-((X/10e-9).^2 + (Y/10e-9).^2)) * warper_strength; % Warper potential

% Step 3: Compute Laplacian (Fourier Method for Schrödinger Equation)
kx = (2 * pi / dx) * fftshift(linspace(-grid_size/2, grid_size/2, grid_size));
ky = (2 * pi / dx) * fftshift(linspace(-grid_size/2, grid_size/2, grid_size));
[KX, KY] = meshgrid(kx, ky);
laplacian_k = -(hbar^2 / (2 * m)) * (KX.^2 + KY.^2);

% Time Evolution Using Fourier Split-Step Method
for t = 1:timesteps
    psi = ifft2(exp(-1i * dt * laplacian_k / hbar) .* fft2(psi)); % Free evolution
    psi = psi .* exp(-1i * dt * V / hbar); % Apply Reality Warper’s effect
end

% Step 4: Compute Probability Distribution & Reality Collapse
probability_distribution = abs(psi).^2; % Born Rule (|ψ|²)
collapse_threshold = prctile(probability_distribution(:), 75); % Collapse Top 25%
collapsed_reality = probability_distribution > collapse_threshold;

% Visualization
figure;

% Initial Quantum Wavefunction Visualization
subplot(1,3,1);
imagesc(x*1e9, y*1e9, abs(psi));
title('Quantum Wavefunction After Warper Influence');
xlabel('X Position (nm)');
ylabel('Y Position (nm)');
colorbar;

% Probability Distribution Visualization
subplot(1,3,2);
imagesc(x*1e9, y*1e9, probability_distribution);
title('Probability Distribution (Born Rule)');
xlabel('X Position (nm)');
colorbar;

% Final Collapsed Reality Visualization
subplot(1,3,3);
imagesc(x*1e9, y*1e9, collapsed_reality);
title('Final Collapsed Reality');
xlabel('X Position (nm)');
colormap('abyss');
colorbar;

% Display Numerical Data
disp('Probability Distribution Data:');
disp(probability_distribution);

disp('Final Collapsed Reality (Binary States):');
disp(collapsed_reality);