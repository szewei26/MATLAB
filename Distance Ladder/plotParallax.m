function [ h ] = plotParallax(pointsDataset, combinedDataset, parallaxDataset, pointsAngleDataset, error, rotate )
datas = join(pointsDataset, combinedDataset(:, {'UID', 'Distance', 'DistanceError', 'Luminosity', 'LuminosityErrorR'}),'type', 'Inner', 'Keys', 'UID', 'MergeKeys', true);
datas = join(datas, parallaxDataset(:, {'UID'}),'type', 'Inner', 'Keys', 'UID', 'MergeKeys', true);
datas = join(datas, pointsAngleDataset,'type', 'Inner', 'Keys', 'UID', 'MergeKeys', true);
data = double(datas(datas.DistanceError < error, {'UID', 'Azimuth', 'Polar', 'Distance', 'DistanceError', 'Luminosity', 'Blue', 'Green', 'Red'}));
total = max(data(:,7:9),[],2);
rgb = [(data(:,9) ./ total).^0.5 (data(:,8) ./ total).^0.5 (data(:,7) ./ total).^0.5];
x y z] = sph2cart(data(:,2)*pi/180, data(:,3)*pi/180, data(:,4));
figure1 = figure('Units', 'pixels', 'Position', [100 100 900 700]);
whitebg([0 0 0]);
axes1 = axes('Parent',figure1,'ZGrid','on','YMinorTick','on','XMinorTick','on','XGrid','on','TickDir','out','TickLength',[0.02 0.02],'PlotBoxAspectRatio',[1 1 1],'LineWidth',1,'DataAspectRatio',[1 1 1],'CameraViewAngle',8.7254050895469);
view(axes1,[46.5 18]);
hold(axes1,'all');
h = scatter3(x,y,z,1+(log10(data(:,6)) 17).^1.5,rgb,'o');
set(h, 'MarkerFaceColor', get(h, 'MarkerEdgeColor'));
h = plot3d_radial_errorbars(data(:,2)*pi/180, data(:,3)*pi/180, data(:,4), data(:,5));
lims = axis;
plot3(lims(1:2),[0 0],[0 0], 'Color', [0.5 0.5 0.5]);
plot3([0 0],lims(3:4),[0 0], 'Color',[0.5 0.5 0.5]);
plot3([0 0],[0 0],lims(5:6), 'Color',[0.5 0.5 0.5]);

%graphTitle = title(sprintf('Distances to stars with <%d%s parallax distance error',100*error,'%'));
xLabel = xlabel('Parsecs in x');
yLabel = ylabel('Parsecs in y');
zLabel = zlabel('Parsecs in z');

set(gca, 'FontSize', 16, 'FontName', 'Helvetica');
set([xLabel, yLabel,zLabel], 'FontName', 'AvantGarde', 'FontSize', 16, 'color', [0 0 0]);
set(gca, 'Box', 'off', 'TickDir', 'out', 'TickLength', [.02 .02], 'XMinorTick', 'on','YMinorTick', 'on', 'YGrid', 'off', 'LineWidth', 1, 'YColor', [0.5 0.5 0.5], 'XColor',[0.5 0.5 0.5], 'ZColor', [0.5 0.5 0.5]);
set(gca)
if (rotate)

for i=1:360
camorbit(1,0,'data',[0 0 1]);
drawnow
pause(0.01);
end
end
end