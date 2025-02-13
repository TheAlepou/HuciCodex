clc; clear; close all;

% Create Satellite Scenario (AutoSimulate enabled)
startTime = datetime("now");
stopTime = startTime + days(1);  % Simulate for 1 day
sampleTime = 60;  % 60-second update rate
scenario = satelliteScenario(startTime, stopTime, sampleTime, 'AutoSimulate', true);

% Define Multiple Earth Stations (Power Receivers)
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

% Ensure the directory exists for saving TLE files
tleFolder = "Project MorningStar/data";
if ~isfolder(tleFolder)
    mkdir(tleFolder);
end

% Load the TLE file from Celestrak
tleFile = fullfile(tleFolder, "starlink_latest.txt");

if ~isfile(tleFile), startTime;
    websave(tleFile, "https://celestrak.org/NORAD/elements/gp.php?GROUP=starlink&FORMAT=tle");
end

% Read the TLE file
tleData = readlines(tleFile);

% Select specific Starlink satellites (e.g., the first 5 satellites)
numSatellites = 15;  % Change this number to add more or fewer satellites
selectedTLE = [];

for i = 1:numSatellites
    index = (i - 1) * 3 + 1;  % Every TLE has 3 lines
    selectedTLE = [selectedTLE; tleData(index:index+2)];
end

% Save the selected TLE data into a new file
filteredTLEFile = fullfile(tleFolder, "starlink_filtered.txt");
writematrix(selectedTLE, filteredTLEFile, 'FileType', 'text');

% Load the filtered TLE file into MATLAB
sat = satellite(scenario, filteredTLEFile);

% Establish Access Links from the Satellite to Each Ground Station
accessLink_Tokyo = access(sat, earthStation_Tokyo);
accessLink_NewYork = access(sat, earthStation_NewYork);
accessLink_London = access(sat, earthStation_London);
accessLink_Sydney = access(sat, earthStation_Sydney);
accessLink_Oradea = access(sat, earthStation_Oradea);

% Solar Panel Simulation - Sun Tracking
sun = groundStation(scenario, "Latitude", 0, "Longitude", 0, "Name", "Sun Reference", "Altitude", 1.496e11); % Sun's distance

% Open the Viewer (Auto-Simulation will start!)
viewer = satelliteScenarioViewer(scenario);