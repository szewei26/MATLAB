function [galaxyDataset galaxyFuzzyDataset] = matchGalaxiesToFuzzy(fuzzyAngleDataset, fuzzyDataset)
galaxyDataset = dataset('File', 'galaxy.txt', 'delimiter', 'nt', 'ReadVarNames', 'on');
gal = double(galaxyDataset, {'GID', 'Azimuth', 'Polar'});
fuzzy = double(fuzzyAngleDataset, {'UID', 'Azimuth', 'Polar'});
angularDistance = [];
for i=1:numel(gal(:,1))

a = [gal(i,1)*ones(length(fuzzy),1) fuzzy(:,1) abs(gal(i,2) fuzzy(:,2)) abs(gal(i,3) fuzzy(:,3))];
a = [a(:,:) (a(:,3).^2+a(:,4).^2).^0.5];
for j=1:length(a)
if ((a(j,5) < 1.5))
angularDistance = [angularDistance; a(j,:)];
end
end
end
names = {'GID', 'UID', 'AzimuthDistance', 'PolarDistance', 'DistanceDisplacement' };
galaxyFuzzyDataset = dataset({angularDistance, names{:}});
b = join(galaxyFuzzyDataset, fuzzyAngleDataset, 'type', 'Inner', 'Keys', 'UID', 'MergeKeys', true);
b = double(b(:,{'UID', 'Azimuth', 'Polar'}));
plotHammer(fuzzyDataset,fuzzyAngleDataset);
scatterm(b(:,3),b(:,2),'o');
scatterm(gal(:,3),gal(:,2),'mo');
end