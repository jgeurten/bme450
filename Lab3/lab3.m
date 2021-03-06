% Lab 3 main script
load('segAngVel')
load('trueQuats')
% Constants - Right Leg
TIME = 1; 
RIGHT_UP_X = 5; 
RIGHT_UP_Y = 6; 
RIGHT_UP_Z = 7; 
RIGHT_LOW_X = 8; 
RIGHT_LOW_Y = 9; 
RIGHT_LOW_Z = 10; 
% Constants - Left Leg
LEFT_UP_X = 14; 
LEFT_UP_Y = 15; 
LEFT_UP_Z = 16; 
LEFT_LOW_X = 17; 
LEFT_LOW_Y = 18; 
LEFT_LOW_Z = 19; 

%%Part 1 - Integrate and get Quaternions
%Right leg segments
rUpperXAngle = zeros(length(segAngVel(:, TIME))-1,1); rUpperYAngle = zeros(length(segAngVel(:, TIME))-1,1);
rUpperZAngle = zeros(length(segAngVel(:, TIME))-1,1); rLowerXAngle = zeros(length(segAngVel(:, TIME))-1,1);
rLowerYAngle = zeros(length(segAngVel(:, TIME))-1,1); rLowerZAngle = zeros(length(segAngVel(:, TIME))-1,1);

%Left leg segments
lUpperXAngle = zeros(length(segAngVel(:, TIME))-1,1); lUpperYAngle = zeros(length(segAngVel(:, TIME))-1,1);
lUpperZAngle = zeros(length(segAngVel(:, TIME))-1,1); lLowerXAngle = zeros(length(segAngVel(:, TIME))-1,1);
lLowerYAngle = zeros(length(segAngVel(:, TIME))-1,1); lLowerZAngle = zeros(length(segAngVel(:, TIME))-1,1);

for i = 1:length(segAngVel(:,TIME))-1
    %Right leg:
    %Thigh
    rUpperXAngle(i) = trapz(segAngVel(i:i+1,TIME), segAngVel(i:i+1,RIGHT_UP_X)); 
    rUpperYAngle(i) = trapz(segAngVel(i:i+1,TIME), segAngVel(i:i+1,RIGHT_UP_Y)); 
    rUpperZAngle(i) = trapz(segAngVel(i:i+1,TIME), segAngVel(i:i+1,RIGHT_UP_Z)); 
    
    %Shank
    rLowerXAngle(i) = trapz(segAngVel(i:i+1,TIME), segAngVel(i:i+1,RIGHT_LOW_X)); 
    rLowerYAngle(i) = trapz(segAngVel(i:i+1,TIME), segAngVel(i:i+1,RIGHT_LOW_Y)); 
    rLowerZAngle(i) = trapz(segAngVel(i:i+1,TIME), segAngVel(i:i+1,RIGHT_LOW_Z));
    
    %LEFT leg:
    %Thigh
    lUpperXAngle(i) = trapz(segAngVel(i:i+1,TIME), segAngVel(i:i+1,LEFT_UP_X)); 
    lUpperYAngle(i) = trapz(segAngVel(i:i+1,TIME), segAngVel(i:i+1,LEFT_UP_Y)); 
    lUpperZAngle(i) = trapz(segAngVel(i:i+1,TIME), segAngVel(i:i+1,LEFT_UP_Z)); 
    
    %Shank
    lLowerXAngle(i) = trapz(segAngVel(i:i+1,TIME), segAngVel(i:i+1,LEFT_LOW_X)); 
    lLowerYAngle(i) = trapz(segAngVel(i:i+1,TIME), segAngVel(i:i+1,LEFT_LOW_Y)); 
    lLowerZAngle(i) = trapz(segAngVel(i:i+1,TIME), segAngVel(i:i+1,LEFT_LOW_Z));
end

rUpperXAngle = rUpperXAngle.'; rUpperYAngle = rUpperYAngle.'; rUpperZAngle = rUpperZAngle.';
rLowerXAngle = rLowerXAngle.'; rLowerYAngle = rLowerYAngle.'; rLowerZAngle = rLowerZAngle.';
lUpperXAngle = lUpperXAngle.'; lUpperYAngle = lUpperYAngle.'; lUpperZAngle = lUpperZAngle.';
lLowerXAngle = lLowerXAngle.'; lLowerYAngle = lLowerYAngle.'; lLowerZAngle = lLowerZAngle.';

angular_rUpper = [rUpperXAngle; rUpperYAngle; rUpperZAngle]; 

%Q_rUpper = zeros(3, length(rUpperXAngle)); Q_lUpper = zeros(size(rUpperXAngle)); 
Q_rLower = zeros(size(rUpperXAngle)); Q_lLower = zeros(size(rUpperXAngle));
Q_rUpper = []; 
%IC's 
IC = trueQuats(1, 6:9); 

for i = 1:length(rUpperXAngle)
    if(i == 1)
        %Use initial conditions
        Qprev = IC'; 
    else
        %Use prior quaternion:
        Qprev = Q_rUpper(i-1, :); 
    end
    Q_rUpper_t = calcQuaternion(Qprev, angular_rUpper(:,i)); 
    Q_rUpper = [Q_rUpper; Q_rUpper_t']; 
end


