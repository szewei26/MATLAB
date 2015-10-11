function [ variableDataset ] = getVariables( pointsDataset, parallaxDataset, periodLuminosityDataset, variablePeriods )

distances = join(parallaxDataset, pointsDataset, 'type', 'Outer', 'Keys', 'UID', 'MergeKeys', true);
variableDistance = distances(distances.VariableFlag==1 & isnan(distances.Distance), {'UID'});
variableDistance = join(variableDistance, variablePeriods,'type', 'Inner', 'Keys', 'UID', 'MergeKeys', true);
variableDistance = join(variableDistance, pointsDataset, 'type', 'Inner', 'Keys', 'UID', 'MergeKeys', true);
variableDistance = join(variableDistance, periodLuminosityDataset, 'type', 'Inner', 'Keys', 'Period', 'MergeKeys', true);
variables = double(variableDistance(:,{'UID', 'Luminosity', 'LuminosityError', 'Blue', 'Green', 'Red'}));
distances = [variables(variables(:,2)./(4*pi*(variables(:,4)+variables(:,5)+variables(:,6)))).^0.5];
distances = [distances(:,[1 7]) (3*0.015^2 + (variables(:,3)./variables(:,2)).^2).^0.5];
distances = [distances(:,1) distances(:,2)/3.08567758e16 distances(:,3)];

names = {'UID', 'Distance', 'DistanceError'};
variableDataset = dataset({distances, names{:}});

end