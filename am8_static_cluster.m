function colorS = am8_static_cluster(filepath)
% classify to 512 clusters, each one has 32*32*32 values

  threshold = 5; % remove RGB < threshold times 3/5/0.1%
  RGB = imread(filepath);
  RGB= im2uint8(RGB);

  [N,M,C]=size(RGB);
  colormap=reshape(RGB,[M*N,C]);
  [map,ia,ind] = unique(colormap,'rows');
  counts = histc(ind,unique(ind));
      
  freq= [double(map) counts]; %frequency of each RGB value
  countRGB = sortrows(freq,4);
     
  count = zeros(512,1);% 512 cluster
        
  for c = length(countRGB):-1:1
      if countRGB(c,4)<threshold % low frequency value
         break;
      else
%      get index of cluster          
              indexR = fix((countRGB(c,1)-1)/32) +1;
              indexG = fix((countRGB(c,2)-1)/32) +1;
              indexB = fix((countRGB(c,3)-1)/32) +1;
              
              ClusterId = (indexR-1)*64 +(indexG-1)*8 + indexB;
              count(ClusterId,1) = count(ClusterId,1)+1;
      end
  end
          
    colorS = length(find(count));
end