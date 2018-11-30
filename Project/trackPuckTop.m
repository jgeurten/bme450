% Script to track the puck in the top camera frames
close all; 
clear all; 

global R_MIN R_MAX

% Constants
LEFT = 125; 
TOP = 30;
BOTTOM = 390; 
THRESH = 150; 
R_MIN = 40/2;
R_MAX = 80/2; 
SENS = 0.8; 

v = VideoReader('Top_Shot0.MP4'); 
nFrames = round(v.Duration*v.FrameRate); 

% Get the position of the plex-glass to bound the puck search algo
first_frame = read(v, 1); 
lab_frame = rgb2lab(first_frame); 
ycrcb_frame = rgb2ycbcr(first_frame); 

figure, imshow(first_frame(TOP:BOTTOM, LEFT:end,:))
%saveas(gcf, 'top_frame.png'); 

[centers, radii] = imfindcircles(first_frame(TOP:BOTTOM, LEFT:end,:),[R_MIN R_MAX],...
    'ObjectPolarity','dark');%,'Sensitivity', SENS);
viscircles(centers, radii,'LineStyle','--');

fiducial_centers = trackFiducials(first_frame(TOP:BOTTOM, LEFT:end,:), radii, centers); 

stop 

vertical_ = imfilter(first_frame(:,:,2), [-3 0 3]); 
horizontal_ = imfilter(first_frame(:,:,2), [-3 0 3]'); 
vertical_edges = medfilt2(vertical_, [5 5]); 
horizontal_edges = medfilt2(horizontal_, [5 5]); 
vertical_edges = vertical_edges.*10; 
horizontal_edges = horizontal_edges.*10; 

figure, imshow(vertical_edges, [])
figure, imshow(horizontal_edges, [])