clc;
clear;
close all;

% Create interactive figure with a larger height for sliders and buttons
f = figure('Name', 'VectorSphere Interactive Simulation', 'NumberTitle', 'off', ...
           'Position', [100, 100, 800, 700]);

% Default Constants
time_steps = 100;
initial_water_contamination = 1000; % Water contamination level
initial_soil_contamination = 800; % Soil contamination level
initial_air_contamination = 500; % Air contamination level
zpe_available = 2.5e9; % ZPE available in Joules

% Adjust space for UI
ui_panel_height = 120; % Space reserved for sliders and buttons
axes_panel_height = f.Position(4) - ui_panel_height; % Remaining space for graphs

% Efficiency sliders
slider_width = 150;
slider_height = 20;
slider_y = 20; % Bottom margin for sliders
slider_spacing = 30;

uicontrol('Style', 'text', 'Position', [20, slider_y + 2 * slider_spacing, slider_width, 20], ...
          'String', 'Water Efficiency', 'HorizontalAlignment', 'left');
water_eff_slider = uicontrol('Style', 'slider', 'Min', 0.1, 'Max', 1.0, 'Value', 0.9, ...
                             'Position', [150, slider_y + 2 * slider_spacing, slider_width, slider_height]); % Water slider, measures the efficiency of water purification
                         
uicontrol('Style', 'text', 'Position', [20, slider_y + slider_spacing, slider_width, 20], ...
          'String', 'Soil Efficiency', 'HorizontalAlignment', 'left');
soil_eff_slider = uicontrol('Style', 'slider', 'Min', 0.1, 'Max', 1.0, 'Value', 0.85, ...
                            'Position', [150, slider_y + slider_spacing, slider_width, slider_height]); % This is the Soil slider, it measures the efficiency of soil purification.
                         
uicontrol('Style', 'text', 'Position', [20, slider_y, slider_width, 20], ...
          'String', 'Air Efficiency', 'HorizontalAlignment', 'left');
air_eff_slider = uicontrol('Style', 'slider', 'Min', 0.1, 'Max', 1.0, 'Value', 0.8, ...
                           'Position', [150, slider_y, slider_width, slider_height]); % This is the air slider. It measures the efficiency of air purification in the soil and water

% Buttons
button_width = 120;
button_height = 40;
uicontrol('Style', 'pushbutton', 'String', 'Run Simulation', ...
          'Position', [350, slider_y + slider_spacing, button_width, button_height], ...
          'Callback', @(~, ~) runSimulation(f, water_eff_slider, soil_eff_slider, air_eff_slider, ...
                                            initial_water_contamination, initial_soil_contamination, ...
                                            initial_air_contamination, zpe_available, time_steps));

% Simulation Function
function runSimulation(f, water_eff_slider, soil_eff_slider, air_eff_slider, ...
                       initial_water_contamination, initial_soil_contamination, ...
                       initial_air_contamination, zpe_available, time_steps)
    % Get efficiency values
    water_efficiency = water_eff_slider.Value;
    soil_efficiency = soil_eff_slider.Value;
    air_efficiency = air_eff_slider.Value;

    % Energy constants
    energy_per_water_unit = 5e5;
    energy_per_soil_unit = 6e5;
    energy_per_air_unit = 4e5;

    % Contamination levels
    water_contamination = zeros(1, time_steps+1);
    soil_contamination = zeros(1, time_steps+1);
    air_contamination = zeros(1, time_steps+1);
    zpe_levels = zeros(1, time_steps+1);

    % Initialize levels
    water_contamination(1) = initial_water_contamination;
    soil_contamination(1) = initial_soil_contamination;
    air_contamination(1) = initial_air_contamination;
    zpe_levels(1) = zpe_available;

    % Simulation loop
for t = 1:time_steps
    % Calculate energy needed
    energy_water = water_contamination(t) * energy_per_water_unit;
    energy_soil = soil_contamination(t) * energy_per_soil_unit;
    energy_air = air_contamination(t) * energy_per_air_unit;
    total_energy_needed = energy_water + energy_soil + energy_air;

    % Adjust based on available ZPE
    if zpe_available >= total_energy_needed
        zpe_available = zpe_available - total_energy_needed;
        water_contamination(t+1) = water_contamination(t) * (1 - water_efficiency);
        soil_contamination(t+1) = soil_contamination(t) * (1 - soil_efficiency);
        air_contamination(t+1) = air_contamination(t) * (1 - air_efficiency);
    else
        % Proportional purification
        energy_fraction = zpe_available / total_energy_needed;
        zpe_available = 0;
        water_contamination(t+1) = water_contamination(t) * (1 - water_efficiency * energy_fraction);
        soil_contamination(t+1) = soil_contamination(t) * (1 - soil_efficiency * energy_fraction);
        air_contamination(t+1) = air_contamination(t) * (1 - air_efficiency * energy_fraction);
    end
    zpe_levels(t+1) = zpe_available; % Update ZPE levels
end

    % Plot results
    clf(f); % Clear figure
    subplot(2, 1, 1, 'Parent', f);
    plot(0:time_steps, water_contamination, 'b', 'LineWidth', 2);
    hold on;
    plot(0:time_steps, soil_contamination, 'r', 'LineWidth', 2);
    plot(0:time_steps, air_contamination, 'g', 'LineWidth', 2);
    hold off;
    title('Contamination Levels Over Time');
    legend('Water', 'Soil', 'Air');
    xlabel('Time Steps');
    ylabel('Contamination Level');
    grid on;

    subplot(2, 1, 2, 'Parent', f);
    plot(0:time_steps, zpe_levels, 'k', 'LineWidth', 2);
    title('ZPE Levels Over Time');
    xlabel('Time Steps');
    ylabel('ZPE Available (Joules)');
    grid on;
    % After the simulation loop
    disp('ZPE Levels:');
    disp(zpe_levels);
    
    % Optional formatted output
    fprintf('Formatted ZPE Levels:\n');
    for i = 1:length(zpe_levels)
        fprintf('Time Step %d: %.2e Joules\n', i-1, zpe_levels(i));
    end
end