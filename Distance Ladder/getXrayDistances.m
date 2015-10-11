function [ xrayFuzzyDistanceDataset ] = getXrayDistances(xrayCalibrationDistance, linkXrayFuzzyDataset, xrayDataset)

data = join(linkXrayFuzzyDataset, xrayDataset, 'type', 'Inner', 'Keys', 'XID', 'MergeKeys', true);
data = double(data(:,{'UID', 'Photons detected'}));
data = [data(:,:)(xrayCalibrationDistance(1)*(data(:,2).^ 0.5)+xrayCalibrationDistance(3)) ones(length(data(:,2)),1)*(xrayCalibrationDistance(2)./xrayCalibrationDistance(1))];
names = {'UID', 'Distance', 'DistanceError'};
xrayFuzzyDistanceDataset = dataset({[data(:,1) data(:,3) data(:,4)], namesf:g});

end