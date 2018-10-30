function [features, centroids, frame_ids, idx] = track_lines(frames, ...
    cs, rs, epsilon, minPts)

lines = struct();

for i = 1:size(frames,3)
    disp(i)
    frame = frames(:,:,i);
    c = cs(i,:);
    r = rs(i);
    if ~isnan(r)
        crop = crop_ball(frame, c, r, 1, false);
        bw = im2bw(crop, graythresh(crop));
        bw = crop_ball(bw, c, r, 2, true);
        blobs = regionprops(bw, 'Area', 'Centroid', 'MajorAxisLength', ...
            'MinorAxisLength', 'Orientation');
        lines(i).frame = find_lines(blobs, r);
    end
end

[features, frame_ids, centroids] = gen_features(lines, cs, rs);

% DBSCAN algorithm found online. Epsilon may need to be adjusted;
% represents search distance for neighbour points.
[idx, isNoise] = DBSCAN(features, epsilon, minPts);

features = features(~isNoise,:);
centroids = centroids(~isNoise,:);
frame_ids = frame_ids(~isNoise,:);
idx = idx(~isNoise);