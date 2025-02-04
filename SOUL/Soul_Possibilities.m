clc; clear; close all;

% Energy Constants
E_brain_per_year = 6.2e8; % Energy used by the brain per year (Joules)
E_life = E_brain_per_year * 100; % Total energy over 100 years
soul_energy = E_life; % Assume the soul starts with full energy

% Decay/Transformation Factors
f_decay = 0.99;  % Standard decay (99% remains each year after death)
f_reincarnation = 0.75; % Percentage of energy transferred in reincarnation
f_zpe_recharge = 1.02;  % 2% energy gain per year (Zero-Point Energy Model)
f_eternal = 1.00;  % Eternal Soul Model (No energy loss)

% Time Variables
time_steps = 300; % 100 years of life + 200 years post-death
t = linspace(0, 300, time_steps);

% Energy Tracking Arrays
soul_standard = zeros(1, time_steps);
soul_reincarnation = zeros(1, time_steps);
soul_zpe = zeros(1, time_steps);
soul_eternal = zeros(1, time_steps);

% Simulation Loop
for i = 1:time_steps
    if i <= 100  % During life
        soul_standard(i) = soul_energy;
        soul_reincarnation(i) = soul_energy;
        soul_zpe(i) = soul_energy;
        soul_eternal(i) = soul_energy;
    else  % After death
        % Standard Decay
        soul_standard(i) = soul_standard(i-1) * f_decay;
        
        % Reincarnation (Every 100 years, part of energy transfers)
        if mod(i, 100) == 0
            soul_reincarnation(i) = soul_reincarnation(i-1) * f_reincarnation;
        else
            soul_reincarnation(i) = soul_reincarnation(i-1) * f_decay;
        end
        
        % Zero-Point Energy Recharge
        soul_zpe(i) = soul_zpe(i-1) * f_zpe_recharge;
        
        % Eternal Soul Model (No loss)
        soul_eternal(i) = soul_eternal(i-1) * f_eternal;
    end
end

% Plot the Results
figure;
hold on;
plot(t, soul_standard, 'r-', 'LineWidth', 2);
plot(t, soul_reincarnation, 'b--', 'LineWidth', 2);
plot(t, soul_zpe, 'g-.', 'LineWidth', 2);
plot(t, soul_eternal, 'k:', 'LineWidth', 2);
xlabel('Time (Years)');
ylabel('Soul Energy (Joules)');
title('Soul Energy Evolution Over Life and Death');
legend({'Standard Decay', 'Reincarnation Model', 'Zero-Point Energy Recharge', 'Eternal Soul Model'}, 'Location', 'Best');
grid on;
hold off;