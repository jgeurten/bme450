%Lab 1 - Jordan Geurten for BME 450

%Read these in from .csv, and iterate through:
clear all, close all
load('lab1data.mat'); 
SPEED_COL = 2; 
ANGLE_COL = 3; 
AZIM_COL = 4; 
BACKSPIN_COL = 5; 
SIDESPIN_COL =6; 

rho_in = 0.0023769; 
Cd = 0.28;  
Cl = 0.25;  
Cm = 0.1; 
aero_coeffs = [Cd,Cl,Cm]; 
%From optimization section (0.25,0.25, 0.05)
aero_coeffs = [0.25, 0.25, 0.05];

figure 
for shotID = 1:size(lab1data, 1)
    %Get X vector and final 
    v0 = table2array(lab1data(shotID, SPEED_COL)); 
    angle = table2array(lab1data(shotID, ANGLE_COL)); 
    azim = table2array(lab1data(shotID, AZIM_COL)); 
    backspin = table2array(lab1data(shotID, BACKSPIN_COL));
    side_spin = table2array(lab1data(shotID, SIDESPIN_COL)); 
    %Add to the figure
    [x, final,t] = simBallTrajectory(v0, azim, backspin, angle, side_spin, rho_in, aero_coeffs);
    times(shotID) = t(end); 
    dispName = strcat('ShotID ', int2str(shotID)); 
    plot3(x(1:final,4)/3,x(1:final,5)/3,x(1:final,6)/3, 'DisplayName', dispName);
    legend('-DynamicLegend');
    hold on
end
xlabel('X Distance (yd)'); 
ylabel('Y Distance (yd)');
zlabel('Z Distance (yd)'); 
legend('show')

%% Part 2 - Plot shot distance, X, as a function of air density
%Take one shot - take shot 5, straightest, not that that matters

%Get params for shot_id 5
SHOT_ID = 5; 
rho_default = 0.0023769;
v0 = table2array(lab1data(SHOT_ID, SPEED_COL)); 
angle = table2array(lab1data(SHOT_ID, ANGLE_COL)); 
azim = table2array(lab1data(SHOT_ID, AZIM_COL)); 
backspin = table2array(lab1data(SHOT_ID, BACKSPIN_COL));
side_spin = table2array(lab1data(SHOT_ID, SIDESPIN_COL)); 

rho_in = [0.5*rho_default:rho_default/9*(1.5-0.5):1.5*rho_default]; %10 rho's to test
%Add to the figure
figure
for rho = rho_in
    [x, final] = simBallTrajectory(v0, azim, backspin, angle, side_spin, rho, aero_coeffs);
    dispName = strcat('Rho = ', num2str(rho)); 
    plot3(x(1:final,4)/3,x(1:final,5)/3,x(1:final,6)/3, 'DisplayName', dispName);
    legend('-DynamicLegend');
    hold on
end
xlabel('X Distance (yd)'); 
ylabel('Y Distance (yd)');
zlabel('Z Distance (yd)'); 
legend('show')

hold on

%% Part 3 - Find Cl,Cd,Cm such that the difference between theoretical and 
% actual carry yards are minimized
%Brute force this thing at the beginning
rho_default = 0.0023769;
CARRY_COL = 7; 
min_diff = 999; 
sum_diffs = 0;
min_coeffs =[-1, -1, -1];

for Cd = 0:0.05:0.5
    for Cl = 0:0.05:0.5
        for Cm = 0:0.05:0.5
            for shotID = 1:size(lab1data, 1)
                %Get X vector and final 
                v0 = table2array(lab1data(shotID, SPEED_COL)); 
                angle = table2array(lab1data(shotID, ANGLE_COL)); 
                azim = table2array(lab1data(shotID, AZIM_COL)); 
                backspin = table2array(lab1data(shotID, BACKSPIN_COL));
                side_spin = table2array(lab1data(shotID, SIDESPIN_COL)); 
                
                aero_coeffs = [Cd, Cl, Cm];
                [x, final] = simBallTrajectory(v0, azim, backspin, angle, side_spin, rho_default, aero_coeffs);
                if(final == -1)
                    break
                end
                sim_traj_carry = x(final,4)/3;  % X driving distance in yards
                true_carry = table2array(lab1data(shotID, CARRY_COL)); 
                sum_diffs = sum_diffs + abs(sim_traj_carry - true_carry);        

            end
            
            if(sum_diffs < min_diff && final ~= -1)
                min_coeffs = [Cd, Cl, Cm];
                min_diff = sum_diffs; 
            end
            sum_diffs = 0; 
        end 
    end
end

/////////////////

%% x  = fmincon(@myCostFunc, x0) where @myCostFunc is a handle to function myCostFunc
%% function cost = myCostFunc(aeroParams)

% weight1 = 0.8; 
% weight2 = 0.2; 

% [x, final] = simBalltrajectory(params, aeroParams, expVals); 
% %expVals ==> read in from the lab1data.mat

% sim_distance = x(final,4)/3;
% sim_apex = max(x(1)); 
% exp_distance = expVals(1); 
% exp_apex = expVals(2); 
% cost = weight1*abs(sim_distance - exp_distance) + weight2*abs(sim_apex - exp_apex); 

/////////////////

%% Part 4 - Optimization between backspin and launch angle

back_spin = 1000:4500; %in units of rpm
launch_angle = 0:45; %in units degrees
rho_default = 0.0023769;

%From optimization section (0.25,0.25, 0.05)
aero_coeffs = [0.25, 0.25, 0.05];

%Assume straight shot
side_spin = 0; 
azim = 0; 

%Calculate average ball speed per shot:
%Cannot use final distance/time, since time is set to 10
for shotID = 1:size(lab1data, 1)
    v0 = table2array(lab1data(shotID, SPEED_COL)); 
    angle = table2array(lab1data(shotID, ANGLE_COL)); 
    backspin = table2array(lab1data(shotID, BACKSPIN_COL));
    [x, final] = simBallTrajectory(v0, azim, backspin, angle, side_spin, rho_default, aero_coeffs);
    
    avg_speed(shotID) = sqrt((mean(x(1)))^2 + (mean(x(2)))^2); %no contribution from Vz
    avg_speed(shotID) = mean(x(1)); 
end
