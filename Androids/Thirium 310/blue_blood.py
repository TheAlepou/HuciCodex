from openmm import *
from openmm.app import *
from openmm.unit import *
import numpy as np  # ✅ Required for generating positions

# ✅ 1. Define Topology
topology = Topology()
chain = topology.addChain()
residue = topology.addResidue("Molecule", chain)
atom = topology.addAtom("X", Element.getBySymbol("H"), residue)  # Example: Hydrogen

# ✅ 2. Create System
system = System()
num_molecules = 100  # Adjust for more molecules

# ✅ 3. Define Force Parameters
force = CustomNonbondedForce("138.935456*q1*q2/r + A1/r^12 - B1/r^6")

# 🚨 Define Parameters **BEFORE Using Them**
force.addGlobalParameter("A1", 0.1)  # Example Value: Adjust as needed
force.addGlobalParameter("B1", 0.1)  # Example Value: Adjust as needed
force.addPerParticleParameter("q")   # Charge parameter

# ✅ 4. Add Particles with Proper Values
positions = []  # ✅ Store positions here
spacing = 0.5  # ✅ Ensures NO OVERLAP

for i in range(num_molecules):
    system.addParticle(39.948 * amu)  # Example: Atomic mass
    force.addParticle([1.0])  # Charge value only

    # ✅ Assign **spaced-out** positions to avoid collisions
    x = (i % 10) * spacing
    y = ((i // 10) % 10) * spacing
    z = (i // 100) * spacing
    positions.append(Vec3(x, y, z) * nanometers)

# ✅ 5. Add Force to System
system.addForce(force)

# ✅ 6. Define Integrator
integrator = LangevinIntegrator(300*kelvin, 1/picosecond, 0.002*picoseconds)

# ✅ 7. Define Platform
platform = Platform.getPlatformByName("CPU")

# ✅ 8. Create Simulation
simulation = Simulation(topology, system, integrator, platform)

# 🚨 CRITICAL FIX: **Set Initial Particle Positions PROPERLY**
simulation.context.setPositions(positions)

# 🚨 Extra Fix: **Check for NaN before running**
state = simulation.context.getState(getPositions=True)
positions = state.getPositions(asNumpy=True)
if np.isnan(positions.value_in_unit(nanometers)).any():
    raise ValueError("🚨 ERROR: Particle positions contain NaN values!")

# ✅ 9. Run Simulation
simulation.step(1000)  # Run 1000 steps

print("✅ SUCCESS! Thirium 310 simulation running correctly.")