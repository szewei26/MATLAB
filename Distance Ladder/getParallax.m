function [ parallaxDataset ] = getParallax( pointsDataset, error)
points = double(pointsDataset(:,{'CameraID', 'SectionID', 'UID', 'X', 'Y', 'Blue', 'Green', 'Red', 'Parallax', 'Radial', 'VariableFlag'}));
parallax = [points(:,[3]) abs(1./points(:,9)) abs(0.001 ./ (points(:,9)))];
parallax = sortrows(parallax,[3 1]);
ind = [];
for i = 1:length(parallax)
if (parallax(i,3) > error || isinf(parallax(i,2)))
ind = [ind i];
end
end
parallax = removerows(parallax, 'ind', ind);
names = {'UID' 'Distance' 'DistanceError'};
parallaxDataset = dataset({parallax, names{:}});
end