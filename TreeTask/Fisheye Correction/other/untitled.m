[imagePoints,boardSize] = detectCheckerboardPoints(plane.png);
squareSize = 150;
worldPoints = generateCheckerboardPoints(boardSize,squareSize);
I = imread(plane.png);
imageSize = [size(I, 1), size(I, 2)];
params = estimateCameraParameters(imagePoints,worldPoints, ...
                                  'ImageSize',imageSize);
points = detectCheckerboardPoints(plane.png);
undistortedPoints = undistortPoints(points,params);
[J, newOrigin] = undistortImage(I,params,'OutputView','full');
undistortedPoints = [undistortedPoints(:,1) - newOrigin(1), ...
                    undistortedPoints(:,2) - newOrigin(2)];
figure;
imshow(I);
hold on;
plot(points(:,1),points(:,2),'r*-');
title('Detected Points');
hold off;

figure;
imshow(J);
hold on;
plot(undistortedPoints(:,1),undistortedPoints(:,2),'g*-');
title('Undistorted Points');
hold off;