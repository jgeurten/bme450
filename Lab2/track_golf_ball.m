function [w_in, w_out, vx_in, vx_out, vy_in, vy_out] = track_golf_ball(shot_path)
% 
% clc
% clear
% close all
% 
% shot = './shots/oblique_angle/shot1.wmv';
shot = shot_path; 
fps = 30000;
videoTrack = true;

%% process video frames
disp('Processing frames...')
v = VideoReader(shot);
frames = zeros(v.Height, v.Width, round(v.FrameRate*v.Duration), 'uint8');
count = 1;
while hasFrame(v)
    frames(:, :, count) = rgb2gray(readFrame(v));
    count = count + 1;
end

%% velocity tracking

% imshow(frames(:, :, 1))
% [~] = imdistline;

ballR = 172/2; % ball radius estimate in px
tolerance = 2; % tolerance on ball radius
sensitivity = 0.99; % sensitivity to find ball circle

disp('Tracking ball velocity...')
[c, r] = fit_circles(frames, ballR, tolerance, sensitivity);

% use numerical differentiation to find time of impact
[~, impact_id] = min(abs(gradient(c(:,2))));

% buffer to remove impact frames (likely poor circle fits because of ball
% compression)
impact_buffer = 5;

inbound = frames(:, :, 1:impact_id - 5);
outbound = frames(:, :, impact_id + 5:end);
c_in = c(1:impact_id - 5, :);
c_out = c(impact_id + 5:end, :);
r_in = r(1:impact_id - 5);
r_out = r(impact_id + 5:end);

% mean ball radius in px
r_avg = mean([r_in(~isnan(r_in)); r_out(~isnan(r_out))]); 

[vx_in, vy_in] = ball_vel(c_in, r_avg, fps);
[vx_out, vy_out] = ball_vel(c_out, r_avg, fps);

disp(['vx_in: ' num2str(vx_in) ' m/s'])
disp(['vx_out: ' num2str(vx_out) ' m/s'])
disp(['vy_in: ' num2str(vy_in) ' m/s'])
disp(['vy_out: ' num2str(vy_out) ' m/s'])

%% spin tracking

disp('Tracking spin...')

% find lines
lines_in = find_lines(inbound, c_in, r_in);
lines_out = find_lines(outbound, c_out, r_out);

% generate line features
[feat_in, frame_ids_in, centroids_in] = gen_features(lines_in, c_in, r_in);
[feat_out, frame_ids_out, centroids_out] = gen_features(lines_out, c_out, r_out);

% parameters used for feature clustering
epsilon = 0.2;
min_pts = 3;

% cluster features for line identification and tracking
[line_ids_in, noise_in] = DBSCAN(feat_in, epsilon, min_pts);
[line_ids_out, noise_out] = DBSCAN(feat_out, epsilon, min_pts);

% remove noisy data points
feat_in = feat_in(~noise_in, :);
centroids_in = centroids_in(~noise_in, :);
frame_ids_in = frame_ids_in(~noise_in);
line_ids_in = line_ids_in(~noise_in);

feat_out = feat_out(~noise_out, :);
centroids_out = centroids_out(~noise_out, :);
frame_ids_out = frame_ids_out(~noise_out);
line_ids_out = line_ids_out(~noise_out);

% estimate spin, plot spin fits by setting last arguement == true
w_in = ball_spin(c_in, centroids_in, frame_ids_in, line_ids_in, fps, 1);
w_out = ball_spin(c_out, centroids_out, frame_ids_out, line_ids_out, fps, 1);

disp(['w_in: ' num2str(w_in) ' rad/s']);
disp(['w_out: ' num2str(w_out) ' rad/s']);

%% tracking video
if videoTrack
    track_video('test_in', inbound, c_in, r_in, centroids_in, ...
            frame_ids_in, line_ids_in);
    track_video('test_out', outbound, c_out, r_out, centroids_out, ...
            frame_ids_out, line_ids_out);
end
