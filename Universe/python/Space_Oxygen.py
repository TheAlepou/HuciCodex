import numpy as np
import pandas as pd
import ace_tools as tools

# Define planetary atmosphere compositions (approximate values)
planets = {
    "Mars": {"CO2": 0.96, "N2": 0.02, "O2": 0.001},
    "Venus": {"CO2": 0.965, "N2": 0.035, "O2": 0.0001},
    "Titan": {"CH4": 0.05, "N2": 0.95, "CO2": 0.0001},
    "Europa": {"O2": 0.0001, "H2O": 0.99},
    "Kepler-442b": {"CO2": 0.85, "N2": 0.10, "O2": 0.02},  # Hypothetical exoplanet
    "TOI-700d": {"CO2": 0.70, "N2": 0.25, "O2": 0.03},  # Hypothetical exoplanet
}

# Define efficiency rates for oxygen extraction (assumed values)
efficiency_CO2 = 0.3  # 30% efficiency in extracting oxygen from CO2
efficiency_H2O = 0.8  # 80% efficiency in extracting oxygen from ice electrolysis
efficiency_CH4 = 0.2  # 20% efficiency in cracking methane

# Estimate potential oxygen yield for each planet
oxygen_yield = {}
for planet, gases in planets.items():
    O2_production = 0
    if "CO2" in gases:
        O2_production += gases["CO2"] * efficiency_CO2
    if "H2O" in gases:
        O2_production += gases["H2O"] * efficiency_H2O
    if "CH4" in gases:
        O2_production += gases["CH4"] * efficiency_CH4
    oxygen_yield[planet] = O2_production

# Convert results into a DataFrame
df = pd.DataFrame.from_dict(oxygen_yield, orient='index', columns=['Estimated O2 Yield'])
df.index.name = "Planetary Body"

# Display results
tools.display_dataframe_to_user(name="Oxygen Production Simulation", dataframe=df)