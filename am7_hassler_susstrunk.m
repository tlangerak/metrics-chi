function [meanRG, stdRG, meanYB, stdYB, meanRGYB, stdRGYB, colourfulness] = am7_hassler_susstrunk(filepath)
    RGB = imread(filepath);  
    RGB= im2uint8(RGB);
    
    k = 1;
    im = RGB;
    [H,W, ~] = size(im);
    
    for x=1:W
        for y=1:H
    
            % rg = R - G
            rg(k) = abs(double(im(y,x,1)) - double(im(y,x,2)));
            
            % yb = 1/2(R + G) - B
            yb(k) = abs(.5 * (double(im(y,x,1)) + double(im(y,x,2))) - double(im(y,x,3)));
            
            k = k+1;
        end
    end
    
    % standard deviation and the mean value of the pixel
    % cloud along direction, respectively
    stdRG = std(rg);
    meanRG = mean(rg);
    
    stdYB = std(yb);
    meanYB = mean(yb);
    
    stdRGYB = sqrt((stdRG)^2 + (stdYB)^2);
    meanRGYB = sqrt((meanRG)^2 + (meanYB)^2);
    
    colourfulness = stdRGYB + 0.3*meanRGYB;
end
