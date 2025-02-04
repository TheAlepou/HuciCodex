clc;
clear;
close all;

% Parameters
k = 10; % Scaling factor for love
T = linspace(0, 10, 100); % Time in years
S = 5; % Shared experiences
A = 0.8; % Mutual affection (scale of 0 to 1)

t = 19:1:23; % Age range from 19 to 23

H = 0.7 + 0.2 * exp(-(t - 19)); % Hormonal intensity equation
D = 2; % External factors (stress, distance, etc.)
Stress = 1;
alpha = 0.3; % Growth rate of love over time

for t = 19:23  % Simulate age 19 to 23
    H = 0.7 + 0.2 * exp(-(t - 19)); % Update hormone level over time
    fprintf('At age %d, Hormone intensity = %.2f\n', t, H);
end

P = H * 100; % Convert to percentage
fprintf('Love probability at age %d is %.2f%%\n', t, P);

% Love Equation
L = k * ((S + A + H) ./ (Stress + D + 1)) .* exp(alpha * T);

% Plot Love Over Time
figure;
plot(T, L, 'r', 'LineWidth', 2);
xlabel('Time (Years)');
ylabel('Love Intensity');
title('Mathematical Model of Love');
grid on;
legend('Love Growth Curve');