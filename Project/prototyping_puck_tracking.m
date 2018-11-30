root = [pwd, '\data\']; 
files = dir(root); 

for i = 1:length(files) %10 %test file to use (easy to find contour)
    if(files(i).bytes == 0) % skip non images
        continue
    end
    
    figure,     
    img = imread([root, files(i).name]);
    img = imresize(img, 0.333); 
    bw_img = rgb2gray(img); 
    %THIS IS FOR TOP VIEW:
    [center,radius] = imfindcircles(bw_img,[100 200],'ObjectPolarity','dark', ...
    'Sensitivity', .98); 
    
%     if size(center,1) > 1
%         %If two circles found, with similar radii, the intersection of the circles
%         % represent the puck
%         [center, radius] = solve_circular_intersection(center, radius); 
%     end
    
    imshow(img); 
    viscircles(center,radius);

end


