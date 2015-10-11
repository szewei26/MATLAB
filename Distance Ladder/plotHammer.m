function [h] = plotHammer(fuzzyDataset, fuzzyAngleDataset)
figure('Units', 'pixels', 'Position', [100 100 1100 500]);
whitebg([0.1 0.1 0.1]);
hold on;
%hammer eqacylin aitoff
axes1 = axesm('MapProjection', 'aitoff', 'Frame', 'on', 'Grid', 'on', 'AngleUnits','degrees', 'GColor', [0.3 0.3 0.3]);
%tissot;
data = join(fuzzyDataset, fuzzyAngleDataset, 'type', 'Inner', 'Keys', 'UID', 'MergeKeys', true);
data = double(data(:,{'UID', 'Azimuth', 'Polar', 'Radial'}));
h = scatterm(data(:,3),data(:,2),3*ones(length(data(:,3)),1),data(:,4),'filled','o');
%set(h, 'filled');
%graphTitle = title(sprintf('Hammer projection of all point source objects'));
xLabel = xlabel('Aziumth angle (deg)');
yLabel = ylabel('Polar angle (deg)');
set(gca, 'FontSize', 16, 'Color', [0 0 0]);
set([xLabel, yLabel], 'FontName', 'AvantGarde', 'Color', [0 0 0],'FontSize', 16);
%set(graphTitle, 'FontSize', 12, 'FontWeight', 'bold');
t = colorbar('peer', gca, 'YColor', [0 0 0], 'FontSize', 16);
set(t)
set(get(t,'ylabel'), 'String', 'Radial Velocity (km/s)', 'Color', [0 0 0], 'FontSize', 16);
xlim(axes1,[ pi 0 .1 pi+0.1]);
ylim(axes1,[ pi/2 0.1 pi/2 + 0.1]);
end