import numpy as np
import matplotlib.pyplot as plt
from scipy.fftpack import fft2, ifft2
from scipy.constants import hbar, electron_mass

# Simulation Parameters
grid_size = 100  # Increase resolution for more realism
dx = 1e-9  # Spatial step size (meters)
dt = 1e-18  # Time step (seconds)
timesteps = 100  # Number of time evolution steps

# Define the 2D spatial grid
x = np.linspace(-grid_size//2, grid_size//2, grid_size) * dx
y = np.linspace(-grid_size//2, grid_size//2, grid_size) * dx
X, Y = np.meshgrid(x, y)

# Step 1: Initialize a Quantum Wavefunction (Gaussian Distribution)
sigma = 10 * dx  # Initial wave packet width
psi = np.exp(-(X**2 + Y**2) / (2 * sigma**2))  # Gaussian wavefunction
psi = psi / np.linalg.norm(psi)  # Normalize wavefunction

# Step 2: Define Reality Warper's Influence as a Potential Field (V)
warper_strength = 1e-18  # Adjustable warper energy influence
V = np.exp(-((X/10e-9)**2 + (Y/10e-9)**2)) * warper_strength  # Warper potential at center

# Step 3: Schrödinger Equation Evolution (Time Propagation)
m = electron_mass  # Assume small quantum particle
laplacian_k = - (hbar**2 / (2 * m)) * (fft2(psi) * ((2 * np.pi * np.fft.fftfreq(grid_size, d=dx))**2)[:, None] +
                                       (2 * np.pi * np.fft.fftfreq(grid_size, d=dx))**2)

# Time Evolution Using Fourier Split-Step Method
for _ in range(timesteps):
    psi = ifft2(np.exp(-1j * dt * laplacian_k / hbar) * fft2(psi))  # Free evolution
    psi *= np.exp(-1j * dt * V / hbar)  # Apply Reality Warper's influence

# Step 4: Compute Probability Distribution & Collapse Reality
probability_distribution = np.abs(psi)**2  # Born Rule (|ψ|²)
collapse_threshold = np.percentile(probability_distribution, 75)  # Top 25% collapse
collapsed_reality = probability_distribution > collapse_threshold

# Visualization
fig, axes = plt.subplots(1, 3, figsize=(15, 5))

# Initial Wavefunction Visualization
axes[0].imshow(np.abs(psi), cmap='viridis', extent=[x.min(), x.max(), y.min(), y.max()])
axes[0].set_title("Quantum Wavefunction After Warper Influence")
axes[0].set_xlabel("X Position (nm)")
axes[0].set_ylabel("Y Position (nm)")

# Probability Distribution Visualization
axes[1].imshow(probability_distribution, cmap='plasma', extent=[x.min(), x.max(), y.min(), y.max()])
axes[1].set_title("Probability Distribution (Born Rule)")

# Collapsed Reality Visualization
axes[2].imshow(collapsed_reality, cmap='gray', extent=[x.min(), x.max(), y.min(), y.max()])
axes[2].set_title("Final Collapsed Reality")
axes[2].set_xlabel("X Position (nm)")

plt.colorbar(axes[0].imshow(np.abs(psi), cmap='viridis'), ax=axes[0])
plt.colorbar(axes[1].imshow(probability_distribution, cmap='plasma'), ax=axes[1])
plt.colorbar(axes[2].imshow(collapsed_reality, cmap='gray'), ax=axes[2])

plt.show()

# Display Probability Data
import pandas as pd
import ace_tools as tools

tools.display_dataframe_to_user(name="Quantum Probability Data", dataframe=pd.DataFrame(probability_distribution))