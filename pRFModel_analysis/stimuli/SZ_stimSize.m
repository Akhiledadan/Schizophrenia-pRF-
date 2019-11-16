load(fullfile(SZ_rootPath,'8barswithblanks.mat'));

display.height = params.display.dimensions(2);
display.distance = params.display.distance;
display.screensizeindeg = rad2deg(atan(display.height./(2*display.distance))); % radius

fprintf('stimulus size in degrees of visual angle: %s radius',display.screensizeindeg);