clc; clear; close all;

% Time Variables
time_steps = 120; % 100 years of life + 20 years post-death
t = linspace(0, 120, time_steps);

% Initial Values (Starting at Birth)
C = 0.1; % Consciousness Energy
I = 0.2; % Identity Energy
M = 0.3; % Moral Energy
E = 0.1; % Memory Energy

% Weight Factors (Each Component's Contribution to the Soul)
w_C = 0.25; w_I = 0.25; w_M = 0.25; w_E = 0.25;

% Soul Energy & Persistence Arrays
soul_energy = zeros(1, time_steps);
soul_persistence = zeros(1, time_steps);

% Transformation Factor (Change after death)
f_T = 0.8; % Assume soul energy slowly transforms after death

% Life & Death Simulation
for i = 1:time_steps
    if i <= 100  % Living state
        C = 0.1 + 0.6 * tanh((i - 30) / 20); % Consciousness stabilizes at adulthood
        I = 0.2 + 0.5 * tanh((i - 40) / 25); % Identity solidifies
        M = 0.3 + 0.4 * tanh((i - 50) / 30); % Moral Code develops
        E = 1 - exp(-i / 20); % Memory accumulates over time
    else  % Post-death phase (soul persistence)
        C = C * f_T;
        I = I * f_T;
        M = M * f_T;
        E = E * f_T;
    end

    % Compute Soul Energy
    S_E = w_C * C + w_I * I + w_M * M + w_E * E;
    soul_energy(i) = S_E;

    % Compute Soul Persistence (After Death)
    if i > 100
        soul_persistence(i) = S_E; % Soul transforms but doesn't vanish
    else
        soul_persistence(i) = NaN; % No persistence before death
    end
end

% Plot the Results
figure;
hold on;
plot(t, soul_energy, 'm-', 'LineWidth', 2);
plot(t, soul_persistence, 'k--', 'LineWidth', 2);
xlabel('Time (Years)');
ylabel('Soul Energy (0 to 1 Scale)');
title('Soul Energy Evolution Over Life and Death');
legend({'Soul Energy', 'Soul Persistence After Death'}, 'Location', 'Best');
grid on;
hold off;