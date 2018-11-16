root = pwd; 
files = dir('puck_w_fiducials'); 
cd puck_w_fiducials
for i = 1:length(files) %10 %test file to use (easy to find contour)
    if(files(i).bytes == 0) % skip non images
        continue
    end
    
    figure,     
    img = imread(files(i).name);
    img = imresize(img, 0.333); 
    bw_img = rgb2gray(img); 
    [centers,radii] = imfindcircles(bw_img,[35 70],'ObjectPolarity','bright', ...
    'Sensitivity', .965); 
    %Sensitivity sets the internal threshold. Greater threshold = more cirs
    imshow(img); 
    viscircles(centers,radii);

end

%If two circles found, with similar radii, the intersection of the circles
% represent the puck


cd(root)