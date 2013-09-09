function coords = getcoord_ctrack(directoryname,pos,index)
%this program is called by CREATETASKSTRUCT to produce the trajectory
%coodinates for a C-track.
%
% created by David Soleimani-Meigooni 2012-4-16
%
%23 locations need to be clicked in the following order, where the vertical
%pipe represents the physical divider in the C-track. Position 1 should
%start to the immediate left of the barrier. The click numbers associated
%with each eighth of the C-track are shown in the map below, and clicking
%should continue until the 23rd clinc is made to the immediate right of the
%physical barrier.
%   
%                      1  | 23
%                    /        \
%                   3          21
%                  /            \
%                 6              18         
%                  \            /
%                   9         15
%                     \      /
%                        12
%
% Red guidelines can be used to evenly space the 23 points.
%

numpoints = 23;

fid = figure; fax = gca;
[xcenter, ycenter, rho] = findcircle(pos);
hold on;


plot(pos(:,2)-xcenter,pos(:,3)-ycenter);
drawspokes(fax, (numpoints+2), rho);
[x,y] = ginput(numpoints);
tmplincoord{1} = [x(1:numpoints) y(1:numpoints)];
lincoord{1}(:,1) = tmplincoord{1}(:,1)+xcenter;
lincoord{1}(:,2) = tmplincoord{1}(:,2)+ycenter;
    
numtimes = size(pos,1);
for i = 1:length(lincoord)
    coords{i} = repmat(lincoord{i},[1 1 numtimes]);
end
close(fid);

%--------------------------------------------
function drawspokes(currentaxes, n, rho)
hold on;
theta =[0:(2*pi/n):2*pi];
for th = theta
    polar(currentaxes, [th th],[0 rho], 'r');
end

%-------------------------------------------
function [xcenter, ycenter, rho] = findcircle(coords)
xcenter = (max(coords(:,2))+min(coords(:,2)))/2;
ycenter = (max(coords(:,3))+min(coords(:,3)))/2;
rho = (max([xcenter ycenter]))/2;