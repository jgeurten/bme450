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
load('shot_data.mat')
VYOUT = 8; 
VYIN = 7; 
COR = []; 
for i = 1:size(shot_data, 1)
    e = -shot_data(i, VYOUT)/shot_data(i, VYIN); 
    COR = [COR; e]; 
end

sz = 60;
figure, 
for  i = 1:size(shot_data, 1)
    dispName = ['Shot ', num2str(i)]; 
    scatter(abs(shot_data(i, VYIN)), COR(i), sz,  'LineWidth', 2, 'DisplayName', dispName); 
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
%% Plot the experimental and simulated spins as a function of the input tangenetial velocity
optimalFriction = 0.1033; 
sim_w_out = [];
exp_w = shot_data(1:5, W_OUT); %1-5: oblique
% colorMat = linspace(1,max(shot_data(:,VX_IN)), 5);
sz = 60; 
mkrs = ['o', '+', '*', 'd', 'p']; 
colors = [[0, 0.4470, 0.7410]; [0.8500, 0.3250, 0.0980]; [0.9290, 0.6940, 0.1250]; ...
    [0.4940, 0.1840, 0.5560]; [0.4660, 0.6740, 0.1880]]; 
for i = 1:5
    w_out_sim = solveImpactEqns(shot_data(i, :), optimalFriction); 
    sim_w_out = [sim_w_out; w_out_sim];
end
    
figure, 
hold on
for i = 1:length(sim_w_out)
    vin_x = shot_data(i, VX_IN);
    scatter(vin_x, sim_w_out(i),   mkrs(1), 'LineWidth', 2, 'DisplayName', ...
        ['Shot ', num2str(i), ' Sim'], 'MarkerEdgeColor',colors(i, :));
    scatter(vin_x, exp_w(i),   mkrs(2), 'LineWidth', 2,  'DisplayName', ...
        ['Shot ', num2str(i), ' Exp'], 'MarkerEdgeColor',colors(i,:));
    legend('-DynamicLegend');
end

xlabel('Inbound Tangential Velocity (m/s)'); 
ylabel('Outbound Rotational Velocity (rad/s)'); 
legend('Location', 'northwest'); 
legend('show')
hold off; 
saveas(gcf, 'OBLIQUE_Spin_Accuracy_vs_Inbound_Speed.png'); 
%% Part 3 - Acute shots: Plot simulated spins versus experimental
% Acute angle shots: 6 - 10
W_IN = 3;
W_OUT = 4;
VX_IN = 5;
VX_OUT = 6; 
VY_IN = 7;
VY_OUT = 8; 

sim_w_out = []; 
exp_w = shot_data(6:10, W_OUT); 

for i = 6:10
    w_out_sim = solveImpactEqns(shot_data(i, :), optimalFriction); 
    sim_w_out = [sim_w_out; w_out_sim];
end

mkrs = ['o', '+', '*', 'd', 'p']; 
colors = [[0, 0.4470, 0.7410]; [0.8500, 0.3250, 0.0980]; [0.9290, 0.6940, 0.1250]; ...
    [0.4940, 0.1840, 0.5560]; [0.4660, 0.6740, 0.1880]]; 

figure, 
hold on
for i = 1:length(sim_w_out)
    vin_x = shot_data(i+5, VX_IN);
     scatter(vin_x, sim_w_out(i),   mkrs(1), 'LineWidth', 2, 'DisplayName', ...
        ['Shot ', num2str(i+5), ' Sim'], 'MarkerEdgeColor',colors(i, :));
    scatter(vin_x, exp_w(i),   mkrs(2), 'LineWidth', 2,  'DisplayName', ...
        ['Shot ', num2str(i+5), ' Exp'], 'MarkerEdgeColor',colors(i,:));
    legend('-DynamicLegend');
end

% plot(vin_x, sim_w_out, 'DisplayName', 'Simulated Omega'); 
% plot(vin_x, exp_w, 'DisplayName', 'Experimental Omega'); 
xlabel('Inbound Tangential Velocity (m/s)'); 
ylabel('Outbound Rotational Velocity (rad/s)'); 
legend('Location', 'northwest'); 
legend('show')
hold off; 
saveas(gcf, 'ACUTE_Spin_Accuracy_vs_Inbound_Speed.png'); 

%% Part 4 - Solving acute angle outbound spins assuming rolling impact
W_IN = 3;
W_OUT = 4;
VX_IN = 5;
VX_OUT = 6; 
VY_IN = 7;
VY_OUT = 8; 

sim_w_out_roll = []; 
sim_w_out_slide = []; 
exp_w = shot_data(6:10, W_OUT); 

for i = 6:10
    w_out_sim_roll = solveRollingImpact(shot_data(i, :), optimalFriction); 
    w_out_sim_slide = solveImpactEqns(shot_data(i, :), optimalFriction); 
    sim_w_out_roll = [sim_w_out_roll; w_out_sim_roll];
    sim_w_out_slide = [sim_w_out_slide; w_out_sim_slide]; 
end

mkrs = ['o', '+', '*', 'd', 'p']; 
colors = [[0, 0.4470, 0.7410]; [0.8500, 0.3250, 0.0980]; [0.9290, 0.6940, 0.1250]; ...
    [0.4940, 0.1840, 0.5560]; [0.4660, 0.6740, 0.1880]]; 

figure, 
hold on
for i = 1:length(sim_w_out_roll)
    vin_x = shot_data(i+5, VX_IN);
     scatter(vin_x, sim_w_out_roll(i),   mkrs(1), 'LineWidth', 2, 'DisplayName', ...
        ['Shot ', num2str(i+5), ' Sim'], 'MarkerEdgeColor',colors(i, :));
    scatter(vin_x, exp_w(i),   mkrs(2), 'LineWidth', 2,  'DisplayName', ...
        ['Shot ', num2str(i+5), ' Exp'], 'MarkerEdgeColor',colors(i,:));
    legend('-DynamicLegend');
end

% plot(vin_x, sim_w_out, 'DisplayName', 'Simulated Omega'); 
% plot(vin_x, exp_w, 'DisplayName', 'Experimental Omega'); 
xlabel('Inbound Tangential Velocity (m/s)'); 
ylabel('Outbound Rotational Velocity (rad/s)'); 
legend('Location', 'northwest'); 
legend('show')
hold off; 
saveas(gcf, 'ROLLING_Spin_Accuracy_vs_Inbound_Speed.png'); 


%OVERLAY PLOT CODE:
figure, 
hold on
for i = 1:length(sim_w_out_roll)  
    vin_x = shot_data(i+5, VX_IN);
     scatter(vin_x, sim_w_out_roll(i),   mkrs(1), 'LineWidth', 2, 'DisplayName', ...
        ['Shot ', num2str(i+5), ' Rolling'], 'MarkerEdgeColor',colors(i, :));
    scatter(vin_x, sim_w_out_slide(i),   mkrs(3), 'LineWidth', 2, 'DisplayName', ...
        ['Shot ', num2str(i+5), ' Sliding'], 'MarkerEdgeColor',colors(i, :));
    scatter(vin_x, exp_w(i),   mkrs(2), 'LineWidth', 2,  'DisplayName', ...
        ['Shot ', num2str(i+5), ' Exp'], 'MarkerEdgeColor',colors(i,:));
    legend('-DynamicLegend');
end

% plot(vin_x, sim_w_out, 'DisplayName', 'Simulated Omega'); 
% plot(vin_x, exp_w, 'DisplayName', 'Experimental Omega'); 
xlabel('Inbound Tangential Velocity (m/s)'); 
ylabel('Outbound Rotational Velocity (rad/s)'); 
legend('Location', 'northwest'); 
legend('show')
hold off; 
saveas(gcf, 'OVERLAY_Spin_Accuracy_vs_Inbound_Speed.png'); 