function [ h ] = plotBad(galaxyStarCount)

figure('Units', 'pixels', 'Position', [100 100 600 600]);
whitebg([1 1 1]);
set(gca, 'FontSize', 13);
x = galaxyStarCount(:,{'Distance'});
y = galaxyStarCount(:,{'NumStars'});
h = loglog(x,y,'.','LineStyle','none');
set(h, 'MarkerSize', 20);
xlabel('Distance (pc)');
ylabel('Number of stars');

figure('Units', 'pixels', 'Position', [100 100 600 600]);
whitebg([1 1 1]);
set(gca, 'FontSize', 13);
x = galaxyStarCount(:,{'Distance'});
y = galaxyStarCount(:,{'Mass'});
h = loglog(x,y,'.','LineStyle','none');

set(h, 'MarkerSize', 20);
xlabel('Distance (pc)');
ylabel('Mass (kg)');
figure('Units', 'pixels', 'Position', [100 100 600 600]);
whitebg([1 1 1]);
set(gca, 'FontSize', 13);
x = galaxyStarCount(:,{'Mass'});
y = galaxyStarCount(:,{'TotalLuminosity'});
h = loglog(x,y,'.','LineStyle','none');
set(h, 'MarkerSize', 20);
xlabel('Mass (kg)');
ylabel('Luminosity (W/nm)');

figure('Units', 'pixels', 'Position', [100 100 600 600]);
whitebg([1 1 1]);
set(gca, 'FontSize', 13);
x = galaxyStarCount(:,{'Radius'});
y = galaxyStarCount(:,{'Mass'});
h = loglog(x,y,'.','LineStyle','none');
set(h, 'MarkerSize', 20);
xlabel('Radius (pc)');
ylabel('Mass (kg)');

end