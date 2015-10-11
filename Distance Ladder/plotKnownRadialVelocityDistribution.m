function [ h ] = plotKnownRadialVelocityDistribution( pointsAngleDataset, combinedDataset, maxDistance, showError, rotate )
datas = join(combinedDataset, pointsAngleDataset,'type', 'Inner', 'Keys', 'UID', 'MergeKeys', true);
data = double(datas(datas.Distance < maxDistance, {'UID', 'Azimuth', 'Polar', 'Distance', 'DistanceError', 'Radial'}));
[x y z] = sph2cart(data(:,2)*pi/180, data(:,3)*pi/180, data(:,4));
figure1 = figure('Units', 'pixels', 'Position', [100 100 900 700]);
%set(gcf, 'Renderer', 'zbuffer');
whitebg([0 0 0]);
axes1 = axes('Parent',figure1,'ZGrid','on','YMinorTick','on','XMinorTick','on','XGrid','on','TickDir','out','TickLength',[0.02 0.02],'PlotBoxAspectRatio',[1 1 1],'LineWidth',1,'DataAspectRatio',[1 1 1],'CameraViewAngle',8.7254050895469);
view(axes1,[46.5 18]);
hold(axes1,'all');
if (showError)
h2 = plot3d_radial_errorbars(data(:,2)*pi/180, data(:,3)*pi/180, data(:,4),data(:,5));
end
h = scatter3(x,y,z,10*ones(length(data(:,6)),1),data(:,6),'o');
set(h, 'MarkerFaceColor', get(h, 'MarkerEdgeColor'));
lims = axis;
plot3(lims(1:2),[0 0],[0 0], 'Color', [0.5 0.5 0.5]);
plot3([0 0],lims(3:4),[0 0], 'Color',[0.5 0.5 0.5]);
plot3([0 0],[0 0],lims(5:6), 'Color',[0.5 0.5 0.5]);
t = colorbar('peer', gca, 'YColor', [0 0 0], 'FontSize', 20);
set(get(t,'ylabel'), 'String', 'Radial Velocity (km/s)', 'Color', [0 0 0], 'FontSize', 20);

%graphTitle = title(sprintf('All determined point sources under %d parsecs with corresponding radial velocity in colour', maxDistance));
xLabel = xlabel('Parsecs in x');
yLabel = ylabel('Parsecs in y');
zLabel = zlabel('Parsecs in z');

set(gca, 'FontSize', 16);
set(gca, 'FontName', 'Helvetica');
set([xLabel, yLabel, zLabel], 'FontName', 'AvantGarde', 'FontSize', 20, 'Color', [0 0 0]);
%set(graphTitle, 'FontSize', 12, 'FontWeight', 'bold');
set(gca, 'Box', 'off', 'TickDir', 'out', 'TickLength', [.02 .02], 'XMinorTick', 'on','YMinorTick', 'on', 'YGrid', 'off', 'LineWidth', 1,'YColor', [0.3 0.3 0.3], 'XColor',[0.3 0.3 0.3], 'ZColor', [0.3 0.3 0.3]);
if (rotate)
for i=1:360
camorbit(1,0,'data',[0 0 1]);
drawnow
pause(0.01);
end
end
end