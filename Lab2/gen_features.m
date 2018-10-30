function [features, frame_ids, centroids] = gen_features(lines, c, r)

% features matrix (rows are data points)
% c and r are ball center and radius for each frame
m = 1; % data point id
for i = 1:numel(lines)
    if ~isempty(lines(i).frame)
        for j = 1:numel(lines(i).frame)        
            % frame_ids
            frame_ids(m,1) = i;

            % normalized area
            features(m,1) = lines(i).frame(j).Area/r(i)^2; 

            % normalized distance from centroid to ball center
            centroids(m,:) = lines(i).frame(j).Centroid;
            features(m,2) = sqrt((centroids(m,1)-c(i,1))^2 + ...
                (centroids(m,2)-c(i,2))^2)/r(i); 
            
            % centroid position (small changes frame to frame should
            % generate good features)
            features(m,3) = centroids(m,1)/r(i);
            features(m,4) = centroids(m,2)/r(i);

            % maj/min
            features(m,5) = lines(i).frame(j).MajorAxisLength/...
                lines(i).frame(j).MinorAxisLength;

            % orientation (small changes frame to frame should generate good clusters)
            features(m,6) = lines(i).frame(j).Orientation/180*pi;

            m = m + 1;
        end
    end
end



        
        