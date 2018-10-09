%Lab 1 - Jordan Geurten for BME 450

%Read these in from .csv, and iterate through:
global SPEED_COL ANGLE_COL AZIM_COL BACKSPIN_COL SIDESPIN_COL CARRY_COL APEX_COL
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
carry = zeros(10, 1);
apexes = zeros(10,1); 
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
    dispName = strcat('Shot ', int2str(shotID)); 
    plot3(x(1:final,4)/3,x(1:final,5)/3,x(1:final,6)/3, 'DisplayName', dispName);
    carry(shotID) = x(final,4)/3;
    apexes(shotID) = max(x(1:final,5)/3); 
    legend('-DynamicLegend');
    hold on
end
xlabel('X Distance (yd)'); 
ylabel('Y Distance (yd)');
zlabel('Z Distance (yd)'); 
legend('show')
saveas(gcf, 'allShots.png');

%% Part 2 - Plot shot distance, X, as a function of air density
%Take one shot - take shot 5

%Get params for shot_id 5
SHOT_ID = 5; 
rho_default = 0.0023769;
v0 = table2array(lab1data(SHOT_ID, SPEED_COL)); 
angle = table2array(lab1data(SHOT_ID, ANGLE_COL)); 
azim = table2array(lab1data(SHOT_ID, AZIM_COL)); 
backspin = table2array(lab1data(SHOT_ID, BACKSPIN_COL));
side_spin = table2array(lab1data(SHOT_ID, SIDESPIN_COL)); 

rho_in = 0.5*rho_default:rho_default/9*(1.5-0.5):1.5*rho_default; %10 rho's to test
carry = zeros(10, 1);
apexes = zeros(10,1);
count = 1; 

figure
for rho = rho_in
    [x, final] = simBallTrajectory([v0, azim, backspin, angle, side_spin, rho], aero_coeffs);
    dispName = strcat('Rho = ', num2str(rho));
    carry(count) = x(final,4)/3;
    apexes(count) = max(x(1:final,5)/3);
    count = count + 1; 
    plot3(x(1:final,4)/3,x(1:final,5)/3,x(1:final,6)/3, 'DisplayName', dispName);
    legend('-DynamicLegend');
    hold on
end
xlabel('X Distance (yd)'); 
ylabel('Y Distance (yd)');
zlabel('Z Distance (yd)'); 
legend('show')
saveas(gcf, 'shotFive_RhoVariable.png');
%% Part 3 - Find Cl,Cd,Cm such that the difference between theoretical and simulated trajectories
 
guessCoeffs =[0.2,0.2,0.1];
lBounds = [0,0,0]; 
uBounds = [.5,.5,.5]; 
[optimalCoeffs, cost]  = fmincon(@optimizeAero, guessCoeffs,[],[],[],[],lBounds, uBounds)
save('optimalCoeffs.mat', 'optimalCoeffs'); 
%optimalCoeffs1 = [.1713, .0847,.10]
%optimalCoeffs2 = [0.1241    0.0432    0.6342]
%% Part 3 - 2: Plot exp and sim trajectories
load('optimalCoeffs.mat')
for shotID = 1:size(lab1data, 1)
    
    %Get experimental data
    figure
    v0 = table2array(lab1data(shotID, SPEED_COL)); 
    angle = table2array(lab1data(shotID, ANGLE_COL)); 
    azim = table2array(lab1data(shotID, AZIM_COL)); 
    backspin = table2array(lab1data(shotID, BACKSPIN_COL));
    side_spin = table2array(lab1data(shotID, SIDESPIN_COL)); 
    
    %Experimental Trajectory
    [x, final,t] = simBallTrajectory([v0, azim, backspin, angle, side_spin, rho_in], aero_coeffs);
    dispName = ['Shot ', int2str(shotID), ' Exp']; %strcat('Shot ', int2str(shotID), 'sim'); 
    plot(x(1:final,4)/3,x(1:final,5)/3, 'DisplayName', dispName);
    carry(shotID) = x(final,4)/3;
    apexes(shotID) = max(x(1:final,5)/3); 
    txt = ['Apex: ', int2str(apexes(shotID)), 'yds']; 
    %txt = {'Plotted Data:','y = sin(x)'};
    text(carry(shotID)/2,apexes(shotID),txt)
    txt = [ 'Distance: ', int2str(carry(shotID)), '\rightarrow'];
    text(carry(shotID)/1.55, apexes(shotID)/2,txt); 
    hold on
    
    %Simulated Trajectory
    [x, final,t] = simBallTrajectory([v0, azim, backspin, angle, side_spin, rho_in], optimalCoeffs);
    dispName = ['Shot ', int2str(shotID), ' Sim']; 
    plot(x(1:final,4)/3,x(1:final,5)/3, 'DisplayName', dispName);
    carry(shotID) = x(final,4)/3;
    apexes(shotID) = max(x(1:final,5)/3); 
    txt = ['Apex: ', int2str(apexes(shotID)), 'yds']; 
    %txt = {'Plotted Data:','y = sin(x)'};
    text(carry(shotID)/2,apexes(shotID),txt)
    txt = [ 'Distance: ', int2str(carry(shotID)), '\rightarrow'];
    text(carry(shotID)/1.6, apexes(shotID)/2.2,txt); 
    legend('show');
    xlabel('X Distance (yds)'); 
    ylabel('Y Height (yds)');
    
    saveas(gcf, ['part3_sim_exp_', int2str(shotID),'.png']); 
end
%% Part 4 - Optimization between backspin and launch angle

lBounds = [1000, 0]; 
uBounds = [4000, 45]; 
initConds = [4000, 22]; 
options = optimoptions('fmincon', 'Display', 'iter','Algorithm', 'sqp'); 
nonlcon = @unitdisk; 
[optimalLaunchConds, distance] = fmincon(@optimizeLaunch, initConds,[],[],[],[],lBounds, uBounds)
%[backspin, launchAngle]