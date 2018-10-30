function lines = find_lines(frames, cs, rs)

lines = struct();

for i = 1:size(frames,3)
    frame = frames(:,:,i);
    c = cs(i,:);
    r = rs(i);
    if ~isnan(r)
        crop = crop_ball(frame, c, r, 1, false);
        bw = im2bw(crop, graythresh(crop));
        bw = crop_ball(bw, c, r, 2, true);
        blobs = regionprops(bw, 'Area', 'Centroid', 'MajorAxisLength', ...
            'MinorAxisLength', 'Orientation');
        lines(i).frame = filter_lines(blobs, r);
    else 
        lines(i).frame = [];
    end
end