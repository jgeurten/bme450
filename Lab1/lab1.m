%Lab 1 - Jordan Geurten for BME 450

%Read these in from .csv, and iterate through:
global SPEED_COL ANGLE_COL AZIM_COL BACKSPIN_COL SIDESPIN_COL CARRY_COL APEX_COL
clear all, close all
load('lab1data.mat'); 
SPEED_COL = 2; 
ANGLE_COL = 3; 
AZIM_COL = 4; 
BACKSPIN_COL = 5; 
SIDESPIN_COL =6; 
CARRY_COL = 7; 
APEX_COL = 8; 

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
    [x, final,t] = simBallTrajectory([v0, azim, backspin, angle, side_spin, rho_in], aero_coeffs);
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
    [x, final] = simBallTrajectory([v0, azim, backspin, angle, side_spin, rho], aero_coeffs);
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
 
guessCoeffs =[0.15,0.15,0.15];
optimalCoeffs  = fmincon(@calcCost, guessCoeffs) %where @myCostFunc is a handle to function myCostFunc

%optimalCoeffs1 = [.2334, .2030,.2]
%% Part 4 - Optimization between backspin and launch angle

back_spin = 1000:4500; %in units of rpm
launch_angle = 0:45; %in units degrees
rho_default = 0.0023769;

%From optimization section (0.25,0.25, 0.05)
aero_coeffs = [0.25, 0.25, 0.05];

%Assume straight shot
side_spin = 0; 
azim = 0; 

%Calculate average ball speed of all shots
