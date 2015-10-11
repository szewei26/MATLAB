function [ h ] = plotRadialVelocityDistribution( pointsAngleDataset, pointsDataset, rotate )

data = double(join(pointsAngleDataset, pointsDataset, 'type', 'Inner', 'Keys', 'UID', 'MergeKeys', true), {'UID', 'Azimuth','Polar','Radial'});
[x y z] = sph2cart(data(:,2)*pi/180, data(:,3)*pi/180, ones(length(data(:,1)),1));
figure1 = figure('Units', 'pixels', 'Position', [100 100 900 700]);
whitebg([0 0 0]);
hold on;

axes1 = axes('Parent',figure1,'ZGrid','on','YMinorTick','on','XMinorTick','on','XGrid','on','TickDir','out','TickLength',[0.02 0.02],'LineWidth',1,'DataAspectRatio',[1 1 1],'CameraViewAngle',8.7254050895469);

%hold(axes1,'all');
%view(axes1,[46.5 18]);
h = scatter3(x, y, z, 10*ones(length(data(:,1)),1), data(:,4), 'filled');
%colorbar();
%axis([ 1 1 1 1 1 1]);
%plot3([ 1 1],[0 0],[0 0], 'Color', [0.5 0.5 0.5]);

%plot3([0 0],[ 1 1],[0 0], 'Color',[0.5 0.5 0.5]);
%plot3([0 0],[0 0],[ 1 1], 'Color',[0.5 0.5 0.5]);
if (rotate)
for i=1:360
camorbit(1,0,'data',[0 0 1]);
drawnow
pause(0.01);
end
end
end