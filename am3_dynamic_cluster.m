function numberofC=am3_dynamic_cluster(filepath)
%dynamic color cluster;
% colour g(only colors covering more than five pixels), 
% If the distance in all color components is less than three, 
% two colors are united in the same cluster. 
% Uniting continues recursively till all used colors are assigned to a cluster.

  RGB = imread(filepath);  
  RGB= im2uint8(RGB);

  [N,M,C]=size(RGB);
  RGBpoint=reshape(RGB,[M*N,C]);
  [unique_rows,~,ind] = unique(RGBpoint,'rows');
  counts = histc(ind,unique(ind));

  freq= [double(unique_rows) counts]; %frequency of each RGB value
  countRGB = sortrows(freq,4);

  numberofC = 1;
  Center(1,:) = countRGB(length(countRGB),:);

  k = length(countRGB)-1;

  while (k>0)
    if countRGB(k,4)<6
        break;
    else 
      belong1cluster = false;

      for cen = 1:numberofC
          Dist = pdist2(countRGB(k,1:3),Center(cen,1:3));

          if Dist < 3 %add new node,renew center of current cluster
              now = Center(cen,:);
              new = countRGB(k,:);
              newCount = now(1,4)+new(1,4);
              Center(cen,1:3) = (now(1,1:3)* now(end)+ new(1,1:3)*new(end))/newCount;
              Center(cen,4) = newCount;
              belong1cluster = true;
              break;
          end
      end

      if belong1cluster == false
      % new center,  cluster +1
              numberofC =numberofC+1;
              Center(numberofC,:) = countRGB(k,:);
      end
      k = k-1;
    end
  end     
end