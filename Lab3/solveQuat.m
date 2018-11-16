function [Q0, Q1, Q2, Q3] = solveQuat()

clear q0 q1 q2 q3
syms q0 q1 q2 q3 
 
function Q = quat(q0,q1,q2,q3)
    Q(1) = q0.^2 + q1.^2 + q2.^2 + q3.^2 - 1;
    Q(2) = 2*(q0.^2 + q1.^2 - 1/2) - R_true(1,1);
    Q(3) = 2*(q1.*q2 - q0.*q3) - R_true(1,2);
    Q(4) = 2*(q1.*q3 + q0.*q2) - R_true(1,3);
    Q(5) = 2*(q1.*q2 + q0.*q3) - R_true(2,1);
    Q(6) = 2*(q0.^2 + q2.^2 - 1/2)- R_true(2,2);
    Q(7) = 2*(q2.*q3 - q2.*q1) - R_true(2,3); %couldnt decipher term 2
    Q(8) = 2*(q1.*q3-q0.*q2)- R_true(3,1);
    Q(9) = 2*(q2.*q3-q0.*q1)- R_true(3,2);
    Q(10) = 2*(q0.^2 + q3.^2 - 1/2) - R_true(3,3);
    
    x0 = [0,0,0,0]
    [q0,q1,q2,q3] = fsolve(eq1,eq2,eq3,eq4,[q0,q1,q2,q3]);
    q0_out = double(q0)
    q1_out = double(q1)
    q2_out = double(q2)
    q3_out = double(q3)