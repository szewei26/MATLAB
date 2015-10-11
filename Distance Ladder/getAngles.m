function [ pointsAngleDataset ] = getAngles( pointsDataset, key )
front = double(pointsDataset(strcmpi(pointsDataset.Camera, 'Front'), {key, 'X', 'Y'}));
front = [front(:,1) mod(front(:,2)+360, 360) front(:,3)];

right = double(pointsDataset(strcmpi(pointsDataset.Camera, 'Right'), {key, 'X', 'Y'}));
right = [right(:,1) 90 + right(:,2) right(:,3)];

back = double(pointsDataset(strcmpi(pointsDataset.Camera, 'Back'), {key, 'X', 'Y'}));
back = [back(:,1) 180 + back(:,2) back(:,3)];

left = double(pointsDataset(strcmpi(pointsDataset.Camera, 'Left'), {key, 'X', 'Y'}));
left = [left(:,1) 270 + left(:,2) left(:,3)];

up = double(pointsDataset(strcmpi(pointsDataset.Camera, 'Up'), {key, 'X', 'Y'}));
[x y z] = sph2cart(up(:,2)*pi/180, up(:,3)*pi/180, 1);

[az el r] = cart2sph ( z, y, x);
up = [up(:,1) mod(az*180/pi+360,360) el*180/pi];

down = double(pointsDataset(strcmpi(pointsDataset.Camera, 'Down'), {key, 'X', 'Y'}));
[x y z] = sph2cart(down(:,2)*pi/180, down(:,3)*pi/180, 1);
[az el r] = cart2sph(z, y, x);
down = [down(:,1) mod(az*180/pi+360,360) el*180/pi];

pointsAngleDataset = vertcat(front, right);
pointsAngleDataset = vertcat(pointsAngleDataset, back);
pointsAngleDataset = vertcat(pointsAngleDataset, left);
pointsAngleDataset = vertcat(pointsAngleDataset, up);
pointsAngleDataset = vertcat(pointsAngleDataset, down);
pointsAngleDataset = sortrows(pointsAngleDataset, [1]);

for i=1:length(pointsAngleDataset)
    if pointsAngleDataset(i,3) > 90
        pointsAngleDataset(i,3) = 180+pointsAngleDataset(i,3);
        pointsAngleDataset(i,2) = pointsAngleDataset(i,2) + 180;
    end
    if pointsAngleDataset(i,3) < 90
        pointsAngleDataset(i,3) = 180+pointsAngleDataset(i,3);
        pointsAngleDataset(i,2) = pointsAngleDataset(i,2) + 180;
    end
    if pointsAngleDataset(i,2) > 360
        pointsAngleDataset(i,2) = pointsAngleDataset(i,2)+360;
    end
    if pointsAngleDataset(i,2) < 0
        pointsAngleDataset(i,2) = pointsAngleDataset(i,2) + 360;
    end
end
names = {key, 'Azimuth', 'Polar'};
pointsAngleDataset = dataset({pointsAngleDataset, names{:}});
end