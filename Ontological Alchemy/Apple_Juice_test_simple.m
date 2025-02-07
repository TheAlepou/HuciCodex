clc; clear; close all;

% Define apple's molecular composition (approximate atomic counts)
atoms_apple = struct('H', 200000, 'C', 120000, 'O', 150000); % Example values

% Define apple juice composition (same atoms, different form)
atoms_juice = struct('H', atoms_apple.H, ...
                     'C', atoms_apple.C - 20000, ... % Removing fiber
                     'O', atoms_apple.O);

% Check if transformation is valid
atoms_apple_values = cell2mat(struct2cell(atoms_apple));
atoms_juice_values = cell2mat(struct2cell(atoms_juice));

if sum(atoms_apple_values) == sum(atoms_juice_values)
    disp('The apple and the juice contain the same atomic mass.');
else
    disp('Transmutation failed: Mass mismatch.');
end

disp(sum(cell2mat(struct2cell(atoms_apple)))); % Check total mass of apple
disp(sum(cell2mat(struct2cell(atoms_juice)))); % Check total mass of juice

% Calculate mass difference
mass_difference = sum(cell2mat(struct2cell(atoms_apple))) - sum(cell2mat(struct2cell(atoms_juice)));

% Display detailed information
if mass_difference == 0
    disp('The apple and the juice contain the same atomic mass.');
else
    disp(['Transmutation failed: Mass mismatch of ', num2str(mass_difference), ' atomic units.']);
end

% Compare each atom type
atom_types = fieldnames(atoms_apple);
for i = 1:length(atom_types)
    atom_type = atom_types{i};
    apple_atoms = atoms_apple.(atom_type);
    juice_atoms = atoms_juice.(atom_type);
    
    if apple_atoms ~= juice_atoms
        disp(['Mismatch in ', atom_type, ': Apple has ', num2str(apple_atoms), ...
              ', Juice has ', num2str(juice_atoms), ...
              '. Difference: ', num2str(apple_atoms - juice_atoms)]);
    end
end

% Dynamically balance atomic composition
while sum(cell2mat(struct2cell(atoms_juice))) < sum(cell2mat(struct2cell(atoms_apple)))
    atoms_juice.H = atoms_juice.H + 100; % Incrementally add hydrogen atoms
    disp(['Adding hydrogen: Current mass = ', num2str(sum(cell2mat(struct2cell(atoms_juice))))]);
end

% Simulate random decay
decay_factor = randi([0, 5000]); % Randomly lose 0 to 5000 atomic units
atoms_juice.C = atoms_apple.C - decay_factor; % Simulate carbon loss
disp(['Random decay factor: ', num2str(decay_factor)]);

% Visualize atomic compositions
figure;
atom_names = fieldnames(atoms_apple);
apple_values = cell2mat(struct2cell(atoms_apple));
juice_values = cell2mat(struct2cell(atoms_juice));

% Apply random decay to each atom type
for i = 1:length(atom_names)
    decay = randi([0, 5000]); % Random decay for each atom type
    atoms_juice.(atom_names{i}) = atoms_juice.(atom_names{i}) - decay;
    disp(['Decay in ', atom_names{i}, ': ', num2str(decay)]);
end

% Adjust legend to match data
bar([apple_values; juice_values]', 'grouped');
set(gca, 'xticklabel', atom_names);
legend('Apple', 'Juice'); % Ensure only two entries for two data series
xlabel('Atom Type');
ylabel('Atomic Count');
title('Atomic Composition: Apple vs Juice');

figure;
hold on;
masses = []; % To store mass differences
for i = 1:100
    % Simulate transmutation adjustments
    decay = randi([0, 500]); % Example decay value
    atoms_juice.H = atoms_juice.H - decay; 
    current_mass = sum(cell2mat(struct2cell(atoms_juice)));
    masses = [masses, current_mass];
    plot(1:length(masses), masses, 'b-');
    pause(0.1); % Simulate real-time update
end
xlabel('Iteration');
ylabel('Mass');
title('Dynamic Transmutation Adjustment');

% Final Summary
if sum(cell2mat(struct2cell(atoms_juice))) == sum(cell2mat(struct2cell(atoms_apple)))
    disp('Final transmutation successful: Masses match.');
else
    disp('Final transmutation failed: Mass mismatch remains.');
end