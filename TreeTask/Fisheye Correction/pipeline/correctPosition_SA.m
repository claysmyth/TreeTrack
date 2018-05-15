function [correctedPos] = correctPosition_SA(posData)
%Recieves position data structure from raw position file
%takes median of the two x,y positions and corrects position with San
%Anselmo Pixel map

posData = load(posData);
posData = posData.data.fields;
pixelMap = load('SA_pixelMap.mat');
pixelMap = pixelMap.pixelMap;
correctedPos = zeros(size(posData(1).data,1),2);

originalImage = imread('/Users/Clay/Desktop/lin_pos/Fisheye Correction/pipeline/onPlane/on_plane_6.png');
imshow(originalImage)
hold on
plot(posData(4).data(1:52000), posData(5).data(1:52000), 'g*');

for i = 1:size(posData(1).data,1)
    midX = (posData(2).data(i) + posData(4).data(i))/2;
    midY = (posData(3).data(i) + posData(5).data(i))/2;
    temp = [midX midY];
    if find(~temp)
        temp(find(~temp)) = temp(find(~temp)) + 1;
        correctedPos(i,:) = squeeze(pixelMap(temp(1), temp(2), :))';
    else
        correctedPos(i,:) = squeeze(pixelMap(midX, midY, :))';
    end
end

figure
final = imread('finalImage.png');
imshow(final);
hold on
plot(correctedPos(1:52000, 1), correctedPos(1:52000, 2), 'g*');