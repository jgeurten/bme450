function [x, final] = simBallTrajectory(v0, azim, back, elev, side, rho_in)

global radius mass rho area inertia gravity tx ty tz

%%Part 1
PI = 3.1415926535;
gravity = 32.17;
radius = (1.68/2)/12;
mass = (1.62/16)/gravity;
%rho = 0.0023769;
rho = rho_in; 
area = PI*radius*radius;
inertia = 0.4*mass*radius*radius;
%  Launch conditions
rifle = 0;   % in rpm, about global X

vx = (v0*cos(elev*PI/180)*cos(azim*PI/180))*88/60;
vy = v0*sin(elev*PI/180)*88/60;
vz = -(v0*cos(elev*PI/180)*sin(azim*PI/180))*88/60;
wx = rifle*PI/30;
wy = side*PI/30;
wz = back*PI/30;

omega = sqrt(wx*wx + wy*wy + wz*wz);
tx = wx/omega;
ty = wy/omega;
tz = wz/omega;

t0 = 0;
tf = 10;
x0 = [vx, vy, vz, 0, 0, 0, omega]';   % launch conditions

options = odeset('RelTol',1e-5,'AbsTol',1e-6);
[t,x] = ode45('golf_eqns', [t0,tf], x0, options);

% find time when ball returns to ground.
fgh= 0;  % final ground height, in feet
final = -1;
[rows,cols] = size(x);
for i=2:rows,
  if x(i,5) < fgh  % ball has impacted ground (check y_dot < 0)
    if final < 0  % then we are at first instant of impact.
        final = i;
        % use linear interpolation to get final values:
        t(i)= t(i-1) + (t(i)-t(i-1))*(fgh-x(i-1,5))/(x(i,5)-x(i-1,5));
        x(i,1) = x(i-1,1) + (x(i,1)-x(i-1,1))*(fgh-x(i-1,5))/(x(i,5)-x(i-1,5));
        x(i,2) = x(i-1,2) + (x(i,2)-x(i-1,2))*(fgh-x(i-1,5))/(x(i,5)-x(i-1,5));
        x(i,3) = x(i-1,3) + (x(i,3)-x(i-1,3))*(fgh-x(i-1,5))/(x(i,5)-x(i-1,5));
        x(i,4) = x(i-1,4) + (x(i,4)-x(i-1,4))*(fgh-x(i-1,5))/(x(i,5)-x(i-1,5));
        x(i,6) = x(i-1,6) + (x(i,6)-x(i-1,6))*(fgh-x(i-1,5))/(x(i,5)-x(i-1,5));
        x(i,7) = x(i-1,7) + (x(i,7)-x(i-1,7))*(fgh-x(i-1,5))/(x(i,5)-x(i-1,5));
        x(i,5) = fgh;  %final y value reset to fgh
    end
  end
end
end