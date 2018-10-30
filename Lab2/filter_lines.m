function lines = find_lines(blobs, radius)

area = extractfield(blobs, 'Area')./radius^2; % normalized area
maj = extractfield(blobs, 'MajorAxisLength');
min = extractfield(blobs, 'MinorAxisLength');
ratio = maj./min;

% values for good line blobs.
lines = blobs(area >= 0.02 & area <= 0.06 & ratio >= 3 & ratio <= 5);