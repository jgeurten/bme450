function centroids = sortblobs(blobs)

area_thresh = 1000; 
centroids = []; 
potential_blobs = []; 
for i = 1:length(blobs)
    if(blobs(i).Area > area_thresh)
        %remove the top of puck fiducials
        if(blobs(i).MajorAxisLength < blobs(i).MinorAxisLength*3)
            potential_blobs = [potential_blobs; i]; 
        end
    end
end

if(length(potential_blobs > 0))
    for i = 1:length(potential_blobs)
        centroids = [centroids; blobs(potential_blobs(i)).Centroid]; 
    end
else
    centroids = [999, 999];
end


end