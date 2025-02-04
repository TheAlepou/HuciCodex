clc; clear; close all;

% Time Simulation (e.g., years of a person's life)
time_steps = 100; 
t = linspace(0, 100, time_steps); % From birth to 100 years

% Initial Parameters for Soul Components (0 to 1 Scale)
P = 0.5; % Personality
M = 0.6; % Moral Code
C = 0.7; % Consciousness
E = 0.2; % Memories (Starts low, grows over time)

% Weight Factors for Soul Components
w_P = 0.3; % How much Personality matters
w_M = 0.25; % How much Morality matters
w_C = 0.2; % How much Consciousness matters
w_E = 0.25; % How much Memories shape the soul

% Initialize Arrays for Growth Over Time
soul_evolution = zeros(1, time_steps);
memory_growth = zeros(1, time_steps);

% Soul Evolution Over Time
for i = 1:time_steps
    % Simulate Personality Stabilization
    P = 0.5 + 0.3 * tanh((i - 30) / 10); % Becomes stable around 30

    % Moral Code Grows & Stabilizes
    M = 0.3 + 0.3 * tanh((i - 40) / 15); % Strengthens with life experience

    % Consciousness remains stable but fluctuates slightly
    C = 0.7 + 0.05 * sin(i / 10); % Small variations in self-awareness

    % Memory Grows Over Time
    E = 1 - exp(-i / 20); % As time progresses, memory accumulates

    % Compute Total Soul Intensity
    S = w_P * P + w_M * M + w_C * C + w_E * E;
    soul_evolution(i) = S;
    memory_growth(i) = E;
end

% Plot the Results
figure;
hold on;
plot(t, soul_evolution, 'm-', 'LineWidth', 2);
plot(t, memory_growth, 'b--', 'LineWidth', 2);
xlabel('Age (Years)');
ylabel('Soul Intensity (0 to 1 Scale)');
title('Soul Evolution Over a Lifetime');
legend({'Total Soul Intensity', 'Memory Growth'}, 'Location', 'Best');
grid on;
hold off;