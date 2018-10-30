function [ball] = cropBall(frame, c, r, tol, bw_pattern)

ball = uint8(zeros(size(frame)));
% ball(:,:) = 255;

for k = 1:numel(frame)
    [I,J] = ind2sub(size(frame),k);
    dist = sqrt((I-c(2))^2 + (J-c(1))^2);
    if dist < r-tol
        if bw_pattern
            if frame(I,J) == false
                ball(I,J) = 255;
            else 
                ball(I,J) = 0;
            end
        else
            ball(I,J) = frame(I,J);
        end
    end
end

if bw_pattern
    ball = im2bw(ball);
end