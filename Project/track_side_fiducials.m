function vz_out = track_side_fiducials(frames)

coms = []; 
FPS = 240; 
MET_per_PX = 76/1000/320; % 76mm/320 pxthis is measured manually
for i = 1:size(frames, 3) %10 %test file to use (easy to find contour)
    if(size(frames,1) == 0) % skip non images
        continue
    end
    img = frames(:,:,i); 
    figure, hold on     
    bw_img = im2bw(img); 
    
    blobs = regionprops(bw_img, 'Area', 'Centroid', 'MajorAxisLength', ...
            'MinorAxisLength', 'Orientation');
    com = sortblobs(blobs);
    coms = [coms; com]; 
    imshow(img); 
    for j = 1:size(com,1)
        com_img = insertShape(img,'circle',[com(j,1) com(j,2) 2],'LineWidth',5, 'Color', 'blue');
        imshow(com_img); 
    end
    
end

% Get velocity of the COMs using linear fitting:
time_idxs = find(~(coms(:,1) == 999));

fitType = 'poly1'; %using linear fitting 'poly2'
px = fit(time_idxs, coms(:,1), fitType);   % this can be compared to the top view camera derived px
pz = fit(time_idxs, coms(:,2), fitType); 

% Multiply slope by meters/pixels * fps == m/s
dpz_dframe = pz.p1; 
vz_out = dpz_dframe*MET_per_PX*FPS; 
end