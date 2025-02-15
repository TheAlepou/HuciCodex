import numpy as np
import matplotlib.pyplot as plt

# Constants
numParticles = 100  # Number of particles
timeSteps = 100  # Simulation time steps
dt = 0.01  # Time step duration

# Particle properties
mass = np.random.rand(numParticles) * 5 + 1  # Random mass between 1 and 6
charge = np.random.rand(numParticles) * 10  # Random charge
energyLevel = np.random.rand(numParticles) * 100 + 50  # Energy 50-150
position = np.random.rand(numParticles, 2) * 20 - 10  # Initial positions
velocity = np.random.rand(numParticles, 2) * 2 - 1  # Initial velocities
damagedParticles = np.zeros(numParticles)  # Track damaged particles

# Magnetic field properties (Tesla)
B = np.array([0, max(mass)])

# Neural Network Properties (Simulated Intelligence)
neuralWeights = np.random.rand(numParticles) * 5
neuralFiringThreshold = 10
neuralInput = np.zeros(numParticles)
neuralOutput = np.zeros(numParticles)

# Brownian Motion Factor (Random Motion Influence)
brownianFactor = 0.02

# Start simulation loop
plt.figure()
for t in range(timeSteps):
    # Apply forces (Electric & Magnetic Field Effects)
    Efield = charge / mass  # Electric field effect
    forceE = np.column_stack((Efield, Efield))
    forceB = np.cross(np.column_stack((velocity, np.zeros(numParticles))), [B[0], B[1], 0])
    forceB = forceB[:, :2]
    velocity += (forceE + forceB) * dt

    # Brownian motion (Random perturbations)
    velocity += (np.random.rand(numParticles, 2) - 0.5) * brownianFactor

    # Update positions
    position += velocity * dt

    # Damage simulation (Random energy loss)
    energyLoss = np.random.rand(numParticles) * 5
    energyLevel -= energyLoss
    damagedParticles[energyLevel < 30] = 1  # Mark as damaged

    # Self-healing Mechanism
    for i in range(numParticles):
        if damagedParticles[i] == 1:
            distances = np.linalg.norm(position - position[i], axis=1)
            healers = (distances < 3) & (energyLevel > 50)
            
            if np.sum(healers) > 0:
                healingEnergy = min(energyLevel[healers]) * 0.1
                energyLevel[i] += healingEnergy
                energyLevel[healers] -= healingEnergy * 0.5
                damagedParticles[i] = energyLevel[i] >= 50  # Mark as healed

    # Neural Network Processing (AI-like behavior)
    neuralInput = energyLevel / (mass + 1)
    neuralOutput = np.tanh(neuralWeights * neuralInput - neuralFiringThreshold)
    firingNeurons = neuralOutput > 0.5

    # Boost healing for active neurons (adaptive response)
    energyLevel[firingNeurons] += 5

    # Ensure energy stays within limits
    energyLevel = np.clip(energyLevel, 0, 150)

    # Real-time Visualization
    plt.clf()
    plt.scatter(position[:, 0], position[:, 1], c=energyLevel, cmap='jet', s=50, edgecolors='k')
    plt.colorbar(label='Energy Level')
    plt.title("Thirium-310 Advanced Simulation: Self-Healing, Conductivity, and Neural Response")
    plt.xlabel("X Position")
    plt.ylabel("Y Position")
    plt.pause(0.05)

plt.show()