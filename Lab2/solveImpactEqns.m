function w_out_sim = solveImpactEqns(shot_data, mu)
% system of equations for impact with friction
W_IN = 3;
VX_IN = 5;
VY_IN = 7;

vx_in = abs(shot_data(VX_IN)); 
vy_in = abs(shot_data(VY_IN)); 
w_in = shot_data(W_IN); 
cor = 0.846; 
RADIUS = 21.35/1000; %in meters
MASS = 45.93/1000; %in kg
moi = 2/5*MASS*RADIUS^2; %kg.m^2

syms vx_out vy_out w_out normal frict

eqn1 = vy_out - cor*vy_in == 0; 
eqn2 = -MASS*vy_in + normal - MASS*vy_out == 0; 
eqn3 = MASS*vx_in - frict - MASS*vx_out == 0; 
eqn4 = moi*w_in + RADIUS*frict - moi*w_out == 0; 
eqn5 = frict - mu*normal == 0; 

sol = solve([eqn1, eqn2, eqn3, eqn4, eqn5], ...
    [vx_out, vy_out, w_out, normal, frict]);

w_out_sim = double(sol.w_out); 