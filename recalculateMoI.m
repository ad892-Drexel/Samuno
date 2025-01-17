function I_new = adjustInertia(I_original, mass, com_original, com_new)
    % I_original is a 3x1 vector for the original moments of inertia
    % mass is the mass of the object
    % com_original is a 3x1 vector for the original center of mass
    % com_new is a 3x1 vector for the new center of mass

    % Calculate the displacement vector
    displacement = com_new - com_original;
    
    % Calculate the distance squared from the original to the new center of mass
    d_squared = displacement(1)^2 + displacement(2)^2 + displacement(3)^2;
    
    % Calculate the new moments of inertia using the parallel axis theorem
    I_new = I_original + mass * d_squared;
end
