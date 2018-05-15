function [statematrix, segmenttable, trajwells, wellSegmentInfo, segmentInfo] = linearizePosition_tree(directoryname,fileprefix, index, varargin)

% Variable declarations would go here
%Do I need all those inputs??

dsz = '';
if (index(1) < 10)
   dsz = '0';
end

%load the data
eval(['load ',directoryname,fileprefix,'pos', dsz, num2str(index(1)), '.mat']);
eval(['pos = ',lowercasethree,'pos;'])
eval(['load ',directoryname,fileprefix,'task',dsz, num2str(index(1)), '.mat']);
eval(['task = ',lowercasethree,'task;'])

[points, segmentInfo, coords] = getCoord_tree(directoryname,pos,index,vidframe,cmperpix)


tmpDistance = 10000;
closestCoord = coords(1,:);
proj_locs = zeros(size(pos));
for i = 1:size(pos,1)
    %find closest coord
    for n = 1:size(coords,1)
        distace = sqrt((pos(i,1) - coords(n,1))^2 + 
                        (pos(i,2) - coords(n,2))^2);
        if distance < tmpDistance
            tmpDistance = distance;
            closestCoord = coords(n,:);
        end
    end
    proj_locs(i,:) = projectPoint(pos(i,:), closestCoord, segmentInfo.segmentCoords);
        
    
    
    
function closest_Segment = findSegment(
    
    