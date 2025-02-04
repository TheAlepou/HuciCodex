clc; clear; close all;

% Time Variables
time_steps = 50; % Simulation runs for 50 time units
t = linspace(0, 10, time_steps); % Time axis (e.g., months or years)

% Love Type Initial Values (0 to 1 Scale)
E = 0.7;  % Emotional Love (trust, deep bonds)
I = 0.5;  % Intellectual Love (fascination, shared ideas)
P = 0.6;  % Physical Attraction (romance, desire)
S = 0.8;  % Soul Connection (understanding their true essence)

% Weight Factors (Adjust These to Simulate Different Relationship Types)
w_E = 0.3; % How much Emotional Love matters
w_I = 0.3; % How much Intellectual Love matters
w_P = 0.2; % How much Physical Love matters
w_S = 0.4; % How much Soul Love matters

% Initialize Arrays for Love Values Over Time
L_emotional = zeros(1, time_steps);
L_intellectual = zeros(1, time_steps);
L_physical = zeros(1, time_steps);
L_soul = zeros(1, time_steps);
L_total = zeros(1, time_steps);

% Love Evolution Simulation
for i = 1:time_steps
    % Simulating Love Dynamics (Love Grows or Fades)
    L_emotional(i) = E * (1 - 0.02 * i); % Emotional stabilizes over time
    L_intellectual(i) = I * (1 + 0.01 * i); % Intellectual love can grow
    L_physical(i) = P * exp(-0.03 * i); % Physical attraction fades slightly
    L_soul(i) = S * (1 + 0.005 * i); % Soul Love deepens

    % Total Love Intensity
    L_total(i) = w_E * L_emotional(i) + w_I * L_intellectual(i) + w_P * L_physical(i) + w_S * L_soul(i);
end

% Plot Results
figure;
hold on;
plot(t, L_emotional, 'r-', 'LineWidth', 2);
plot(t, L_intellectual, 'b-', 'LineWidth', 2);
plot(t, L_physical, 'g-', 'LineWidth', 2);
plot(t, L_soul, 'm-', 'LineWidth', 2);
plot(t, L_total, 'k--', 'LineWidth', 3);
xlabel('Time');
ylabel('Love Intensity (0 to 1 Scale)');
title('Grand Unified Love Simulation Over Time');
legend({'Emotional Love', 'Intellectual Love', 'Physical Attraction', 'Soul Connection', 'Total Love'}, 'Location', 'Best');
grid on;
hold off;