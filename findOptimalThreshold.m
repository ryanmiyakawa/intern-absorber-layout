function threshold = findOptimalThreshold(imageIntensity, maskSize, targetWidth)

randomNumbers = rand(1, 10^6);
[threshold, fval] = fminsearch( ...
    @(x) widthError(x, imageIntensity, maskSize, targetWidth, randomNumbers),...
    0.5, ...
    optimset('TolFun', 1e-1, 'TolX', 1e-1)...
 );








function er = widthError(threshold, imageIntensity, maskSize, targetWidth, psrand) 

deprotectedImage = imageToDeprotection(imageIntensity, maskSize, 50, 10, 40, threshold, true, psrand);
[width, roughness, hasError] = analyzeLines(deprotectedImage);

er = abs(width - targetWidth)^2;
fprintf('currentWidth: %0.2f, error: %0.4f\n', width, er);