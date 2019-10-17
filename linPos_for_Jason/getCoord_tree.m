function [treetask] = getCoord_tree(trackImage, name)

%coodinates for a wtrack.
%Click locations on trackImage in the following order:
% %              1
%      6         |         11
%       \        |        /
%        3-------2-------4
%       /        |        \
%      7         |         10
%                |
%                5
%               / \
%              8   9
%  name = desired name of output file

fid = figure;
% if exist('vidframe','var')
%     %plot image and flip l/r
%     image(vidframe)
%     set(gca,'YDir','normal') %flips both image and axis u/d to align with pos recon coordinates
%     hold on
%     plot((pos(:,2)/cmperpix(index(2))),(pos(:,3)/cmperpix(index(2))), ':'); 
% else
%     plot(pos(:,2),pos(:,3));
% end

imshow(trackImage)

[x,y] = ginput(11);

treetask.coords = [x,y];

segmentCoords = [x(1) y(1) x(2) y(2);
                x(2) y(2) x(3) y(3);
                x(2) y(2) x(4) y(4)
                x(2) y(2) x(5) y(5);
                x(3) y(3) x(6) y(6)
                x(3) y(3) x(7) y(7)
                x(5) y(5) x(8) y(8)
                x(5) y(5) x(9) y(9)
                x(4) y(4) x(10) y(10)
                x(4) y(4) x(11) y(11)];
            
treetask.segmentCoords = segmentCoords;


%%%% Must order the first well of each trajectory so they get assigned 1-6
% from left to right (also remember axis is flipped vertically)
%%%% This is all possible trajectories in one direction
%%%% Convention is to order the trajectories from lowest # well to highest
traj{1} = [x([1 2]) y([1 2])];      % 1 to 2 %no skips
traj{2} = [x([2 3 6]) y([2 3 6])];      % 2 to 3 
traj{3} = [x([2 3 7]) y([2 3 7])];    % 3 to 4
traj{4} = [x([2 5 8]) y([2 5 8])];  % 4 to 5
traj{5} = [x([2 5 9]) y([2 5 9])];  % 5 to 6
traj{6} = [x([2 4 10]) y([2 4 10])];  % 1 to 3 %skip 1
traj{7} = [x([2 4 11]) y([2 4 11])]; % 2 to 4
% traj{8} = [x([3 9 10 11 5]) y([3 9 10 11 5])]; % 3 to 5
% traj{9} = [x([4 10 11 12 6]) y([4 10 11 12 6])]; % 4 to 6
% traj{10} = [x([3 9 10 11 12 6]) y([3 9 10 11 12 6])]; % 3 to 6 (home to outer) % skip 2
% traj{11} = [x([1 7 8 9 10 4]) y([1 7 8 9 10 4])]; % 1 to 4 (outer to home)
% traj{12} = [x([2 8 9 10 11 5]) y([2 8 9 10 11 5])]; % 2 to 5
% traj{13} = [x([1 7 8 9 10 11 5]) y([1 7 8 9 10 11 5])]; % 1 to 5  % skip 3
% traj{14} = [x([2 8 9 10 11 12 6]) y([2 8 9 10 11 12 6])]; % 2 to 6  % skip 3
% traj{15} = [x([1 7 8 9 10 11 12 6]) y([1 7 8 9 10 11 12 6])]; % 1 to 6 (outer to outer, rat actually does this a lot)

treetask.linearcoord = traj;

save(name, '-struct', 'treetask');
% numtimes = size(pos,1);
% for i = 1:length(traj)
%     if exist('M','var')
%     coords{i} = repmat(traj{i}*cmperpix,[1 1 numtimes]);
%     else
%         coords{i} = repmat(traj{i},[1 1 numtimes]);
%     end
% end
close(fid);