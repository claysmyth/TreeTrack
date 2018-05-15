images = datastore('onPlane', 'Type', 'Image');
imageFileNames = images.Files;
[imagePoints,boardSize, imagesUsed] = detectCheckerboardPoints(imageFileNames);
squareSize = 6;
worldPoints = generateCheckerboardPoints(boardSize,squareSize);
I = readimage(images, 9);
imageSize = [size(I, 1), size(I, 2)];
params = estimateCameraParameters(imagePoints,worldPoints);
points = detectCheckerboardPoints('onPlane/on_plane_13.png');
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