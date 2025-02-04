clc; clear; close all;

ages = 16:23; % Age range for simulation
crush_intensity = zeros(size(ages)); % Initialize empty array

for i = 1:length(ages)
    t = ages(i);
    
    % Hormone level based on age (from previous model)
    H = 0.7 + 0.2 * exp(-(t - 19)); 
    
    % Dopamine levels (higher in teens, lowers in adulthood)
    D = 1.2 - 0.05 * (t - 16); % Starts high at 16, decreases over time
    
    % Novelty factor (crush excitement fades over time)
    N = exp(-0.3 * (t - 16)); % Higher when younger, decays over time

    % Crush Intensity Equation
    C = H * D * N;
    crush_intensity(i) = C;
    
    fprintf('At age %d, Crush Intensity = %.2f\n', t, C);
end

% Plot the Crush Intensity Over Time
figure;
plot(ages, crush_intensity, 'r-o', 'LineWidth', 2);
xlabel('Age');
ylabel('Crush Intensity');
title('Crush Intensity Over Time');
grid on;