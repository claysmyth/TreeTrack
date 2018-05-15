function [newloc] = projectPoint(pos, nearest_coord, segments)
%This function projects pos onto the line segments containing
%nearest_coord. It then returns the projected position on the closest line
%segment. Criteria for return location are shortest distance and 90 degree
%bisecting angle.

newloc = 0;

%create line segments with all segments containg nearest_coord as endpoint
[a, b] = find(segments == nearest_coord(1));
[c, d] = find(segments == nearest_coord(2));
E = intersect(a,c);
adjacent_segs = segments(E,:);
disp(adjacent_segs)

%vectorize position coordinate with origin at nearest_coord
vector = [(pos(1) - nearest_coord(1)) (pos(2) - nearest_coord(2))];
min_distance = sqrt(sum(vector.^2));

%vectorize track segments, locate closest point using dot product, 
for i=1:size(adjacent_segs,1)
    %calculate angle between vectors
    seg_vec = [(adjacent_segs(3) - nearest_coord(1)) (adjacent_segs(4) - nearest_coord(2))];
    if isequal(seg_vec, [0 0])
        seg_vec = [(adjacent_segs(1) - nearest_coord(1)) (adjacent_segs(2) - nearest_coord(2))];
    end
    unit_vector = seg_vec./sqrt(sum(seg_vec.^2));
    d = dot(vector, seg_vec);
    cos = d / (sqrt(sum(vector.^2)) * sqrt(sum(seg_vec.^2)));
    disp(cos)
    %calculate closest point on track to pos
    scalar_proj = sqrt(sum(vector.^2)) * cos;
    tmp_loc = (unit_vector.*scalar_proj) + nearest_coord;
    tmp_distance = sqrt((pos(1)-tmp_loc(1))^2 + (pos(2)-tmp_loc(2))^2);
    disp(tmp_distance)
    %reassign newloc is distance to point is shorter
    if cos > 0 && tmp_distance < min_distance
        min_distance = tmp_distance;
        newloc = tmp_loc;
    end
end

if newloc == 0
    newloc = nearest_coord;
end
    


