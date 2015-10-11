function [ combinedDataset ] = combineParallaxAndVariable( pointsDataset2, parallaxDataset, variableDataset)
combinedDataset = join(parallaxDataset, pointsDataset2, 'type', 'Inner', 'Keys', 'UID', 'MergeKeys', true);
combinedDataset2 = join(variableDataset, pointsDataset2, 'type', 'Inner', 'Keys', 'UID', 'MergeKeys', true);
combinedDataset = vertcat(combinedDataset, combinedDataset2);
combinedDataset = sortrows(combinedDataset, {'Distance', 'UID'});
combined = double(combinedDataset);
combined2 = [combined(:,1) (combined(:,4) + combined(:,5) + combined(:,6)) .* (3.08567758e16 * combined(:,2)).^2 (3 * 0.015^2 + combined(:,3)).^0.5];
combined2 = sortrows(combined2, [2 3]);
names = {'UID', 'Luminosity', 'LuminosityErrorR'};
combinedDataset = join(combinedDataset, dataset({combined2, names{:}}), 'type', 'Inner', 'Keys', 'UID', 'MergeKeys', true);
combinedDataset = sortrows(combinedDataset, {'LuminosityErrorR', 'Distance', 'UID'});
end