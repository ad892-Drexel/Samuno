function result = createSineWave(amplitude, bias, phase, frequency, timeStep, duration)
    % Create a time array from 0 to duration with the specified time step
    timeArray = 0:timeStep:duration;
    
    % Calculate the sine wave values
    sineValues = amplitude * sind(360* frequency * timeArray + phase) + bias;
    
    % Combine time array and sine values into a single result array
    result = [timeArray' deg2rad(sineValues)'];
end
