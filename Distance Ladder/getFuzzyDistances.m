function [ fuzzyDistanceDataset ] = getFuzzyDistances(hubblesConstant, fuzzyDataset)
data = double(fuzzyDataset(:, {'UID', 'Radial'}));
data = [data(:,1) data(:,2)*hubblesConstant(1) ones(length(data(:,1)),1)*hubblesConstant(2)/hubblesConstant(1)];
names = {'UID', 'Distance', 'DistanceError'};
fuzzyDistanceDataset = dataset({data, names{:}});
end