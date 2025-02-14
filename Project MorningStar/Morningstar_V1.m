%% Project Morningstar V1
clc; clear; close all;

%% Create Satellite Scenario
startTime = datetime("now");
stopTime = startTime + days(1);   % 1-day simulation
sampleTime = 60;                  % 60-second update rate
scenario = satelliteScenario(startTime, stopTime, sampleTime, 'AutoSimulate', true);
viewer = satelliteScenarioViewer(scenario);

%% Define Multiple Earth Stations (Power Receivers)
earthStations = [
    groundStation(scenario, "Latitude", 35.6895, "Longitude", 139.6917, "Name", "Tokyo Power Receiver");
    groundStation(scenario, "Latitude", 40.7128, "Longitude", -74.0060, "Name", "New York Power Receiver");
    groundStation(scenario, "Latitude", 51.5074, "Longitude", -0.1278, "Name", "London Power Receiver");
    groundStation(scenario, "Latitude", -33.8688, "Longitude", 151.2093, "Name", "Sydney Power Receiver");
    groundStation(scenario, "Latitude", 47.06667, "Longitude", 21.93333, "Name", "Oradea Power Receiver")
];

%% Download and Prepare TLE Data from Celestrak
tleFolder = "Project MorningStar/data";
if ~isfolder(tleFolder)
    mkdir(tleFolder);
end

tleFile = fullfile(tleFolder, "starlink_latest.tle");
if ~isfile(tleFile)
    websave(tleFile, "https://celestrak.org/NORAD/elements/gp.php?GROUP=starlink&FORMAT=tle");
end

tleData = readlines(tleFile);
numSatellitesInFile = floor(numel(tleData) / 3);
numSatellites = min(15, numSatellitesInFile);

%% Create Satellites Using Unique TLE Blocks
satelliteArray = [];
for i = 1:numSatellites
    idx = (i-1)*3 + 1;
    currentTLE = tleData(idx:idx+2);
    tleFileName = fullfile(tleFolder, sprintf("satellite_%d.tle", i));
    writematrix(currentTLE, tleFileName, 'FileType', 'text');
    try
        satObj = satellite(scenario, tleFileName, 'Name', sprintf('MorningStar-%d', i));
        satelliteArray = [satelliteArray, satObj];
    catch ME
        warning('Error creating satellite %d. Check TLE format.', i);
    end
end

%% Establish Access Links Dynamically (Ensuring All Satellites Have a Line)
accessLinks = cell(numSatellites, numel(earthStations));

for s = 1:numel(satelliteArray)
    minDist = inf;
    closestGS = [];
    
    for g = 1:numel(earthStations)
        gsPos = [earthStations(g).Latitude, earthStations(g).Longitude, 0];
        satPos = states(satelliteArray(s));
        dist = norm(satPos(1:3) - lla2ecef(gsPos));
        if dist < minDist
            minDist = dist;
            closestGS = earthStations(g);
        end
    end
    
    if ~isempty(closestGS)
        accessLinks{s, g} = access(satelliteArray(s), closestGS);
    end
end

%% Define Fusion Reactor Parameters (Tokamak Model) and Assign to Satellites
P_fusion = 500e6;           % Fusion reactor power output in watts (500 MW)
efficiency = 0.40;          % Efficiency of power conversion
P_transmit = P_fusion * efficiency;  % Effective transmitted power (200 MW)
T_plasma = 150e6;           % Plasma temperature in Kelvin
n_plasma = 1e20;            % Plasma density (particles per m^3)
tau_energy = 3;             % Energy confinement time in seconds
Q = (n_plasma * T_plasma * tau_energy) / (1e28);  % Lawson Criterion (fusion gain factor)

%% Print Fusion Parameters for Each Satellite
for i = 1:numel(satelliteArray)
    fprintf('Satellite %d - %s:\n', i, satelliteArray(i).Name);
    fprintf('  Fusion Reactor Output: %.2f MW\n', P_fusion / 1e6);
    fprintf('  Transmitted Power: %.2f MW\n', P_transmit / 1e6);
    fprintf('  Plasma Temperature: %.2e K\n', T_plasma);
    fprintf('  Plasma Density: %.2e particles/m^3\n', n_plasma);
    fprintf('  Energy Confinement Time: %.2f s\n', tau_energy);
    fprintf('  Fusion Gain Factor (Q): %.2f\n\n', Q);
end

%% Force Viewer to Refresh
drawnow;