function createSimulinkGUI_2024b()

open("createSimulinkGUI_2024b.m")
% Create the main figure
fig = uifigure('Name', 'Simulink Simulation GUI', ...
    'Position', [100, 100, 1600, 900]);

%------------------ PANEL 1: SIMULATION CONTROL ------------------%
simControlPanel = uipanel(fig, ...
    'Title', 'Simulation Control', ...
    'Position', [20, 650, 600, 220]);

% "Get Joint Positions" button
browseButton = uibutton(simControlPanel, ...
    'Position', [20, 150, 150, 30], ...
    'Text', 'Load Joint Trajectories', ...
    'ButtonPushedFcn', @(btn, event) loadMatFile(), ...
    'BackgroundColor', 'yellow', ...
    'FontWeight', 'bold');

% "Reset to Default" button
resetButton = uibutton(simControlPanel, ...
    'Position', [200, 150, 150, 30], ...
    'Text', 'Reset to Default', ...
    'ButtonPushedFcn', @(btn, event) runInitParts());

% "Start Simulation" button
runButton = uibutton(simControlPanel, ...
    'Position', [100, 30, 200, 100], ...
    'Text', 'Start Simulation', ...
    'ButtonPushedFcn', @(btn, event) runSimulation(), ...
    'BackgroundColor', 'green', ...
    'FontWeight', 'bold');

% File name label & text field
uilabel(simControlPanel, ...
    'Text', 'File Name:', ...
    'Position', [370, 30, 100, 25]);
fileNameField = uieditfield(simControlPanel, ...
    'text', ...
    'Position', [430, 30, 120, 30], ...
    'Value', 'Test');

% "Record Trial Data" button
saveButton = uibutton(simControlPanel, ...
    'Position', [400, 75, 150, 30], ...
    'Text', 'Record Trial Data', ...
    'ButtonPushedFcn', @(btn, event) saveTrialData(fileNameField.Value),...
    'BackgroundColor', [254,196,79]/255);

%------------------ PANEL 2: MODEL PARAMETERS ------------------%
modelParamPanel = uipanel(fig, ...
    'Title', 'Model Parameters', ...
    'Position', [20, 350, 600, 275]);

%--- COM X Position ---
comXLabel = uilabel(modelParamPanel, ...
    'Position', [20, 210, 150, 30], ...
    'Text', 'COM X Position:', ...
    'BackgroundColor', 'cyan');
xSliderCOM = uislider(modelParamPanel, ...
    'Position', [180, 225, 300, 3], ...
    'Limits', [-0.6, 0], ...
    'Value', 0, ...
    'ValueChangedFcn', @(sld, event) updateSliderValue(sld));
xEditCOM = uieditfield(modelParamPanel, 'numeric', ...
    'Position', [490, 215, 60, 30], ...
    'Limits', [-0.6, 0], ...
    'Value', 0, ...
    'ValueChangedFcn', @(edt, event) updateSlider(xSliderCOM, edt.Value));

%--- COM Z Position ---
comZLabel = uilabel(modelParamPanel, ...
    'Position', [20, 160, 150, 30], ...
    'Text', 'COM Z Position:', ...
    'BackgroundColor', 'cyan');
ySliderCOM = uislider(modelParamPanel, ...
    'Position', [180, 175, 300, 3], ...
    'Limits', [-0.12, 0.12], ...
    'Value', 0, ...
    'ValueChangedFcn', @(sld, event) updateSliderValue(sld));
yEditCOM = uieditfield(modelParamPanel, 'numeric', ...
    'Position', [490, 165, 60, 30], ...
    'Limits', [-0.12, 0.12], ...
    'Value', 0, ...
    'ValueChangedFcn', @(edt, event) updateSlider(ySliderCOM, edt.Value));

%--- COB X Offset ---
cobXLabel = uilabel(modelParamPanel, ...
    'Position', [20, 110, 150, 30], ...
    'Text', 'COB X Offset:', ...
    'BackgroundColor', 'magenta');
xSliderCOB = uislider(modelParamPanel, ...
    'Position', [180, 125, 300, 3], ...
    'Limits', [-0.5, 0.5], ...
    'Value', 0, ...
    'ValueChangedFcn', @(sld, event) updateSliderValue(sld));
xEditCOB = uieditfield(modelParamPanel, 'numeric', ...
    'Position', [490, 115, 60, 30], ...
    'Limits', [-0.5, 0.5], ...
    'Value', 0, ...
    'ValueChangedFcn', @(edt, event) updateSlider(xSliderCOB, edt.Value));

%--- COB Z Offset ---
cobZLabel = uilabel(modelParamPanel, ...
    'Position', [20, 60, 150, 30], ...
    'Text', 'COB Z Offset:', ...
    'BackgroundColor', 'magenta');
ySliderCOB = uislider(modelParamPanel, ...
    'Position', [180, 75, 300, 3], ...
    'Limits', [-0.5, 0.5], ...
    'Value', 0, ...
    'ValueChangedFcn', @(sld, event) updateSliderValue(sld));
yEditCOB = uieditfield(modelParamPanel, 'numeric', ...
    'Position', [490, 65, 60, 30], ...
    'Limits', [-0.5, 0.5], ...
    'Value', 0, ...
    'ValueChangedFcn', @(edt, event) updateSlider(ySliderCOB, edt.Value));


uilabel(modelParamPanel, ...
    'Position', [220, 5, 100, 30], ...
    'Text', 'Initial Velocity:');
velocityField = uieditfield(modelParamPanel, 'numeric', ...
    'Position', [320, 5, 80, 30]);

uilabel(modelParamPanel, ...
    'Position', [420, 5, 120, 30], ...
    'Text', 'Sim Duration:');
durationField = uieditfield(modelParamPanel, 'numeric', ...
    'Position', [520, 5, 60, 30]);

%------------------ PANEL 3: MODEL IMAGE ------------------%
imagePanel = uipanel(fig, ...
    'Title', 'Model Image', ...
    'Position', [650, 450, 900, 420]);

imgAxes = uiaxes(imagePanel, ...
    'Position', [20, 60, 850, 330]);
% Hide ticks if you prefer a cleaner look
imgAxes.XTick = [];
imgAxes.YTick = [];
imgAxes.Box = 'off';

% Load & show the image
img = imread('Samuno_Side_Profile.png'); % Your image here
imshow(img, 'Parent', imgAxes);
hold(imgAxes, 'on');

% For plotting the magenta & cyan dots
imgWidth = size(img, 2);
imgHeight = size(img, 1);
magentaDot = plot(imgAxes, imgWidth, imgHeight/2, 'm.', 'MarkerSize', 20);
cyanDot    = plot(imgAxes, imgWidth, imgHeight/2, 'c.', 'MarkerSize', 20);

%------------------ PANEL 4: RESULTS (PLOTS) ------------------%
resultPanel = uipanel(fig, ...
    'Title', 'Results', ...
    'Position', [650, 20, 900, 400]);

% Position (Px vs Py) subplot
posPlotAxes = uiaxes(resultPanel, ...
    'Position', [20, 220, 400, 150]);
title(posPlotAxes, 'Position (Px vs Py)');
xlabel(posPlotAxes, 'Px');
ylabel(posPlotAxes, 'Py');

% Velocity subplots
topVelAxes = uiaxes(resultPanel, ...
    'Position', [450, 220, 400, 150]);
title(topVelAxes, 'Vx vs Time');
xlabel(topVelAxes, 'Time');
ylabel(topVelAxes, 'Vx');

bottomVelAxes = uiaxes(resultPanel, ...
    'Position', [450, 40, 400, 150]);
title(bottomVelAxes, 'Vy vs Time');
xlabel(bottomVelAxes, 'Time');
ylabel(bottomVelAxes, 'Vy');

%------------------ INITIALIZE VALUES ------------------%
runInitParts();

%======== Nested Callback Functions ========%

    function loadMatFile()
        % Open file browser to select a .mat file
        [file, path] = uigetfile('*.mat', 'Select a MAT-file');
        if isequal(file, 0)
            disp('User selected Cancel');
        else
            % Load the .mat file into base workspace
            matData = load(fullfile(path, file));
            assignin('base', 'matData', matData)
            disp(['User selected ', fullfile(path, file)]);
        end
    end

    function runInitParts()
        % Run the initialization script in the base workspace
        evalin('base', 'run(''init_parts.m'')');

        % Retrieve initialized values from the base workspace
        xCOM     = evalin('base', 'xCOM');
        zCOM     = evalin('base', 'zCOM');
        xCOB     = evalin('base', 'xCOB');
        zCOB     = evalin('base', 'zCOB');
        massVal  = evalin('base', 'TotalMass');
        velVal   = evalin('base', 'init_vel');
        durVal   = evalin('base', 'duration');

        % Update sliders/fields
        xSliderCOM.Value = xCOM;       xEditCOM.Value = xCOM;
        ySliderCOM.Value = zCOM;       yEditCOM.Value = zCOM;
        xSliderCOB.Value = xCOB;       xEditCOB.Value = xCOB;
        ySliderCOB.Value = zCOB;       yEditCOB.Value = zCOB;

        massField.Value     = massVal;
        velocityField.Value = velVal;
        durationField.Value = durVal;

        % Update dot positions
        updateDot();
    end

    function updateDot()
        % Update the position of the magenta dot (COM)
        % Scale x from [-0.6..0] => move from right to left
        magentaDot.XData = imgWidth * (1 + xSliderCOM.Value / 0.6);
        % Scale y from [-0.12..0.12] => invert sign for image coords
        magentaDot.YData = imgHeight/2 * (1 - ySliderCOM.Value/0.12);

        % Keep numeric fields in sync
        xEditCOM.Value = xSliderCOM.Value;
        yEditCOM.Value = ySliderCOM.Value;

        % Update position of the cyan dot (COB)
        cyanDot.XData = magentaDot.XData + xSliderCOB.Value * imgWidth;
        cyanDot.YData = magentaDot.YData - ySliderCOB.Value * (imgHeight/2);

        xEditCOB.Value = xSliderCOB.Value;
        yEditCOB.Value = ySliderCOB.Value;
    end

    function updateSliderValue(sld)
        % Round the slider value to the nearest 0.01
        roundedValue = round(sld.Value, 2);
        sld.Value = roundedValue;

        % Update the corresponding edit field
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

    function updateSlider(slider, value)
        % Called when numeric edit field changes
        roundedValue = round(value, 2);
        slider.Value = roundedValue;
        updateDot();
    end

    function runSimulation()
        % Load model and necessary data
        try
            matData = evalin('base', 'matData');
        catch
            error('Error: No Joint Drives Uploaded');
        end

        modelName = 'Samuno_Experimental_2024b';  % Your Simulink model

        load_system(modelName);

        % Assign driver data from matData
        Caudal_Driver = matData.Drivers.Caudal_Driver;
        Anal_Driver   = matData.Drivers.Anal_Driver;
        Dorsal_Driver = matData.Drivers.Dorsal_Driver;
        Ped_Driver    = matData.Drivers.Ped_Driver;
        Mid_Driver    = matData.Drivers.Mid_Driver;
        Pect_LA       = matData.Drivers.Pect_LA_Driver;
        Pect_LB       = matData.Drivers.Pect_LB_Driver;
        Pect_RA       = matData.Drivers.Pect_RA_Driver;
        Pect_RB       = matData.Drivers.Pect_RB_Driver;


        velocity = velocityField.Value;
        duration = durationField.Value;
        xCOM     = xSliderCOM.Value;
        zCOM     = ySliderCOM.Value;
        xCOB     = xSliderCOB.Value;
        zCOB     = ySliderCOB.Value;

        % Example to recalc inertia, etc.
        Nose          = evalin('base', 'Nose');
        com_original  = Nose.CoM;
        Nose.CoM      = [xCOM, zCOM, 0];
        I_new         = recalculateMoI(Nose.MoI, Nose.Mass, com_original, Nose.CoM);
        Nose.MoI      = I_new;

        % Send these back to base
        assignin('base', 'Caudal_Driver', Caudal_Driver);
        assignin('base', 'Anal_Driver',   Anal_Driver);
        assignin('base', 'Dorsal_Driver', Dorsal_Driver);
        assignin('base', 'Ped_Driver',    Ped_Driver);
        assignin('base', 'Mid_Driver',    Mid_Driver);
        assignin('base', 'Pect_LA',    Pect_LA);
        assignin('base', 'Pect_LB',    Pect_LB);
        assignin('base', 'Pect_RA',    Pect_RA);
        assignin('base', 'Pect_RB',    Pect_RB);
        assignin('base', 'Nose',          Nose);
        assignin('base', 'Starting_Velocity', velocity);
        assignin('base', 'Dur', duration);
        assignin('base', 'COB_X', xCOB);
        assignin('base', 'COB_Y', zCOB);

        set_param(modelName, 'SimMechanicsOpenEditorOnUpdate', 'on');
        simOut = sim(modelName, 'SimulationMode', 'normal');
        assignin('base', 'simOut', simOut);

        % Retrieve and plot data
        time = simOut.simout.px.Time;
        px   = squeeze(simOut.simout.px.Data);
        py   = squeeze(simOut.simout.py.Data);

        % Finite-difference velocities
        dt = mean(diff(time));
        Vx = [diff(px)/dt; 0];
        Vy = [diff(py)/dt; 0];

        % Plot Px vs Py
        plot(posPlotAxes, px, py, 'b');
        xlabel(posPlotAxes, 'Px');
        ylabel(posPlotAxes, 'Py');

        % Plot Vx vs Time
        plot(topVelAxes, time, Vx, 'r');
        xlabel(topVelAxes, 'Time');
        ylabel(topVelAxes, 'Vx');

        % Plot Vy vs Time
        plot(bottomVelAxes, time, Vy, 'g');
        xlabel(bottomVelAxes, 'Time');
        ylabel(bottomVelAxes, 'Vy');
    end

    function saveTrialData(fileName)
        % This expects that your simulation result is stored in "out" in base
        if evalin('base', '~exist(''out'',''var'')')
            uialert(fig, 'No simulation run yet', 'Error');
            return;
        end

        out = evalin('base', 'out');

        % Create subfolder for today's date
        outputDir = fullfile('Simulation_Outputs', ...
            ['sim_out_' datestr(now, 'yyyy_mm_dd')]);
        if ~exist(outputDir, 'dir')
            mkdir(outputDir);
        end

        % Build the file name and handle duplicates
        fullPath = fullfile(outputDir, [fileName '.mat']);
        counter = 1;
        while exist(fullPath, 'file')
            fullPath = fullfile(outputDir, [fileName '_' num2str(counter, '%03d') '.mat']);
            counter = counter + 1;
        end

        % Save
        save(fullPath, 'out');
        disp(['Data saved to ' fullPath]);
    end
end

%==========================================================
% Example inertia recalculation function (placeholder)
%==========================================================
function I_new = recalculateMoI(I_old, newMass, oldCoM, newCoM)
% Just a dummy function that returns I_old for demonstration.
% Replace with your own recalc code if needed.
I_new = I_old;  %#ok<NASGU>
% e.g., parallel axis theorem or something similar
I_new = I_old + (newMass)*((oldCoM - newCoM).').^2;
end
