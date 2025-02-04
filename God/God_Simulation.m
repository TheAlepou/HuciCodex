clc;
clear;
close all;

% Number of Universes in the Simulation
U = 100; % You can increase this to simulate more universes

% Probability of God's Existence in a Given Universe
P_G = 0.7; % Change this value between 0 and 1 to test different assumptions

% Defining Omnipresence and Necessity
O_G = 1; % 1 = God is everywhere in a universe, 0 = Localized presence
N_G = 1; % 1 = God exists in ALL universes, 0 = Variable existence

% Simulating Universes
universe = rand(1, U) < P_G; % Generates a 1 for existence, 0 for absence

% Check if God is Necessary (Exists in All Universes)
if sum(universe) == U
    disp('God is Necessary: Exists in all possible universes.');
else
    disp('God is Contingent: Does not exist in all possible universes.');
end

% Compute Omnipresence Score
omnipresence_score = sum(universe) / U;
disp(['Omnipresence Score: ', num2str(omnipresence_score)]);

% Visualizing the Simulation
figure;
bar(universe, 'FaceColor', 'flat');
colormap([0 0 1; 1 0 0]); % Blue for existence, Red for non-existence
caxis([0 1]);
xlabel('Universe Index');
ylabel('God Exists (1) or Not (0)');
title('God Simulation Across Universes');
grid on;

% Check if God is Necessary (Exists in All Universes)
if N_G == 1
    universe = ones(1, U); % Force God to exist in all universes
    disp('God is Necessary: Exists in all possible universes.');
else
    disp('God is Contingent: Does not exist in all possible universes.');
end

% Adding Labels for Explanation (Console Output)
if N_G == 1
    disp('Necessity: God exists in all possible universes.');
end
if O_G == 1
    disp('Omnipresence: God exists at every point in a universe.');
end