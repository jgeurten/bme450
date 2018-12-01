% Calculate the final puck position (global space)
clear all;
close all;

% Constants
SENS = 27.5;
ADDI = 50;
AREA = 500;
THRESH = 2000; % threshold for difference operator
PUCK_MIN_AREA = 100;
MED_FILT_SIZE = 7;

%disp('Cropping Final Position Video ...')
v = VideoReader('Shot_0.MP4');
nFrames = round(v.Duration*v.FrameRate);

% Get the position of the 'goal' posts
first_frame = read(v, 1);
lab_frame = rgb2lab(first_frame);
ycrcb_frame = rgb2ycbcr(first_frame);

disp('Locating the Net ...');

vertical_posts = imfilter(ycrcb_frame(:,:,3), [-1 0 1]);
vertical_posts = vertical_posts.*SENS;
vertical_posts = vertical_posts( 10:550, 160:1100);

horizontal_posts = imfilter(ycrcb_frame(:,:,3), [-1 0 1]');
horizontal_posts = horizontal_posts.*SENS;
horizontal_posts = horizontal_posts( 10:550, 160:1100);

posts = im2bw(horizontal_posts + vertical_posts);
figure, imshow(posts)

len = length(vertical_posts);

[left_r,left_c] = find(posts(:, 1:200) ~= 0);
[right_r,right_c] = find(posts(:,len-300:len -101) ~= 0);
left = min(left_c) + 160;
right = max(right_c) + len-101;
bottom = max(max(right_r), max(left_r));

MID_HOR = bottom/2;
MID_VERT = (left+right)/2;

% Get the 'X' on the goal:
crosses = im2bw(ycrcb_frame(:,:,3));
crosses = imcomplement(crosses(10:bottom, left:right));
figure, imshow(crosses);
Cross_Regions = regionprops(crosses, {'Centroid', 'Area', 'BoundingBox'});


for k = 1 : length(Cross_Regions)
    if(Cross_Regions(k).Area > AREA)
        thisBB = Cross_Regions(k).BoundingBox;
        rectangle('Position', [thisBB(1),thisBB(2),thisBB(3),thisBB(4)],...
        'EdgeColor','r','LineWidth',2 )
        if(Cross_Regions(k).Centroid(2) > MID_HOR)
            bottom_left = Cross_Regions(k);
        elseif(Cross_Regions(k).Centroid(1) > MID_VERT)
            right_corner = Cross_Regions(k);
        else
            left_corner = Cross_Regions(k);
        end
    end
end


% Find the puck contact location
red_frames = zeros(v.Height, v.Width, round(v.Duration*v.FrameRate), 'uint8');
green_frames = zeros(v.Height, v.Width, round(v.Duration*v.FrameRate), 'uint8');
blue_frames = zeros(v.Height, v.Width, round(v.Duration*v.FrameRate), 'uint8');
count = 1;

disp('Locating the Puck ...');

for i = 1:nFrames -10
%     frames(:, :, count) = rgb2gray(readFrame(v));
    testFrames = read(v, i);
    red_frames(:,:,i) = testFrames(:,:,1);
    green_frames(:,:,i) = testFrames(:,:,2);
    blue_frames(:,:,i) = testFrames(:,:,3);
end

% Calculate first differences
%diff_frames_red = zeros(size(red_frames),'uint8');
diff_frames_green = zeros(size(green_frames), 'uint8');
% diff_frames_blue = zeros(size(blue_frames), 'uint8');

for i = 1:size(diff_frames_green, 3) - 1
   % diff_frames_red(:,:, i) = red_frames(:, :,i+1) - red_frames(:,:,i);
    diff_frames_green(:,:, i) = green_frames(:, :,i+1) - green_frames(:,:,i);
%     diff_frames_blue(:,:, i) = blue_frames(:, :,i+1) - blue_frames(:,:,i);
end


% Get Impact location by looking in the corners
T = left_corner.BoundingBox(1);
B = left_corner.BoundingBox(2);
L = left_corner.BoundingBox(3);
R= left_corner.BoundingBox(4);

sums_red = [];
sums_green = [];
sums_blue = [];
for i = 1:size(diff_frames_green,3)
%     sums_red(i) = sum(sum(diff_frames_red(90:170,240:310,i)));
    sums_green(i) = sum(sum(diff_frames_green(90:170,240:310,i)));
%     sums_blue(i) = sum(sum(diff_frames_blue(90:170,240:310,i)));
end

figure, plot(sums_green)
impact_frameN = find(sums_green > THRESH, 1);
impact_frame = read(v,impact_frameN);

impact_diff = diff_frames_green(:,:,impact_frameN); %*SENS;
bw_filt_impact = medfilt2(impact_diff,[MED_FILT_SIZE MED_FILT_SIZE]);
bw_filt_impact = bw_filt_impact*SENS;

bw_impact = im2bw(bw_filt_impact);

Potential_Regions = regionprops(bw_impact, {'Centroid', 'Area', 'BoundingBox'});

%Remove regions < Puck min area
for i = 1:length(Potential_Regions)
    if(Potential_Regions(i).Area > PUCK_MIN_AREA)
        PUCK_REGION = Potential_Regions(i);
    end
end

figure, imshow(impact_frame)
rectangle('Position', [PUCK_REGION.BoundingBox(1),PUCK_REGION.BoundingBox(2),...
    PUCK_REGION.BoundingBox(3),PUCK_REGION.BoundingBox(4)],  'EdgeColor','r','LineWidth',2 )

puck_centroid = PUCK_REGION.Centroid;
