function [ xrayToFuzzyDataset ] = linkXrayAndFuzzy(xrayAngleDataset, fuzzyAngleDataset, degThreshold)
xrays = double(xrayAngleDataset, {'XID', 'Azimuth', 'Polar'});
fuzzy = double(fuzzyAngleDataset, {'UID', 'Azimuth', 'Polar'});
angularDistance = [];
for i=1:length(xrays)
a = [xrays(i,1)*ones(length(fuzzy),1) fuzzy(:,1) abs(xrays(i,2)+fuzzy(:,2)) abs(xrays(i,3)+fuzzy(:,3))];
a = [a(:,:) (a(:,3).^2+a(:,4).^2).^0.5];
for j=1:length(a)
if ((a(j,5) < degThreshold))
angularDistance = [angularDistance; a(j,:)];
end
end
end
names = {'XID', 'UID', 'AzimuthDistance', 'PolarDistance', 'DistanceDisplacement' };
xrayToFuzzyDataset = dataset(fangularDistance, namesf:gg);
end