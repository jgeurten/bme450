% Script to track the puck in the top camera frames
close all;
clear all;

global R_MIN R_MAX

% Constants
LEFT = 90;
TOP = 290;
RIGHT = 650;
BOTTOM = 480;
THRESH = 150;
R_MIN = 40/2;
R_MAX = 80/2;
SENS = 0.8;


v = VideoReader('Side_Shot_0.MP4');
nFrames = round(v.Duration*v.FrameRate);
width = v.Width; height = v. Height; 

frame_int = read(v,261);
frame_int = frame_int( TOP:BOTTOM,LEFT:RIGHT, :); 
figure, imshow(frame_int)

c = makecform('srgb2lab');
frame_lab = rgb2lab(frame_int); 

for K = [2,4]
%     if (K == 2)
%         row = [55 200];
%         col = [155 400];
%     elseif (K == 4)
%         row = [55 130 200 280];
%         col = [155 110 400 470];
%     end
        
    if (K == 2)
        row = [55 150];
        col = [90 400];
    elseif (K == 4)
        row = [25 65 100 190];
        col = [155 110 400 470];
    end

    % Convert (r,c) indexing to 1D linear indexing.
    idx = sub2ind([size(frame_int,1) size(frame_int,2)], row, col);

    % Reshape the a* and b* channels
    ab = double(frame_lab(:,:,2:3));
    m = size(ab,1);
    n = size(ab,2);
    ab = reshape(ab,m*n,2);
    mu = zeros(K, 2);

    % Vectorize starting coordinates
    for k = 1:K
        mu(k,:) = ab(idx(k),:);
    end

    cluster_idx = kmeans(ab, K, 'Start', mu);

    % Label each pixel according to k-means
    pixel_labels = reshape(cluster_idx, m, n);
    figure
    h = imshow(pixel_labels, []);
    title(['Peppers Segmented With K-Means and K = ', num2str(K)]);
    colormap('jet')
    saveas(gcf, ['peppers_k_means_', num2str(K),'.png']);
end

imshow(pixel_labels,[])
title('Image Labeled by Cluster Index');