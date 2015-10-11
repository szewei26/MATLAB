function [ h ] = plotHR( combinedDataset, parallaxDataset, starTempDataset )
combinedDataset = join(combinedDataset, parallaxDataset,'type', 'Inner', 'Keys', 'UID', 'MergeKeys', true);
combinedDataset = join(combinedDataset, starTempDataset,'type', 'Inner', 'Keys', 'UID', 'MergeKeys', true);
data = double(combinedDataset(combinedDataset.LuminosityErrorR < 0.3, {'UID', 'Luminosity', 'LuminosityErrorR', 'Blue', 'Green', 'Red', 'Kelvin'}));

x = (data(:,5)*10 + data(:,6)*100 )./ (data(:,4)+data(:,5)+data(:,6));
%x = data(:,7);
y = data(:,2);
e = data(:,2).*data(:,3);
eh = 0.045 .* x;

figure('Units', 'pixels', 'Position', [100 100 900 700]);
h = semilogy(x,y,'b.');
whitebg([0 0 0]);
hold on;
total = max(data(:,4:6),[],2);
rgb = [(data(:,6) ./ total).^0.5 (data(:,5) ./ total).^0.5 (data(:,4) ./ total).^0.5];

hh = ploterr(x,y,eh,e);
set(hh(1), 'LineStyle', 'none', 'Marker','none');
set(hh(2), 'Color', [0.6 0.6 0.6],'Marker','none');
set(hh(3), 'LineStyle', 'none', 'Marker','none');
h = scatter(x,y,20,rgb,'o', 'filled');
set(h)%, 'MarkerSize', 5);
axis([5 75 10e19 10e27]);

%graphTitle = title('Star Emission Colour vs Luminosity');
xLabel = xlabel('Colour (Blue@0, Red@100)');
yLabel = ylabel('Luminosity W/nm');

set(gca, 'FontName', 'Helvetica','FontSize', 14);
set([xLabel, yLabel], 'FontName', 'AvantGarde');
set([xLabel, yLabel], 'FontSize', 14);
%set(graphTitle, 'FontSize', 12, 'FontWeight', 'bold', 'Color', [1 1 1]);
set(gca, 'Box', 'off', 'TickDir', 'out', 'TickLength', [.02 .02], 'YColor', [0.2 0.2 0.2], 'XColor', [0.2 0.2 0.2], 'XMinorTick', 'on', 'YMinorTick', 'on', 'YGrid', 'off', 'LineWidth', 1 );

end