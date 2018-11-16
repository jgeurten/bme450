% Lab 3 main script
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
rUpperXAngle = zeros(length(imudata(:, TIME))-1,1); rUpperYAngle = zeros(length(imudata(:, TIME))-1,1);
rUpperZAngle = zeros(length(imudata(:, TIME))-1,1); rLowerXAngle = zeros(length(imudata(:, TIME))-1,1);
rLowerYAngle = zeros(length(imudata(:, TIME))-1,1); rLowerZAngle = zeros(length(imudata(:, TIME))-1,1);

for i = 1:length(imudata(:,TIME))-1
%     rUpperXAngle(i) = trapz(imudata(i:i+1,TIME), imudata(i:i+1,RIGHT_UP_X)); 
%     rUpperYAngle(i) = trapz(imudata(i:i+1,TIME), imudata(i:i+1,RIGHT_UP_Y)); 
%     rUpperZAngle(i) = trapz(imudata(i:i+1,TIME), imudata(i:i+1,RIGHT_UP_Z)); 
    rUpperXAngle(i) = cumtrapz(imudata(:,TIME), imudata(:,RIGHT_UP_X)); 
    rUpperYAngle(i) = cumtrapz(imudata(:,TIME), imudata(:,RIGHT_UP_Y)); 
    rUpperZAngle(i) = cumtrapz(imudata(:,TIME), imudata(:,RIGHT_UP_Z));
    rLowerXAngle(i) = trapz(imudata(i:i+1,TIME), imudata(i:i+1,RIGHT_LOW_X)); 
    rLowerYAngle(i) = trapz(imudata(i:i+1,TIME), imudata(i:i+1,RIGHT_LOW_Y)); 
    rLowerZAngle(i) = trapz(imudata(i:i+1,TIME), imudata(i:i+1,RIGHT_LOW_Z));
end

rUpperXAngle = rUpperXAngle.'; rUpperYAngle = rUpperYAngle.'; rUpperZAngle = rUpperZAngle.';
rLowerXAngle = rLowerXAngle.'; rLowerYAngle = rLowerYAngle.'; rLowerZAngle = rLowerZAngle.';
Q0 = zeros(size(rUpperXAngle)); Q1 = zeros(size(rUpperXAngle)); 
Q2 = zeros(size(rUpperXAngle)); Q3 = zeros(size(rUpperXAngle)); 

for i = 1:length(rUpperXAngle)
    quat = eul2quat([rUpperXAngle(i), rUpperYAngle(i), rUpperZAngle(i)], 'ZYZ'); 
    Q0(i) = quat(1); 
    Q1(i) = quat(2); 
    Q2(i) = quat(3); 
    Q3(i) = quat(4); 
end


