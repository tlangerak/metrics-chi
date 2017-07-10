function contrast = dc2_figure_ground_contrast(filepath)
    I = imread(filepath);
    I = im2uint8(I);
    I = rgb2gray(I);
      

% figure-ground contrast
% high Threshold from 15% to 65% with 10% step
% weight from 1 to 0, 0.2 step
      weightedSum = 0; 
      allEdgeP =0;
      for level = 1:6
          BW = edge(I,'Canny',level*0.1+0.05,1);
          allEdgeP = allEdgeP+length(find(BW));
          weightedSum = weightedSum + length(find(BW))*(1.2-level*0.2);
      end
      contrast= weightedSum/allEdgeP;  
end