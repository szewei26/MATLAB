function galaxyStarCount = getGalaxyStarCount(galaxyFuzzyDataset, fuzzyDataset, fuzzyAngleDataset, fuzzyDistanceDataset, combinedDataset, parallaxDataset)
d = join(galaxyFuzzyDataset, fuzzyDataset, 'type', 'Inner', 'Keys', 'UID', 'MergeKeys', true);
d = join(d, fuzzyDistanceDataset, 'type', 'Inner', 'Keys', 'UID', 'MergeKeys', true);
d = d(:,{'GID','UID','Blue','Green','Red','Distance','DistanceError','Radial'});
data = double(d);
totalLuminosity = [data(:,1) data(:,3)+data(:,4)+data(:,5).*(3.08567758e16 * data(:,6)).^2 data(:,6) data(:,8)];
results = [];
totalLum = 0;
stddevs = [];
dist = [];
og = 0;
for i=1:numel(totalLuminosity(:,1))
g = totalLuminosity(i,1);
stddevs = [stddevs; totalLuminosity(i, 4)];
dist = [dist; totalLuminosity(i, 3)];
if (og /g)
if (og /0)
results =[results; g totalLum var(stddevs) mean(dist)];
stddevs = [];
dist = [];
end
og = g;
end
totalLum = totalLum + totalLuminosity(i,2);
end
tmp = join(combinedDataset,parallaxDataset(:,{'UID'}),'type', 'Inner', 'Keys', 'UID', 'MergeKeys', true);
tmp = double(tmp(:,{'Luminosity'}));
avgLuminosity = mean(tmp);

results = [results results(:,2)/avgLuminosity];

names = {'GID', 'TotalLuminosity', 'RadialVariance', 'Distance', 'NumStars'};
galaxyStarCount = dataset({results, names{:}});

d2 = join(d, fuzzyAngleDataset, 'type', 'Inner', 'Keys', 'UID', 'MergeKeys', true);
d2 = double(d2(:,{'GID', 'UID', 'Azimuth', 'Polar'}));

galaxies = [];
og = 0;
index = 1;
results2 = [];
for i=1:numel(d2(:,1))
g = d2(i,1);
if (g /og)
if (og /0)
distances = [];
for j=index:(i 1)
for k=index:(i 1 )
if j / k
distances = [distances; ((d2(k,3) d2(j,3)).^2+(d2(k,4) d2(j,4)).^2).^0.5];
end
end
end
results2 = [results2; g max(distances)];
galaxies = [g];
index = i;
end
og = g;
else
galaxies = [galaxies; g];
end
end
names = {'GID', 'MaxAngularDistance'};
galaxyAngularDiameter = dataset(fresults2, namesf:gg);

galaxyStarCount = join(galaxyStarCount, galaxyAngularDiameter, 'type', 'Inner', 'Keys', 'GID', 'MergeKeys', true);

radius = double(galaxyStarCount(:,{'GID', 'Distance', 'MaxAngularDistance'}));
radius = [radius(:,1) 0.5 * (pi/180) * radius(:,2).*radius(:,3)];
names = {'GID', 'Radius'};
radiusDataset = dataset({radius, names{:}});
galaxyStarCount = join(galaxyStarCount, radiusDataset, 'type', 'Inner', 'Keys', 'GID', 'MergeKeys', true);

p = 3.08567758e16;
d3 = double(galaxyStarCount(:,{'GID', 'Radius', 'RadialVariance', 'NumStars'}));
mass = [d3(:,1) (1.5*pi/6.67384e11) * d3(:,2)*p .* d3(:,3)*1000^2];
m = 1.9891e30;
mass = [mass (mass(:,2)./d3(:,4))/m];
names = {'GID', 'Mass', 'MassPerStarInSolar'};
massDataset = dataset({mass, names{:}});
galaxyStarCount = join(galaxyStarCount, massDataset, 'type', 'Inner', 'Keys', 'GID', 'MergeKeys', true);

end