
%  Numerical integration of equations of
%  motion for golf ball from 31/10/2014 derivation.
%
%  x(1)=Vx, x(2)=Vy, x(3)=Vz, x(4)=X, x(5)=Y, x(6)=Z, x(7)=omega

global radius mass rho area inertia grav tx ty tz

pie = 3.1415926535;
grav = 32.17;
radius = (1.68/2)/12;
mass = (1.62/16)/grav;
rho = 0.0023769;
area = pie*radius*radius;
inertia = 0.4*mass*radius*radius;

%  Launch conditions
v0 = 140; % in mph
elev = 17; % in deg
azim = 0;  % in deg, about Y (i.e. going left)
back = 2500; % in rpm, about global Z
side = 0;    % in rpm, about global Y
rifle = 0;   % in rpm, about global X

vx = (v0*cos(elev*pie/180)*cos(azim*pie/180))*88/60;
vy = v0*sin(elev*pie/180)*88/60;
vz = -(v0*cos(elev*pie/180)*sin(azim*pie/180))*88/60;
wx = rifle*pie/30;
wy = side*pie/30;
wz = back*pie/30;

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

x(final,4)/3  % X driving distance in yards

figure(1)
plot(x(1:final,4)/3,x(1:final,5)/3)
axis([0 280 -10 70])
xlabel ('X (yd)')
ylabel ('Y (yd)')
title ('Side view of trajectory')
%print -dps plot1

%figure(2)
%plot(x(1:final,4)/3,-x(1:final,6)/3)
%axis([0 280 0 50])
%xlabel ('X (yd)')
%ylabel ('-Y (yd)')
%title ('Top view of trajectory')
%print -dps plot1

%figure(3)
%plot(t,x(:,7)*30/pie)
%xlabel ('Time (s)')
%ylabel ('Omega (rpm)')
%title ('Omega versus time')
%print -dps plot1

