function Q = calcQuaternion(Qprev, angVel)

q0 = Qprev(1); q1 = Qprev(2); q2 = Qprev(3); q3 = Qprev(4);
Qdot = 1/2*[-q1 q0 -q3 q2; -q2 q3 q0 -q1; -q3 -q2 q1 q0]'*angVel; 
Q = Qdot + Qprev; 

end