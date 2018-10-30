function [w_avg, inv_error] = ball_spin(cs, centroids, frame_ids, idx, fps, plot_angles)

if plot_angles
    figure;
    ylim([-pi, pi])
    hold on
end

for i = unique(idx)'
    frames = frame_ids(idx == i);
    line_centroids = centroids(idx == i, :);
    line_vectors = line_centroids - cs(frames,:);
    line_angles = atan2(line_vectors(:,2),line_vectors(:,1));
    line_angles = fix_angle(line_angles);
    p = polyfit(frames, line_angles, 1);
    if plot_angles
        plot(frames, line_angles, 'LineWidth', 1, 'Color', 'k');
        plot(frames, polyval(p, frames), '--', 'LineWidth', 1, 'Color', 'k')
        xlabel('Frame'); ylabel('Angle (rad)');
        grid on;
    end
    % going to weigth the average spin based on the inverse of the error
    % divided by the number of frames
    inv_error(i) = sum(1/abs(line_angles - polyval(p,frames)))*numel(frames);
    w(i) = p(1) * fps; % rad/s
%     n_frames(i) = numel(frames);
end

w_avg = sum(w.*inv_error)/sum(inv_error);


