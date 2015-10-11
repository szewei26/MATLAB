function [ xrayToVariableDataset ] = linkXrayAndVariable(xrayAngleDataset, pointsAngleDataset, pointsDataset, distanceThreshold)
xrays = double(xrayAngleDataset, {'XID', 'Azimuth', 'Polar'});
vari = double(join(pointsDataset(pointsDataset.VariableFlag==1, {'UID'}), pointsAngleDataset), {'UID', 'Azimuth', 'Polar'});
angularDistance = [];

for i=1:length(xrays)
a = [xrays(i,1)*ones(length(vari),1) vari(:,1) abs(xrays(i,2) vari(:,2)) abs(xrays(i,3) vari(:,3))];
a = [a(:,:) (a(:,3).^2+a(:,4).^2).^0.5];
for j=1:length(a)
if ((a(j,5) < distanceThreshold))
angularDistance = [angularDistance; a(j,:)];
end
end
end
names = {'XID', 'UID', 'AzimuthDistance', 'PolarDistance', 'DistanceDisplacement'};
xrayToVariableDataset = dataset(fangularDistance, namesf:gg);

end