function cost = optimizeFriction(coeff_friction)

load('shot_data.mat'); 
W_IN = 3;
W_OUT = 4;
VX_IN = 5;
VX_OUT = 6; 
VY_IN = 7;
VY_OUT = 8;

RADIUS = 21.35/1000; %in meters
MASS = 45.93/1000; %in kg
moi = 2/5*MASS*RADIUS^2; %kg.m^2

sim_spins = []; 
for i= 1:size(shot_data, 1)/2 %first 5 hold the oblique data
    sim_spin = solveImpactEqns(shot_data(i,:), coeff_friction); 
    sim_spins = [sim_spins; sim_spin]; 
end

cost = abs(shot_data(1:5, W_OUT)- sim_spins); 
cost = sum(cost); 
end