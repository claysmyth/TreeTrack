original = imread('/Users/Clay/Desktop/Fisheye Correction/onPlane/on_plane_12.png');
imshow(original);
text(size(original,2),size(original,1)+15, ...
    'checkyoboard', ...
    'FontSize',7,'HorizontalAlignment','right');
scale = 0.7;
J = imresize(original, scale); % Try varying the scale factor.

theta = 30;
distorted = imrotate(J,theta); % Try varying the angle, theta.
figure, imshow(distorted)
ptsOriginal  = detectSURFFeatures(original);
ptsDistorted = detectSURFFeatures(distorted);
[featuresOriginal,   validPtsOriginal]  = extractFeatures(original,  ptsOriginal);
[featuresDistorted, validPtsDistorted]  = extractFeatures(distorted, ptsDistorted);
indexPairs = matchFeatures(featuresOriginal, featuresDistorted);
matchedOriginal  = validPtsOriginal(indexPairs(:,1));
matchedDistorted = validPtsDistorted(indexPairs(:,2));
figure;
showMatchedFeatures(original,distorted,matchedOriginal,matchedDistorted);
title('Putatively matched points (including outliers)');
[tform, inlierDistorted, inlierOriginal] = estimateGeometricTransform(...
    matchedDistorted, matchedOriginal, 'similarity');
figure;
showMatchedFeatures(original,distorted, inlierOriginal, inlierDistorted);
title('Matching points (inliers only)');
legend('ptsOriginal','ptsDistorted');
Tinv  = tform.invert.T;

ss = Tinv(2,1);
sc = Tinv(1,1);
scale_recovered = sqrt(ss*ss + sc*sc);
theta_recovered = atan2(ss,sc)*180/pi;
outputView = imref2d(size(original));
recovered  = imwarp(distorted,tform,'OutputView',outputView);
figure, imshowpair(original,recovered,'montage')