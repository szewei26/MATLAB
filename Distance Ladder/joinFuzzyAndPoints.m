function [jointDataset totalAngles] = joinFuzzyAndPoints(fuzzyDistanceDataset, fuzzyDataset, fuzzyAngleDataset, combinedDataset, pointsAngleDataset)
distances = join(fuzzyDistanceDataset, fuzzyDataset, 'type', 'Inner', 'Keys', 'UID', 'MergeKeys', true);
distances = join(distances, fuzzyAngleDataset, 'type', 'Inner', 'Keys', 'UID', 'MergeKeys', true);
distances = distances(:, {'UID', 'Azimuth', 'Polar', 'Distance', 'DistanceError', 'Radial','Blue','Green','Red'});
distances2 = join(combinedDataset, pointsAngleDataset, 'type', 'Inner', 'Keys', 'UID', 'MergeKeys', true);
distances2 = distances2(:, {'UID', 'Azimuth', 'Polar', 'Distance', 'DistanceError', 'Radial','Blue','Green','Red'});
jointDataset = vertcat(distances, distances2);
totalAngles = vertcat(pointsAngleDataset,fuzzyAngleDataset);
end