function getFeatureCongestion(folder)
% 4 Metrics from <Measuring visual clutter>
% Feature Congestion 
% Subband Entropy
% Edge Indensity
% figure-ground contrast

%   folder = '../mobileapp';
%   fileinfo = dir('../mobileapp/*.png');
  fileinfo = dir(folder+'/*.png');
  len = length(fileinfo);

  name = cell(len,1);
  FC = zeros (len,1);
  SE = zeros (len,1);  
  EI = zeros (len,1);
  contrast = zeros (len,1);
  
    for i = 1:len(1)
      name{i,1} = fileinfo(i).name ;
      file = fullfile(folder, fileinfo(i).name);
      I = imread(file);
      I = im2uint8(I);
      I = rgb2gray(I);
      
% edge density 
% 0.11 and 0.27, sigma = 1,from Measuring visual clutter
      BW = edge(I,'Canny',[0.11;0.21],1);
      EI(i,1) = length(find(BW))/numel(BW);
%       imshowpair(I,BW,'montage');
      

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
      contrast(i,1) = weightedSum/allEdgeP;

% Feature Congestion 
% Subband Entropy
      [FC(i,1), ~] = getClutter_FC(file);
      SE(i,1) = getClutter_SE(file);


    end
    
    re = table(name,FC,SE,EI,contrast);
    writetable(re,'fcSE.csv');
  
end