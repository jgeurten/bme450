%Lab 2 Script

%% Setup - only have to run once to extract the velocity and spin
cur_dir = pwd; 
shot_data = [];
%Get oblique shot data
oblique_dir = [cur_dir, '\shots\oblique_angle\shot']; 
for i=1:5
    path = [oblique_dir, num2str(i), '.wmv']; 
    [w_in, w_out, vx_in, vx_out, vy_in, vy_out] = track_golf_ball(path); 
    shot_data = [shot_data; 45 i w_in w_out vx_in vx_out vy_in vy_out]; 
end
%Get acute shot data
acute_dir = [cur_dir, '\shots\shallow_angle\shot']; 
for i=1:5
    path = [acute_dir, num2str(i), '.wmv']; 
    [w_in, w_out, vx_in, vx_out, vy_in, vy_out] = track_golf_ball(path); 
    shot_data = [shot_data; 15, i, w_in, w_out, vx_in, vx_out, vy_in, vy_out]; 
end

csvwrite([cur_dir, '\ShotData.csv'], shot_data); 

%% Part 1 - Calculate COR and Plot as a function of input velocity
VYOUT = 8; 
VYIN = 7; 
COR = []; 
for i = 1:size(shot_data, 1)
    e = -shot_data(i, VYOUT)/shot_data(i, VYIN); 
    COR = [COR; e]; 
end

figure, 
for  i = 1:size(shot_data, 1)
    dispName = ['Shot ', num2str(i)]; 
    scatter(abs(shot_data(i, VYIN)), COR(i), 'DisplayName', dispName); 
    legend('-DynamicLegend');
    hold on; 
end
Fit = polyfit(abs(shot_data(:,VYIN)),COR,1);

x = 0:50; 
y = Fit(1)*x + Fit(2); %y = mx+b
plot(x,y); 

xlabel('Inbound Normal Velocity (m/s)'); 
ylabel('Coefficient of Restitution'); 
legend('show')
hold off; 
saveas(gcf, 'COR_vs_Inbound_Speed.png'); 

mean_COR = mean(COR); 
%% Part 2 - Oblique: Optimize friction to minimize exp and sim outbound spins
%Estimate mu based:
W_IN = 3;
W_OUT = 4;
VX_IN = 5;
VX_OUT = 6; 
VY_IN = 7;
VY_OUT = 8;
coeffs = []; 

for i = 1:size(shot_data, 1)/2
    vx_in = abs(shot_data(i, VX_IN)); 
    vx_out = abs(shot_data(i, VX_OUT)); 
    vy_in = abs(shot_data(i, VY_IN)); 
    mu = (vx_in - vx_out)/(vy_in*(1+mean_COR)); 
    coeffs = [coeffs; mu]; 
end

mean_mu = mean(coeffs)

%FMINCON Section
initGuess = 0.3; 
options = optimoptions('fmincon','Display','iter'); 
nonlcon = @unitdisk; 
[optimalFriction, cost] = fmincon(@optimizeFriction, initGuess,[],[],[],[],[], [], [], options)

%% Part 3 - Acute shots: Plot simulated spins versus experimental

RADIUS = 21.35/1000; %in meters
MASS = 45.93/1000; %in kg
moi = 2/5*MASS*RADIUS^2; %kg.m^2

W_IN = 3;
W_OUT = 4;
VX_IN = 5;
VX_OUT = 6; 
VY_IN = 7;
VY_OUT = 8; 

sim_w_out = []; 
exp_w = shot_data(1:5, W_OUT); 

for i = 1:5
    w_out_sim = solveImpactEqns(shot_data(i, :), optimalFriction); 
    sim_w_out = [sim_w_out; w_out_sim];
end

colorMat = ['r', 'g', 'b', 'c', 'm']; 

figure, 
hold on
% for i = 1:size(sim_w_out)
%     vin_x = shot_data(i+5, VX_IN);
%     scatter(vin_x, sim_w_out(i),  'DisplayName', ['Shot ', num2str(i+5), ' Sim'], ...
%         'MarkerEdgeColor', colorMat(i), 'MarkerFaceColor', colorMat(i));
%     scatter(vin_x, exp_w(i),  'd', 'DisplayName', ['Shot ', num2str(i+5), ' Exp'], ...
%         'MarkerEdgeColor', colorMat(i), 'MarkerFaceColor', colorMat(i) );
%     legend('-DynamicLegend');
% end

plot(vin_x, sim_w_out, 'DisplayName', 'Simulated Omega'); 
plot(vin_x, exp_w, 'DisplayName', 'Experimental Omega'); 
xlabel('Inbound Tangential Velocity (m/s)'); 
ylabel('Outbound Rotational Velocity (rad/s)'); 
legend('show')
hold off; 
saveas(gcf, 'Spin_Accuracy_vs_Inbound_Speed.png'); 

sim_w_out


