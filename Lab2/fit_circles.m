function [centers, radii] = fitCircles(frames, ballR, tol, sens)

centers = zeros(size(frames, 3), 2);
radii = zeros(size(frames, 3), 1);

rRange = [round(ballR-tol), round(ballR+tol)];

for i = 1:size(frames,3)
    [c, r] = imfindcircles(frames(:,:,i), rRange, 'Sensitivity', sens);
    if numel(r) > 0
        centers(i,:) = c(1,:);
        radii(i) = r(1);
    else
        centers(i,:) = [NaN, NaN];
        radii(i) = NaN;
    end
end
