%Test
spins = [1001.5, 2500,3000, 3998.5 ];

%plot results:
avg_velocity = 157; 

%From optimization section
load('optimalCoeffs.mat');
aero_coeffs = optimalCoeffs; 

%Assume straight shot
side_spin = 0; 
azim = 0; 

for spin = spins
    [x, final,t] = simBallTrajectory([avg_velocity, azim, spin, optimalLaunchConds(2), side_spin], aero_coeffs); 
    dispName = ['Backspin: ', num2str(spin), ' rpm']; %, 'Angle: ', num2str(optimalLaunchConds(2)), ' deg',  ]; 
    plot3(x(1:final,4)/3,x(1:final,5)/3,x(1:final,6)/3, 'DisplayName', dispName);
    legend('-DynamicLegend');
    hold on
end
xlabel('X Distance (yd)'); 
ylabel('Y Distance (yd)');
zlabel('Z Distance (yd)'); 
legend('show')
