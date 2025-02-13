%% Project Morningstar V1
clc; clear; close all;

%% Create Satellite Scenario
startTime = datetime("now");
stopTime = startTime + days(1);   % 1-day simulation
sampleTime = 60;                  % 60-second update rate
scenario = satelliteScenario(startTime, stopTime, sampleTime, 'AutoSimulate', true);

%% Define Multiple Earth Stations (Power Receivers)
earthStation_Tokyo = groundStation(scenario, ...
    "Latitude", 35.6895, ...
    "Longitude", 139.6917, ...
    "Name", "Tokyo Power Receiver");

earthStation_NewYork = groundStation(scenario, ...
    "Latitude", 40.7128, ...
    "Longitude", -74.0060, ...
    "Name", "New York Power Receiver");

earthStation_London = groundStation(scenario, ...
    "Latitude", 51.5074, ...
    "Longitude", -0.1278, ...
    "Name", "London Power Receiver");

earthStation_Sydney = groundStation(scenario, ...
    "Latitude", -33.8688, ...
    "Longitude", 151.2093, ...
    "Name", "Sydney Power Receiver");

earthStation_Oradea = groundStation(scenario, ...
    "Latitude", 47.06667, ...
    "Longitude", 21.93333, ...
    "Name", "Oradea Power Receiver");

%% Download and Prepare TLE Data from Celestrak
tleFolder = "Project MorningStar/data";
if ~isfolder(tleFolder)
    mkdir(tleFolder);
end

% Save the downloaded file with a .tle extension
tleFile = fullfile(tleFolder, "starlink_latest.tle");
if ~isfile(tleFile)
    websave(tleFile, "https://celestrak.org/NORAD/elements/gp.php?GROUP=starlink&FORMAT=tle");
end

% Read the downloaded TLE file (each satellite should have 3 lines: Name, Line1, Line2)
tleData = readlines(tleFile);

% Check that the TLE file has at least 3 lines; if not, use a known valid TLE as fallback.
if numel(tleData) < 3
    warning('TLE file appears empty or incomplete. Using fallback TLE data.');
    tleData = [
        "STARLINK-1501"
        "1 44238U 19029D   23106.70210270  .00002276  00000-0  14271-4 0  9990"
        "2 44238  53.0000 200.0000 0001658  70.0000 290.0000 15.05555667  9995"
    ];
end

% Determine how many satellites are available in the file
numSatellitesInFile = floor(numel(tleData) / 3);
% Choose how many satellites you want (up to 15 or fewer if not available)
numSatellites = min(15, numSatellitesInFile);

%% Create Satellites Using Different TLE Blocks
satelliteArray = [];
selectedTLE = [];

for i = 1:numSatellites
    idx = (i-1)*3 + 1;  % Starting index for this satellite's TLE data
    % Save the selected TLE data into a new file
    for i = 1:numSatellites
        index = (i - 1) * 3 + 1;  % Every TLE has 3 lines
        selectedTLE = [selectedTLE; tleData(index:index+2)];
    end
    filteredTLEFile = fullfile(tleFolder, "starlink_filtered.tle");
    writematrix(selectedTLE, filteredTLEFile, 'FileType', 'text');
    %if ~isfile(filteredTLEFile)
        
    %end
        
    index = (i - 1) * 3 + 1;  % Every TLE has 3 lines
    selectedTLE = [selectedTLE; tleData(index:index+2)];
    try
        satObj = satellite(scenario, filteredTLEFile, 'Name', sprintf('Fusion Reactor Satellite %d', i));
    catch ME
        error('Error creating satellite %d. Please check the TLE data format.\n%s', i, ME.message);
    end
    satelliteArray = [satelliteArray, satObj];
end

%% Define Fusion Power Output (Tokamak Model)
P_fusion = 500e6;          % Fusion reactor power output in watts (500 MW)
efficiency = 0.40;         % Efficiency of power conversion
P_transmit = P_fusion * efficiency;  % Effective transmitted power (200 MW)

%% Define Plasma Physics Parameters
T_plasma = 150e6;          % Plasma temperature in Kelvin
n_plasma = 1e20;           % Plasma density (particles per m^3)
tau_energy = 3;            % Energy confinement time in seconds

% Lawson Criterion for Fusion (Simplified Fusion Gain Factor)
Q = (n_plasma * T_plasma * tau_energy) / (1e28);

%% Power Transmission to Earth (Laser Simulation)
wavelength = 1e-6;         % Laser wavelength (m)
beam_divergence = 0.001;   % Beam divergence (radians)
distance = 35e6;           % Approximate satellite-to-ground distance (m)

spot_size = distance * beam_divergence;         % Spot size at Earth's surface (m)
intensity = P_transmit / (pi * (spot_size / 2)^2);% Power intensity (W/m^2)

%% Visualize Energy Transmission
viewer = satelliteScenarioViewer(scenario);
hBeam = [];

%% Establish Access Links from One Satellite to Each Ground Station
% For demonstration, we use the first satellite in the array.
fusion_satellite = satelliteArray(1);
accessLink_Tokyo = access(fusion_satellite, earthStation_Tokyo);
accessLink_NewYork = access(fusion_satellite, earthStation_NewYork);
accessLink_London = access(fusion_satellite, earthStation_London);
accessLink_Sydney = access(fusion_satellite, earthStation_Sydney);
accessLink_Oradea = access(fusion_satellite, earthStation_Oradea);

%% Solar Panel Simulation - Sun Tracking
sun = groundStation(scenario, "Latitude", 0, "Longitude", 0, "Name", "Sun Reference", "Altitude", 1.496e11); % Sun's distance

%% Display Results
fprintf('Fusion Reactor Output: %.2f MW\n', P_fusion / 1e6);
fprintf('Transmitted Power: %.2f MW\n', P_transmit / 1e6);
fprintf('Laser Spot Size on Earth: %.2f m\n', spot_size);
fprintf('Power Intensity on Earth: %.2f W/m^2\n', intensity);
fprintf('Fusion Gain Factor (Q): %.2f\n', Q);