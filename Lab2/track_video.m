function track_video(filename, frames, c, r, centroids, frame_ids, idx)

figure;
for i = 1:size(frames,3)
    imshow(frames(:,:,i))
    hold on
    plot_circle(c(i,:) ,r(i), 1.5);
    if numel(find(frame_ids == i)) > 0
        line_centroids = centroids(frame_ids == i,:);
        line_ids = idx(frame_ids == i);
        for j = 1:size(line_centroids,1)
            text(line_centroids(j,1), line_centroids(j,2), ...
                num2str(line_ids(j)), 'HorizontalAlignment', 'center', ...
                'Color', 'w');
        end
    end
    hold off
    F(i) = getframe(gcf);
end
close(gcf);

v = VideoWriter(filename);
open(v)
writeVideo(v,F);
close(v)