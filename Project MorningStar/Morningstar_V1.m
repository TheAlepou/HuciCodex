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

pause(1); % Adds a small delay to allow MATLAB to process objects properly

clear accessLinks; % This ensures a clean slate
accessLinks = struct();

% Set a larger laser range (modify as needed)
maxLaserRange = 15000e3;  % 15,000 km (increase if needed)


for s = 1:numel(satelliteArray)
    for g = 1:numel(earthStations)
        satPos = states(satelliteArray(s)); % Get satellite position
        gsPos = [earthStations(g).Latitude, earthStations(g).Longitude, 0];

        dist = norm(satPos(1:3) - lla2ecef(gsPos));
        fprintf('Checking %s -> %s, Distance: %.2f km\n', ...
            satelliteArray(s).Name, earthStations(g).Name, dist/1000);
    end
end

% Ensure the struct exists
if ~exist('accessLinks', 'var') || ~isstruct(accessLinks)
    accessLinks = struct();
end

for s = 1:numel(satelliteArray)
    minDist = inf;
    closestGS = [];

    for g = 1:numel(earthStations)
        gsPos = [earthStations(g).Latitude, earthStations(g).Longitude, 0];
        satPos = states(satelliteArray(s));

        dist = norm(satPos(1:3) - lla2ecef(gsPos));

        fprintf('Checking %s -> %s, Distance: %.2f km\n', ...
            satelliteArray(s).Name, earthStations(g).Name, dist/1000);

        % Instead of taking the absolute closest, check if it is within range
        if dist < minDist && dist < maxLaserRange  % Increase max allowed distance
            minDist = dist;
            closestGS = earthStations(g);
        end
    end

    if ~isempty(closestGS)
        try
            fixedFieldName = matlab.lang.makeValidName(satelliteArray(s).Name);

            % Delete previous access object if it exists
            if isfield(accessLinks, fixedFieldName)
                if isvalid(accessLinks.(fixedFieldName))
                    delete(accessLinks.(fixedFieldName));
                end
                accessLinks = rmfield(accessLinks, fixedFieldName);
            end

            % Create a new access object
            newAccessLink = access(satelliteArray(s), closestGS);

            if isvalid(newAccessLink)
                accessLinks.(fixedFieldName) = newAccessLink;
                fprintf('✅ Access link created for %s to %s\n', satelliteArray(s).Name, closestGS.Name);
            else
                fprintf('❌ Failed to create valid access link for %s\n', satelliteArray(s).Name);
            end

        catch ME
            fprintf('⚠️ Error creating access link for %s: %s\n', satelliteArray(s).Name, ME.message);
        end
    else
        fprintf('🚨 No valid power receiver found within %.0f km for %s\n', maxLaserRange/1000, satelliteArray(s).Name);
    end
end

for s = 1:numel(satelliteArray)
    validReceivers = [];  % Reset valid receivers list
    
    % Find all ground stations within range
    for g = 1:numel(earthStations)
        gsPos = [earthStations(g).Latitude, earthStations(g).Longitude, 0];
        satPos = states(satelliteArray(s));  % Get satellite position

        dist = norm(satPos(1:3) - lla2ecef(gsPos));

        if dist < maxLaserRange
            validReceivers = [validReceivers, earthStations(g)]; % Add station to valid list
        end
    end  

    % Allow multiple connections instead of just one
    if ~isempty(validReceivers)
        for g = 1:numel(validReceivers)
            try
                accessLinks(s, g) = access(satelliteArray(s), validReceivers(g));
                fprintf('Access link created for %s to %s\n', ...
                        satelliteArray(s).Name, validReceivers(g).Name);
            catch ME
                fprintf('Failed to create access link for %s to %s: %s\n', ...
                        satelliteArray(s).Name, validReceivers(g).Name, ME.message);
            end
        end
    else
        fprintf('⚠️ No valid receivers found for %s\n', satelliteArray(s).Name);
    end
end

%% Debugging
for s = 1:numel(satelliteArray)
    minDist = inf;
    closestGS = [];
    
    for g = 1:numel(earthStations)
        gsPos = [earthStations(g).Latitude, earthStations(g).Longitude, 0];
        satPos = states(satelliteArray(s)); % Get current satellite position
        
        dist = norm(satPos(1:3) - lla2ecef(gsPos));

        fprintf('Distance from %s to %s: %.2f km\n', satelliteArray(s).Name, earthStations(g).Name, dist/1000);
        
        if dist < minDist
            minDist = dist;
            closestGS = earthStations(g);
        end
    end
    
    fprintf('Closest station to %s is %s at %.2f km\n', satelliteArray(s).Name, closestGS.Name, minDist/1000);
    
    if ~isempty(closestGS)
        try
            accessLinks(s) = access(satelliteArray(s), closestGS);
            fprintf('Access link created for %s to %s\n', satelliteArray(s).Name, closestGS.Name);
        catch ME
            fprintf('Failed to create access link for %s: %s\n', satelliteArray(s).Name, ME.message);
        end
    end
end

for s = 1:numel(satelliteArray)
    if ~isfield(accessLinks, matlab.lang.makeValidName(satelliteArray(s).Name))
        fprintf('WARNING: %s has NO access link assigned!\n', satelliteArray(s).Name);
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
% Base values
P_fusion_base = 500e6;  % Base power output in watts (500 MW)
efficiency_base = 0.40; % Base efficiency (40%)
T_plasma_base = 150e6;  % Base plasma temperature in Kelvin
n_plasma_base = 1e20;   % Base plasma density (particles per m^3)
tau_energy_base = 3;    % Base energy confinement time in seconds

% Generate realistic deviations per satellite
reactorParams = struct([]);

for i = 1:numSatellites
    % Random variations within ±5%
    P_fusion = P_fusion_base * (0.95 + 0.1 * rand());
    efficiency = efficiency_base * (0.95 + 0.05 * rand());
    P_transmit = P_fusion * efficiency;

    T_plasma = T_plasma_base * (0.98 + 0.04 * rand());
    n_plasma = n_plasma_base * (0.97 + 0.06 * rand());
    tau_energy = tau_energy_base * (0.95 + 0.07 * rand());

    % Compute the Fusion Gain Factor (Q)
    Q = (n_plasma * T_plasma * tau_energy) / (1e28);

    % Store parameters for this satellite
    reactorParams(i).P_fusion = P_fusion;
    reactorParams(i).P_transmit = P_transmit;
    reactorParams(i).T_plasma = T_plasma;
    reactorParams(i).n_plasma = n_plasma;
    reactorParams(i).tau_energy = tau_energy;
    reactorParams(i).Q = Q;
    
    % Print the parameters
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
disp('Refreshing scenario...'); 
play(scenario); % Forces MATLAB to update the scenario and rerun access computations