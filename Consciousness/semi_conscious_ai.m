
% Semi-Conscious AI Simulation in MATLAB
% -------------------------------------
% This simulation includes memory, decision-making, adaptive behavior, and communication.

clc; clear; close all;

%% Initialize Parameters
numIterations = 100;  % Number of interactions
memorySize = 10;      % How many past events it remembers
mood = 0;             % Mood (-1 = negative, 0 = neutral, 1 = positive)
learningRate = 0.1;   % How much past experiences influence future decisions

% Memory of past interactions
memory = zeros(memorySize, 2); % Stores [User Input, AI Response]

%% Interaction Loop
for iter = 1:numIterations
    % Generate User Input (Simulated Random Events)
    userInput = randi([-1, 1]); % -1 (negative), 0 (neutral), 1 (positive)
    
    % AI Decision Process
    if mood > 0.5
        aiResponse = 1;  % AI responds positively
    elseif mood < -0.5
        aiResponse = -1; % AI responds negatively
    else
        aiResponse = randi([-1, 1]); % Neutral or random response
    end
    
    % Update Memory
    memory = circshift(memory, 1, 1); % Shift memory (oldest events forgotten)
    memory(1, :) = [userInput, aiResponse]; % Store latest interaction
    
    % Update Mood based on memory
    mood = mood + learningRate * sum(memory(:, 2)) / memorySize;
    mood(iter) = mood(max(iter-1,1)) + some_change; % Ensure it stores values each iteration % Keep mood in range [-1, 1]
    
    % Display Interaction
    fprintf('Iteration %d: User Input = %d | AI Response = %d | Mood = %.2f\n', ...
        iter, userInput, aiResponse, mood);
end

disp(size(memory));
disp(size(mood));

%% Plot Results
figure;
subplot(2,1,1);
plot(1:numIterations, mood(1:numIterations), 'r', 'LineWidth', 2);
title('AI Mood Over Time');
xlabel('Iteration');
ylabel('Mood Level');
grid on;

subplot(2,1,2);
plot(1:size(memory,1), sum(memory(:,1:end),2), 'b', 'LineWidth', 2);
title('Cumulative Learning Over Time');
xlabel('Agent ID');
ylabel('Memory Influence');
grid on;