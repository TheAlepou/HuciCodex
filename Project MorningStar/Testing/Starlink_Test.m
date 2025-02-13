clc; clear; close all;

% Debugging
% type("starlink_latest.txt") % Replace with your actual TLE file name

% Create a satellite scenario
scenario = satelliteScenario;

% Define start time and duration
startTime = datetime(2025,2,13,0,0,0);
stopTime = startTime + days(1); % 1-day simulation
scenario.StartTime = startTime;
scenario.StopTime = stopTime;
scenario.SampleTime = 10; % 10-second intervals

% Open 3D Viewer
viewer = satelliteScenarioViewer(scenario);
viewer.ShowDetails = true; % Show satellite names & paths

% Load the TLE file
websave("Universe/Spacecraft and Space Travel/Testing/starlink_latest.txt", "https://celestrak.org/NORAD/elements/gp.php?GROUP=starlink&FORMAT=tle");
tleFile = "starlink_latest.txt";

% Read the TLE file
tleData = readlines(tleFile);

% Select specific Starlink satellites (e.g., the first 5 satellites)
numSatellites = 5;  % Change this number to add more or fewer satellites
selectedTLE = [];

for i = 1:numSatellites
    index = (i - 1) * 3 + 1;  % Every TLE has 3 lines
    selectedTLE = [selectedTLE; tleData(index:index+2)];
end

% Save the selected TLE data into a new file
filteredTLEFile = "Universe/Spacecraft and Space Travel/Testing/starlink_filtered.txt";
writematrix(selectedTLE, filteredTLEFile, 'FileType', 'text');

% Load the filtered TLE file into MATLAB
sat = satellite(scenario, filteredTLEFile);

% Run the scenario
play(scenario);