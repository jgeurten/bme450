root = [pwd, '\side_puck\']; 
files = dir(root); 
HEIGHT = 512;
WIDTH = 682; 
frames = zeros(HEIGHT, WIDTH, 3 , 'uint8');
count = 1; 
for i = 1:length(files) %10 %test file to use (easy to find contour)
    if(files(i).bytes == 0) % skip non images
        continue
    end
    
    figure, hold on     
    img = imread([root, files(i).name]);
    img = imresize(img, 0.333); 
    frames(:, :, count) = rgb2gray(img); 

    bw_img = im2bw(img); 
    
    %Take LaPlacian to get edges
    
    blobs = regionprops(bw_img, 'Area', 'Centroid', 'MajorAxisLength', ...
            'MinorAxisLength', 'Orientation');
    com = sortblobs(blobs);
    imshow(img); 
    for j = 1:size(com,1)
        com_img = insertShape(img,'circle',[com(j,1) com(j,2) 2],'LineWidth',5, 'Color', 'blue');
        imshow(com_img); 
    end
    count = count + 1; 
end

