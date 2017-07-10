function [meanL,stdL,meanA,stdA,meanB,stdB] = am6_LAB_avg(filepath)
    RGB = imread(filepath);  
    RGB= im2uint8(RGB);
    lab = rgb2lab(RGB);
      
    L = lab(:,:,1);
    A = lab(:,:,2);
    B = lab(:,:,3);

    stdL = std2(L);
    meanL = mean2(L);
    stdA = std2(A);
    meanA= mean2(A);
    stdB= std2(B);
    meanB = mean2(B);
end
