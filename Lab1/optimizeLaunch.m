function distance = optimizeLaunch(launchConds)

    SPEED_COL = 2; 
    %Calculate average ball speed of all shots
    load('lab1data.mat')
    avg_velocity = mean(table2array(lab1data(:, SPEED_COL))); 

    %From optimization section
    load('optimalCoeffs.mat');
    aero_coeffs = optimalCoeffs; 

    %Assume straight shot
    side_spin = 0; 
    azim = 0; 
    
    [x, final,t] = simBallTrajectory([avg_velocity, azim, launchConds(1), launchConds(2), side_spin], aero_coeffs); 
    
    distance = x(final,4)/3;
    if distance == 0
        distance = 999999; 
    else
        distance = 1/distance;
    end
    
end