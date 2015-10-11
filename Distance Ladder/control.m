%% Clear Data
clc;
clear all;
%% Load basic data files
xrayDataset = dataset('File', 'xray.txt', 'delimiter', '\t', 'ReadVarNames', 'on');
pointsDataset = dataset('File', 'group4points.txt', 'delimiter', '\t', 'ReadVarNames', 'on');
fuzzyDataset = dataset('File', 'group4fuzzy.txt', 'delimiter', '\t', 'ReadVarNames', 'on');
%pointsDataset2 = pointsDataset(:, {'UID', 'Blue', 'Green', 'Red', 'Parallax', 'Radial','VariableFlag'});
%temperatureDataset = dataset('File', 'temperature.txt', 'delimiter', 'nt', 'ReadVarNames','on');
%starTempDataset = getStarTemp(pointsDataset2, temperatureDataset);

%% Get azimuth and polar angles for all sources
pointsAngleDataset = getAngles(pointsDataset, 'UID');
fuzzyAngleDataset = getAngles(fuzzyDataset, 'UID');
xrayAngleDataset = getAngles(xrayDataset, 'X');

% Get parallax distance, maximum error specified as parameter
parallaxDataset = getParallax(pointsDataset, 0.2);

% Find absolute magnitude of stars and calibrate variable star luminosity
variablePeriods = dataset('File', 'AllVariables.txt', 'delimiter', '\t', 'ReadVarNames','on');
periodLuminosityDataset = calibrateVariableUsingParallax(pointsDataset, parallaxDataset,variablePeriods);

% Now want to grab all variable stars using calibrated function
variableDataset = getVariables(pointsDataset, parallaxDataset, periodLuminosityDataset,variablePeriods);

% Combine distance measurements into one useful dataset
combinedDataset = combineParallaxAndVariable(pointsDataset2, parallaxDataset,variableDataset);

% Link xrays to fuzzy objects, and to intragalactic sources
linkXrayFuzzyDataset = linkXrayAndFuzzy(xrayAngleDataset, fuzzyAngleDataset, 0.3);
linkXrayVariableDataset = linkXrayAndVariable(xrayAngleDataset, pointsAngleDataset,pointsDataset, 0.36);

% Find relationship for the intragalactic sources
xrayCalibrationDistance = getXrayVariableDistance(combinedDataset,linkXrayVariableDataset, xrayDataset);

% Calculate distance to fuzzy points using relationship
xrayFuzzyDistanceDataset = getXrayDistances(xrayCalibrationDistance, linkXrayFuzzyDataset, xrayDataset);

% Find hubbles constant using the newly found fuzzy object distance
hubblesConstant = getHubblesConstant(xrayFuzzyDistanceDataset, fuzzyDataset);

% Use Hubbles to compute distance to all other fuzzy objects
fuzzyDistanceDataset = getFuzzyDistances(hubblesConstant, fuzzyDataset);

% Combine fuzzy and points
[jointDataset totalAngles] = joinFuzzyAndPoints(fuzzyDistanceDataset, fuzzyDataset,fuzzyAngleDataset, combinedDataset, pointsAngleDataset);

% Match galaxies to clusters of fuzzy objects

[galaxyDataset galaxyFuzzyDataset] = matchGalaxiesToFuzzy(fuzzyAngleDataset, fuzzyDataset);

% Determine total luminosity of galaxies and divide by average luminosity of star to determine the approximate number of stars in the galaxy
galaxyStarCount = getGalaxyStarCount(galaxyFuzzyDataset, fuzzyDataset, fuzzyAngleDataset,fuzzyDistanceDataset, combinedDataset, parallaxDataset);

ratio = mean(double(galaxyStarCount(:,{'MassPerStarInSolar'})));


 %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %%%%%% FUNCTIONS BELOW FOR PRODUCING GRAPHS AND FIGURES %%%%%%%%
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Plot some luminosity colour diagrams
plotHR(combinedDataset, parallaxDataset, starTempDataset);
%% Spherical map of radial velocities
plotRadialVelocityDistribution(pointsAngleDataset, pointsDataset, 0);
%% Spherical map of fuzzy velocities
plotRadialVelocityDistribution(fuzzyAngleDataset, fuzzyDataset, 0);
%% Map of radial velocity for all known distance points
plotKnownRadialVelocityDistribution(pointsAngleDataset, combinedDataset, 1000, 0, 0);
%% Map of radial velocity for all known distance points
plotKnownRadialVelocityDistribution(pointsAngleDataset, combinedDataset, 100000, 0, 0);
%% Plot the xray determined fuzzy points
plotKnownRadialVelocityDistribution(fuzzyAngleDataset, join(xrayFuzzyDistanceDataset,fuzzyDataset,'type', 'Inner', 'Keys', 'UID', 'MergeKeys', true), 10000000, 1, 0);
%% Map including fuzzy data
plotKnownRadialVelocityDistribution(totalAngles,jointDataset(:,{'UID','Distance','DistanceError','Radial'}), 100000000, 1, 0);
%% Plot location and error of all parallax stars under 0.05 error
plotParallax(pointsDataset, combinedDataset, parallaxDataset, pointsAngleDataset, 0.05, 1);
%% Plot location and error of all parallax stars under 0.1 error
plotParallax(pointsDataset, combinedDataset, parallaxDataset, pointsAngleDataset, 0.1, 1);
%% Plot location and error of all parallax stars under 0.2 error
plotParallax(pointsDataset, combinedDataset, parallaxDataset, pointsAngleDataset, 0.2, 0);
%% Aitoff projection of all point sources
hammerPoints = plotHammer(pointsDataset,pointsAngleDataset);
%% Aitoff projection of all fuzzy sources
hammerFuzzy = plotHammer(fuzzyDataset,fuzzyAngleDataset);
%% No correlations. Sigh
plotBad(galaxyStarCount);