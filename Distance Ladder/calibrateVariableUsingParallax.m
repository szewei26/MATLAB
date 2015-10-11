function [ periodLuminosityDataset ] = calibrateVariableUsingParallax(pointsDataset, parallaxDataset, variablePeriods)

variableStarDataset = pointsDataset(pointsDataset.VariableFlag==1,{'UID', 'Blue', 'Green', 'Red', 'Variable'});
fullParallaxVariableDataset = join(parallaxDataset, variableStarDataset, 'type', 'Inner', 'Keys', 'UID', 'MergeKeys', true);
fullParallaxVariableDataset = sortrows(fullParallaxVariableDataset, {'DistanceError', 'UID'});

%export(fullParallaxVariableDataset(:,f'UID' 'Variable'g), 'file', 'variables.txt');
fullParallaxVariableDataset = join(fullParallaxVariableDataset, variablePeriods, 'type', 'Inner', 'Keys', 'UID', 'MergeKeys', true);

% We have received flux, but want total flux using distance falloff
data = double(fullParallaxVariableDataset(:,{'UID', 'Blue', 'Green', 'Red', 'Distance', 'DistanceError', 'Period', 'PeriodError'}));

% Convert parsec to m. Add in flux error retrospectively.
data = [data data(:,5)*3.08567758e16 (data(:,6).^2 + 0.015^2).^0.5];
data = [data 4*pi*(data(:,9).^2)];
% Now we get the period, actual flux, actual sum of flux, and error ratio
data = [data(:,1) data(:,7) data(:,8) data(:,2).*data(:,11) data(:,3).*data(:,11) data(:,4).*data(:,11) (data(:,2) + data(:,3) + data(:,4)).*data(:,11) data(:,10)];

names = {'UID' 'Period' 'PeriodError' 'Blue' 'Green' 'Red' 'Total' 'FluxError'};
variableFluxDataset = dataset(fdata, namesf:gg);
variable50Dataset = double(variableFluxDataset(variableFluxDataset.Period==50, {'UID', 'Blue', 'Green', 'Red', 'Total', 'FluxError'}));
variable20Dataset = double(variableFluxDataset(variableFluxDataset.Period==20, {'UID', 'Blue', 'Green', 'Red', 'Total', 'FluxError'}));

% Only bothering with total luminosity
Period = [50; 20];
Luminosity = [wmean(variable50Dataset(:,5), 1./(variable50Dataset(:,6)).^2); wmean(variable20Dataset(:,5),1./(variable20Dataset(:,6)).^2)];
LuminosityError = [(var(variable50Dataset(:,5),1./(variable50Dataset(:,6)).^2))^0.5; (var(variable20Dataset(:,5),1./(variable20Dataset(:,6)).^2))^0.5];
periodLuminosityDataset = dataset(Period, Luminosity, LuminosityError);

end