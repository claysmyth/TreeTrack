[imagePoints, boardSize] = detectCheckerboardPoints('onPlane/on_plane_3.png');
imshow('onPlane/on_plane_3.png');
hold on;
plot(imagePoints(:,1,1),imagePoints(:,2,1),'ro');