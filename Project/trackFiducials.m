function [fiducial_centers] = trackFiducials(frame, radii, centers)
% close all;
% v = VideoReader('Top_Shot0.MP4');
%
% frame = read(v, 367);
% radii = 32.35;
% centers = [305.96 187.08];

% frame = read(v, 1);
% radii = 29.3398;
% centers = [154.46 172.30];

LEFT = 125;
TOP = 30;
BOTTOM = 390;
% frame = frame(TOP:BOTTOM, LEFT:end,:);

fiducial_centers = [];

% Assumes only one set of centers and radii are passed in

R_MIN = 40/2;
R_MAX = 120/2;
MIN_FID_AREA = R_MIN^2*pi;
MAX_FID_AREA = R_MAX^2*pi;

%Imresize = 8
% R_MIN = 80/2;
% R_MAX = 120/2;

OFFSET = 0;
SENS = 0.80;

radii = radii + OFFSET;
% Bounding box:
cx = centers(1); cy = centers(2);
left = cx - radii; width = radii*2;
top = cy - radii; height = radii*2;

figure, imshow(frame);
rectangle('Position', [left, top, width, height],...
        'EdgeColor','r','LineWidth',2 )

puck = frame(top:top+height, left:left+width,:);
puck = imresize(puck, 4);
puck_blur = imgaussfilt(puck, 3);
figure, imshow(puck_blur)
[fid_centers, fid_radii] = imfindcircles(puck_blur,[R_MIN R_MAX],...
    'ObjectPolarity','bright','Sensitivity', SENS); %,'Method', 'twostage');
viscircles(fid_centers, fid_radii,'LineStyle','--');
fiducial_centers = [fiducial_centers; fid_centers];

% If less than 2 fiducials are found convert to LAB space to get red (red usually fails):
if(length(fid_radii) < 2)
    lab = rgb2lab(puck_blur);
    %l_channel = lab(:,:,1);
    %b_channel = lab(:,:,3);

    a_channel = lab(:,:,2);
    a_channel = medfilt2(a_channel, [9 9]);
    a_bw = im2bw(a_channel);
   % figure, imshow(a_bw);
    FID = regionprops(a_bw, {'Centroid', 'Area', 'BoundingBox'});
    for i = 1:length(FID)
        if(FID(i).Area > MIN_FID_AREA && FID(i).Area < MAX_FID_AREA  )
            fiducial_centers = [fiducial_centers; FID(i).Centroid];
        end
    end

end

RGB = insertMarker(puck_blur,fiducial_centers);
figure, imshow(RGB)

end
