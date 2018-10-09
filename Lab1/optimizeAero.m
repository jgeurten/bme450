function cost = optimizeAero(aero_coeffs )

SPEED_COL = 2; 
ANGLE_COL = 3; 
AZIM_COL = 4; 
BACKSPIN_COL = 5; 
SIDESPIN_COL =6; 
CARRY_COL = 7; 
APEX_COL = 8;
cost = 0; 

load('lab1data.mat')

weight1 = 0.7; 
weight2 = 0.3;
rho_in = 0.0023769; 

for shotID = 1:size(lab1data, 1)
    %Get X vector and final 
    v0 = table2array(lab1data(shotID, SPEED_COL)); 
    angle = table2array(lab1data(shotID, ANGLE_COL)); 
    azim = table2array(lab1data(shotID, AZIM_COL)); 
    backspin = table2array(lab1data(shotID, BACKSPIN_COL));
    side_spin = table2array(lab1data(shotID, SIDESPIN_COL)); 
    %Add to the figure
    [x, final,t] = simBallTrajectory([v0, azim, backspin, angle, side_spin, rho_in], aero_coeffs); 
    exp_distance = table2array(lab1data(shotID, CARRY_COL)); 
    exp_apex = table2array(lab1data(shotID, APEX_COL)); 

    if(final == -1)
        sim_distance = 0; 
        sim_apex = 0; 
    else
        sim_distance = x(final,4)/3;
        sim_apex = max(x(:,5));
    end
 
    cost = cost + weight1*abs(sim_distance - exp_distance) + weight2*abs(sim_apex - exp_apex);
end
end


