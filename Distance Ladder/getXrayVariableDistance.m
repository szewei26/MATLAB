function [ xrayCalibration ] = getXrayVariableDistance(combinedDataset, linkXrayVariableDataset, xrayDataset)

% WILL ALSO PRODUCE A PLOT FOR CONVENIENCE
joint = join(combinedDataset(:,{'UID', 'Distance', 'DistanceError'}), linkXrayVariableDataset,'type', 'Inner', 'Keys', 'UID', 'MergeKeys', true);
joint = join(xrayDataset, joint,'type', 'Inner', 'Keys', 'XID', 'MergeKeys', true);

data = double(joint(:,{'Photons detected', 'Distance', 'DistanceError'}));
x = data(:,1).^ 0.5;
y = data(:,2);
e = y.*data(:,3);

figure('Units', 'pixels', 'Position', [100 100 600 400]);
hold on;
whitebg([1 1 1]);

errorPlot = errorbar(x,y,e);
set(errorPlot, 'LineStyle', 'none', 'Marker', 'none', 'Color', [0.5 0.6 1]);

lobf = polyfit(x,y,1);
xs = 2e4:1e5:6e4;
lobfv = polyval(lobf, xs);
B = [x(:),ones(length(x),1)];
[u2, std_u2] = lscov(B,y(:),1./e);
hText = text(3.5e4 , 4300, sprintf('\\it{y = (%0.1f \\pm %0.1f)\\times 10ˆ{6} x + %1.0f \\pm %1.0fg', u2(1)/1e6, std_u2(1)/1e6, u2(2), std_u2(2)));
fitPlot = plot(xs, lobfv, ' ', 'Color', [0.5 0.5 0.5]);
h = plot(x,y,'bo');
set(h, 'MarkerSize', 15);
set(h, 'MarkerSize', 5, 'MarkerFaceColor', 'b');
axis([2.5e4 5.5e4 1000 5500]);

%graphTitle = title('X Ray Photon Count Distance Calibration');
xLabel = xlabel('Inverse Root Photon Count');
yLabel = ylabel('Distance (parsecs)');

set(gca, 'FontSize', 14,'FontName', 'Helvetica');
%set([graphTitle,xLabel, yLabel], 'FontName', 'AvantGarde');
set([xLabel, yLabel], 'FontSize', 14);
%set(graphTitle, 'FontSize', 12, 'FontWeight', 'bold');
set(gca, 'Box', 'off', 'TickDir', 'out', 'TickLength', [.02 .02], 'YGrid', 'on', 'XMinorTick', 'on', 'YMinorTick', 'on', 'LineWidth', 1, 'YColor', [0.1 0.1 0.1], 'XColor', [0.1 0.1 0.1]);

xrayCalibration = [u2(1) std_u2(1) u2(2) std_u2(2)];
end