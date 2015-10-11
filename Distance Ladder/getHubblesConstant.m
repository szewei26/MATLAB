function [ hubblesConstant ] = getHubblesConstant(xrayFuzzyDistanceDataset, fuzzyDataset)

% WILL ALSO PRODUCE A PLOT FOR CONVENIENCE
data = join(xrayFuzzyDistanceDataset, fuzzyDataset, 'type', 'Inner', 'Keys', 'UID', 'MergeKeys', true);
data = double(data(:,{'UID', 'Distance', 'DistanceError', 'Radial'}));

x = [data(:,4)];
y = [data(:,2)];
e = [data(:,3).*y];
x = [0; x];
y = [0; y];
e = [0.0001; e];

figure('Units', 'pixels', 'Position', [100 100 600 400]);
hold on;
whitebg([1 1 1]);

errorPlot = errorbar(x,y,e);
set(errorPlot, 'LineStyle', 'none', 'Marker', 'none', 'Color', [0.5 0.6 1]);

lobf = polyfit(x,y,1);
xs = 0:1:2600;
lobfv = polyval(lobf, xs);
B = [x(:),ones(length(x),1)];
[u2, std_u2] = lscov(B,y(:),1./e);
hText = text(800, 150000, sprintf('nnitfy = (%0.1f nnpm %0.1f) xg', u2(1)/1, std_u2(1)/1));
set(hText, 'FontSize', 12);
%hText = text(500, 20000, sprintf('nnitfy = (%0.1f nnpm %0.1f)nntimes 10ˆf0g x + %0.1f nnpm %0.1fg', u2(1)/1, std u2(1)/1, u2(2), std u2(2)));
fitPlot = plot(xs, lobfv, ' ', 'Color', [0.5 0.5 0.5]);
h = plot(x,y,'bo');

set(h, 'MarkerSize', 5, 'MarkerFaceColor', 'b');
axis([0 2600 0 900000]);

%graphTitle = title('Distance vs Radial Velocity');
xLabel = xlabel('Radial Velocity (km/s)');
yLabel = ylabel('Distance (parsecs)');

set(gca, 'FontName', 'Helvetica','FontSize', 14);
set([xLabel, yLabel],'FontSize', 14, 'FontName', 'AvantGarde', 'Color', [0.1 0.1 0.1]);
%set(graphTitle, 'FontSize', 12, 'FontWeight', 'bold');
set(gca, 'Box', 'off', 'TickDir', 'out', 'TickLength', [.02 .02], 'YGrid', 'on', 'XMinorTick', 'on', 'YMinorTick', 'on', 'LineWidth', 1 );

hubblesConstant = [u2(1) std_u2(1) u2(2) std_u2(2)];
end