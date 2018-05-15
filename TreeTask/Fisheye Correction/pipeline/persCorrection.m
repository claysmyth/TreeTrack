%Corrects perspective distortion
%Inputs: cameraParameters object, worldPoints
%Outputs: camera coordinates of checkerboard

function d = persCorrection(params, worldPoints, newOrigin, imageFileNames)
depthPoints = zeros(size(worldPoints(:,1), 1), size(worldPoints(1,:), 2) + 1, size(imageFileNames,2));
world3D = [worldPoints zeros(size(worldPoints,1),1)];
for m = 1:size(imageFileNames,2)
    if m ~= 4
        [im, newOrigin1] = undistortImage(imread(imageFileNames{m}), params);
        undistortedPoints = detectCheckerboardPoints(im);
%         points = detectCheckerboardPoints(imageFileNames{m});
%         undistortedPoints = undistortPoints(points, params);
%          undistortedPoints = [undistortedPoints(:,1) - newOrigin(1), ...
%                          undistortedPoints(:,2) - newOrigin(2)];
        [rotationMatrix, translationVector] = extrinsics(...
            undistortedPoints,worldPoints,params);
        for n = 1:15
            depthPoints(n,:,m) = world3D(n,:)*rotationMatrix ...
                + translationVector;
        end
%         for n = 1:15
%             depthPoints(n,:,m) = [world3D(n,:) 1]*[rotationMatrix; ...
%                 translationVector];
%         end
    end
end
d = depthPoints;
