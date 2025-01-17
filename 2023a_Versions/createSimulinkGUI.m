function createSimulinkGUI()
% Create the main figure with a larger size
fig = uifigure('Name', 'Simulink Simulation GUI', 'Position', [100, 100, 1600, 900]);

% Create axes to display the image and superimpose dots
imgAxes = uiaxes(fig, 'Position', [1000, 450, 550, 300]);
img = imread('Samuno_Side_Profile.png'); % Replace with your image file
imshow(img, 'Parent', imgAxes);
hold(imgAxes, 'on');

% Get image dimensions
imgWidth = size(img, 2);
imgHeight = size(img, 1);

runInitParts();

% Create a button to browse and load joint positions
browseButton = uibutton(fig, 'Position', [20, 750, 150, 30], 'Text', 'Get Joint Positions', ...
    'ButtonPushedFcn', @(btn, event) loadMatFile(), ...
    'BackgroundColor', 'yellow', 'FontWeight', 'bold');

% Create a button to reset to default settings
resetButton = uibutton(fig, 'Position', [180, 750, 150, 30], 'Text', 'Reset to Default Settings', ...
    'ButtonPushedFcn', @(btn, event) runInitParts());

% Create sliders and numeric edit fields for X and Y position of the magenta dot (Center of Mass)
comXLabel = uilabel(fig, 'Position', [20, 700, 150, 30], 'Text', 'COM X Position:');
comXLabel.BackgroundColor = 'cyan';
xSliderCOM = uislider(fig, 'Position', [180, 715, 300, 3], 'Limits', [-0.6, 0], 'Value', 0, ...
    'ValueChangedFcn', @(sld, event) updateSliderValue(sld));
xEditCOM = uieditfield(fig, 'numeric', 'Position', [490, 705, 60, 30], 'Limits', [-0.6, 0], 'Value', 0, ...
    'ValueChangedFcn', @(edt, event) updateSlider(xSliderCOM, edt.Value));

comZLabel = uilabel(fig, 'Position', [20, 650, 150, 30], 'Text', 'COM Z Position:');
comZLabel.BackgroundColor = 'cyan';
ySliderCOM = uislider(fig, 'Position', [180, 665, 300, 3], 'Limits', [-0.12, 0.12], 'Value', 0, ...
    'ValueChangedFcn', @(sld, event) updateSliderValue(sld));
yEditCOM = uieditfield(fig, 'numeric', 'Position', [490, 655, 60, 30], 'Limits', [-0.12, 0.12], 'Value', 0, ...
    'ValueChangedFcn', @(edt, event) updateSlider(ySliderCOM, edt.Value));

% Create sliders and numeric edit fields for X and Y position of the cyan dot (Center of Buoyancy)
cobXLabel = uilabel(fig, 'Position', [20, 600, 150, 30], 'Text', 'COB X Offset:');
cobXLabel.BackgroundColor = 'magenta';
xSliderCOB = uislider(fig, 'Position', [180, 615, 300, 3], 'Limits', [-0.5, 0.5], 'Value', 0, ...
    'ValueChangedFcn', @(sld, event) updateSliderValue(sld));
xEditCOB = uieditfield(fig, 'numeric', 'Position', [490, 605, 60, 30], 'Limits', [-0.5, 0.5], 'Value', 0, ...
    'ValueChangedFcn', @(edt, event) updateSlider(xSliderCOB, edt.Value));

cobZLabel = uilabel(fig, 'Position', [20, 550, 150, 30], 'Text', 'COB Z Offset:');
cobZLabel.BackgroundColor = 'magenta';
ySliderCOB = uislider(fig, 'Position', [180, 565, 300, 3], 'Limits', [-0.5, 0.5], 'Value', 0, ...
    'ValueChangedFcn', @(sld, event) updateSliderValue(sld));
yEditCOB = uieditfield(fig, 'numeric', 'Position', [490, 555, 60, 30], 'Limits', [-0.5, 0.5], 'Value', 0, ...
    'ValueChangedFcn', @(edt, event) updateSlider(ySliderCOB, edt.Value));

% Plot the initial magenta and cyan dots at zero positions
magentaDot = plot(imgAxes, imgWidth, imgHeight / 2, 'm.', 'MarkerSize', 20); % Initial position at far right and center
cyanDot = plot(imgAxes, imgWidth, imgHeight / 2, 'c.', 'MarkerSize', 20); % Initial position at far right and center

% Create text entry fields for Total Mass, Initial Velocity, and Duration
uilabel(fig, 'Position', [20, 500, 150, 30], 'Text', 'Total Mass:');
massField = uieditfield(fig, 'numeric', 'Position', [180, 505, 100, 30]);

uilabel(fig, 'Position', [20, 450, 150, 30], 'Text', 'Initial Velocity:');
velocityField = uieditfield(fig, 'numeric', 'Position', [180, 455, 100, 30]);

uilabel(fig, 'Position', [20, 400, 150, 30], 'Text', 'Simulation Duration:');
durationField = uieditfield(fig, 'numeric', 'Position', [180, 405, 100, 30]);

% Create a button to start the simulation
runButton = uibutton(fig, 'Position', [20, 350, 150, 30], 'Text', 'Start Simulation', ...
    'ButtonPushedFcn', @(btn, event) runSimulation(), ...
    'BackgroundColor', 'green', 'FontWeight', 'bold');

% Create a text box and button for recording trial data
uilabel(fig, 'Position', [1230, 820, 150, 30], 'Text', 'File Name:');
fileNameField = uieditfield(fig, 'text', 'Position', [1230, 785, 150, 30]);
fileNameField.Value='Test';
saveButton = uibutton(fig, 'Position', [1230, 750, 150, 30], 'Text', 'Record Trial Data', ...
    'ButtonPushedFcn', @(btn, event) saveTrialData(fileNameField.Value));

% Create axes for the Px vs Py plot
posPlotAxes = uiaxes(fig, 'Position', [20, 50, 600, 250]);
title(posPlotAxes, 'Position (Px vs Py)');
xlabel(posPlotAxes, 'Px');
ylabel(posPlotAxes, 'Py');

% Create axes for the velocity subplots
velPlotPanel = uipanel(fig, 'Position', [650, 50, 900, 400], 'Title', 'Velocity (Vx and Vy)');

topVelAxes = uiaxes(velPlotPanel, 'Position', [50, 200, 800, 130]);
title(topVelAxes, 'Vx vs Time');
xlabel(topVelAxes, 'Time');
ylabel(topVelAxes, 'Vx');

bottomVelAxes = uiaxes(velPlotPanel, 'Position', [50, 10, 800, 130]);
title(bottomVelAxes, 'Vy vs Time');
xlabel(bottomVelAxes, 'Time');
ylabel(bottomVelAxes, 'Vy');

runInitParts()

    function loadMatFile()
        % Open file browser to select a .mat file
        [file, path] = uigetfile('*.mat', 'Select a MAT-file');
        if isequal(file, 0)
            disp('User selected Cancel');
        else
            % Load the .mat file
            matData = load(fullfile(path, file));
            assignin('base', 'matData', matData)
            disp(['User selected ', fullfile(path, file)]);
        end
    end

    function runInitParts()
        % Run the initialization script in the base workspace
        evalin('base', 'run(''init_parts.m'')');

        % Retrieve initialized values from the base workspace
        xCOM = evalin('base', 'xCOM');
        zCOM = evalin('base', 'zCOM');
        xCOB = evalin('base', 'xCOB');
        zCOB = evalin('base', 'zCOB');
        mass = evalin('base', 'TotalMass');
        velocity = evalin('base', 'init_vel');
        duration = evalin('base', 'duration');

        % Update the sliders and edit fields with the default values
        xSliderCOM.Value = xCOM;
        ySliderCOM.Value = zCOM;
        xSliderCOB.Value = xCOB;
        ySliderCOB.Value = zCOB;

        xEditCOM.Value = xCOM;
        yEditCOM.Value = zCOM;
        xEditCOB.Value = xCOB;
        yEditCOB.Value = zCOB;

        massField.Value = mass;
        velocityField.Value = velocity;
        durationField.Value = duration;

        % Update the position of the dots on the image
        updateDot();
    end

    function updateDot()
        % Update the position of the magenta dot (COM)
        magentaDot.XData = imgWidth * (1 + xSliderCOM.Value / 0.6);
        magentaDot.YData = imgHeight / 2 * (1 + -ySliderCOM.Value / 0.12);
        xEditCOM.Value = xSliderCOM.Value;
        yEditCOM.Value = ySliderCOM.Value;

        % Update the position of the cyan dot (COB)
        cyanDot.XData = magentaDot.XData + xSliderCOB.Value * imgWidth;
        cyanDot.YData = magentaDot.YData + -ySliderCOB.Value * imgHeight / 2;
        xEditCOB.Value = xSliderCOB.Value;
        yEditCOB.Value = ySliderCOB.Value;
    end

% Function to round the slider value to the nearest 0.01 and update the slider
    function updateSliderValue(sld)
        roundedValue = round(sld.Value, 2);
        sld.Value = roundedValue;
        % Update the corresponding edit field value
        if sld == xSliderCOM
            xEditCOM.Value = roundedValue;
        elseif sld == ySliderCOM
            yEditCOM.Value = roundedValue;
        elseif sld == xSliderCOB
            xEditCOB.Value = roundedValue;
        elseif sld == ySliderCOB
            yEditCOB.Value = roundedValue;
        end
        updateDot();
    end

% Function to update the slider position based on the edit field value
    function updateSlider(slider, value)
        roundedValue = round(value, 2);
        slider.Value = roundedValue;
        updateDot();
    end

    function runSimulation()
        % Load the Simulink model
        matData = evalin('base', 'matData');
        modelName = 'Samuno_Experimental'; % Replace with your model name
        load_system(modelName);
        Caudal_Driver = matData.Drivers.Caudal_Driver;
        Anal_Driver = matData.Drivers.Anal_Driver;
        Dorsal_Driver = matData.Drivers.Dorsal_Driver;
        Ped_Driver = matData.Drivers.Ped_Driver;
        Mid_Driver = matData.Drivers.Mid_Driver;
        mass = massField.Value;
        velocity = velocityField.Value;
        duration = durationField.Value;
        xCOM = xSliderCOM.Value;
        zCOM = ySliderCOM.Value;
        xCOB = xSliderCOB.Value;
        zCOB = ySliderCOB.Value;

        % Set the parameter values in the Simulink model
        Nose = evalin('base', 'Nose');
        com_original = Nose.CoM;
        Nose.CoM = [xCOM, zCOM, 0];

        I_new = recalculateMoI(Nose.MoI, mass, com_original, Nose.CoM);
        Nose.MoI = I_new;

        assignin('base', 'Caudal_Driver', Caudal_Driver);
        assignin('base', 'Anal_Driver', Anal_Driver);
        assignin('base', 'Dorsal_Driver', Dorsal_Driver);
        assignin('base', 'Ped_Driver', Ped_Driver);
        assignin('base', 'Mid_Driver', Mid_Driver);
        assignin('base', 'TotalMass', mass);
        assignin('base', 'Nose', Nose);
        assignin('base', 'Starting_Velocity', velocity);
        assignin('base', 'Dur', duration);
        assignin('base', 'COB_X', xCOB);
        assignin('base', 'COB_Y', zCOB);
        

        % Run the simulation
        set_param(modelName, 'SimMechanicsOpenEditorOnUpdate', 'on');
        simOut = sim(modelName, 'SimulationMode', 'normal');
        assignin('base', 'simOut', simOut);
        % Retrieve and plot data
        % Extracting time, px, and py from the simulation output
        time = simOut.simout.px.Time;
        px = squeeze(simOut.simout.px.Data);
        py = squeeze(simOut.simout.py.Data);

        % Differentiating to get velocities
        Vx = [diff(px) / mean(diff(time)); 0];  % Use finite difference
        Vy = [diff(py) / mean(diff(time)); 0];  % Use finite difference

        % Plot Px vs Py
        plot(posPlotAxes, px, py, 'b');
        xlabel(posPlotAxes, 'Px');
        ylabel(posPlotAxes, 'Py');

        % Plot Vx vs Time in the top subplot
        plot(topVelAxes, time, Vx, 'r');
        xlabel(topVelAxes, 'Time');
        ylabel(topVelAxes, 'Vx');

        % Plot Vy vs Time in the bottom subplot
        plot(bottomVelAxes, time, Vy, 'g');
        xlabel(bottomVelAxes, 'Time');
        ylabel(bottomVelAxes, 'Vy');

    end

    function saveTrialData(fileName)
        out = evalin('base', 'out');

        if ~exist('out', 'var')
            uialert(fig, 'No simulation run yet', 'Error');
            return;
        end

        % Create directory if it doesn't exist
        outputDir = fullfile('Simulation_Outputs', ['sim_out_' datestr(now, 'yyyy_mm_dd')]);
        if ~exist(outputDir, 'dir')
            mkdir(outputDir);
        end

        % Check if the file exists and increment if necessary
        fullPath = fullfile(outputDir, [fileName '.mat']);
        counter = 1;
        while exist(fullPath, 'file')
            fullPath = fullfile(outputDir, [fileName '_' num2str(counter, '%03d') '.mat']);
            counter = counter + 1;
        end

        % Save the data
        save(fullPath, 'out');
        disp(['Data saved to ' fullPath]);
    end
end
