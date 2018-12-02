function [vx_dt, vy_dt] = calc2DVelocity(centers)

% Constants
DDT_THRES = 0.5;
PUCK_SZ_PX = 70; % Diameter in pixels (empirically calc over multiple frames)
PUCK_SZ_M = 76/1000; % Puck diameter: 76mm
FRAME_RATE = 240;    % FPS
PERIOD = 1/FRAME_RATE; % in seconds

x = centers(:,1); y = centers(:,2);
dx = diff(x); dy = diff(y); 
dxx = smooth(dx); 
dyy = smooth(dy); 

% Plot position data
figure, plot(1:length(x),x, 'LineWidth', 3)
xlabel('Frame Number');
ylabel('Position (X pixel)'); 
title('Position of x Center')
saveas(gcf, 'Position_X_Center.png')
figure, plot(1:length(y),y, 'LineWidth', 3)
xlabel('Frame Number');
ylabel('Position (Y pixel)'); 
title('Position of y Center')
saveas(gcf, 'Position_Y_Center.png')

% Plot velocity data
figure, plot(1:length(dxx),dxx, 'LineWidth', 3)
xlabel('Frame Number');
ylabel('dx/dt (pxs/frame)'); 
title('Derivative of x Center')
saveas(gcf, 'Derivative_X_Center.png')

figure, plot(1:length(dyy),dyy, 'LineWidth', 3)
title('Derivative of y Center')
xlabel('Frame Number');
ylabel('dy/dt (pxs/frame)'); 
saveas(gcf, 'Derivative_Y_Center.png')

% First instance of moving puck -- averaged from the dx and dy channel
% (+) dx --> left to right (global: forward); (+) dy --> top to bottom (global: right)
frame_idx = round((find(dxx > DDT_THRES, 1) + find(dyy > DDT_THRES, 1))/2); 

% Calculate derivative of center point of the puck [pixels/second]
vx = mean(dxx(frame_idx:end)); vy = mean(dyy(frame_idx:end)); 
vxx =  (x(end) - x(frame_idx))/(length(x) - frame_idx); 
vyy =  (y(end) - y(frame_idx))/(length(y) - frame_idx); 

vx_dt = vxx*(PUCK_SZ_M/PUCK_SZ_PX)/PERIOD; % in m/s
vy_dt = vyy*(PUCK_SZ_M/PUCK_SZ_PX)/PERIOD; % in m/s

end