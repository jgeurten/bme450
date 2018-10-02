function xdot = golf_eqns(t,x)

%  Numerical integration of equations of
%  motion for golf ball using Quintavalla model
%
%  x(1)=Vx, x(2)=Vy, x(3)=Vz, x(4)=X, x(5)=Y, x(6)=Z, x(7)=omega

xdot = zeros(7,1);

global radius mass rho area inertia gravity tx ty tz

speed = sqrt(x(1)*x(1)+x(2)*x(2)+x(3)*x(3));
omega = x(7);
Q = rho*speed*speed*area/2;

%From assignment Part 1 definition
Cd = 0.28;  
Cl = 0.25;  
Cm = 0.1; 

xdot(1) = (-Q*Cd*x(1)/speed + Q*Cl*(ty*x(3)-tz*x(2))/speed)/mass ;
xdot(2) = (-Q*Cd*x(2)/speed + Q*Cl*(tz*x(1)-tx*x(3))/speed)/mass - gravity;
xdot(3) = (-Q*Cd*x(3)/speed + Q*Cl*(tx*x(2)-ty*x(1))/speed)/mass;
xdot(4) = x(1);
xdot(5) = x(2);
xdot(6) = x(3);

xdot(7) = -Q*Cm*radius*2/inertia;

end

