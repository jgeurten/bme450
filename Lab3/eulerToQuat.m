function [q0, q1, q2, q3] = eulerToQuat(psi, theta, phi)

psi = psi/2; 
theta = theta/2; 
phi = phi/2; 

q0 = cos(phi)*cos(theta)*cos(psi) + sin(phi)*sin(theta)*sin(psi); 
q1 = sin(phi)*cos(theta)*cos(psi) - cos(phi)*sin(theta)*sin(psi); 
q2 = cos(phi)*sin(theta)*cos(psi) + sin(phi)*cos(theta)*sin(psi); 
q3 = cos(phi)*sin(theta)*sin(psi) - sin(phi)*cos(theta)*cos(psi); 

end