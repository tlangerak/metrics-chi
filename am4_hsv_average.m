function [avgHue, avgSaturation, stdSaturation, avgValue, stdValue] = am4_hsv_average(filepath)
    RGB = imread(filepath);  
    RGB= im2uint8(RGB);
    hsv = rgb2hsv(RGB);
    h = hsv(:,:,1);
    s = hsv(:,:,2);
    v = hsv(:,:,3);
      
    sumsin = sum(sind(h(:))) ;
    sumcos = sum(cosd(h(:)));
    avgHue=atan2d(sumsin, sumcos);  %  average hue angle
    avgSaturation= mean2(s); %  average saturation 
    stdSaturation = std(std(s));%  standard deviation saturation
    avgValue= mean2(v); %  average value angle
    stdValue= std(std(v));%  standard deviation value
end
