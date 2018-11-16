function R = calcRot(psi, theta, phi)
%Assuming 3-2-1
R1 = [cos(psi) -sin(psi) 0; sin(psi) cos(psi) 0 ; 0 0 1]; 
R2 = [cos(theta) 0 sin(theta); 0 1 0; -sin(theta) 0 cos(theta)]; 
R3 = [1 0 0; 0 cos(phi) -sin(phi); 0 sin(phi) cos(phi)]; 

R =  R1*R2*R3; 

end