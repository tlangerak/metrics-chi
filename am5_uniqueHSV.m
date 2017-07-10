function [unique_hsv, unique_h, unique_s, unique_v] = am5_uniqueHSV(filepath)
    RGB = imread(filepath);  
    RGB= im2uint8(RGB);
    hsv = rgb2hsv(RGB);
    h = hsv(:,:,1);
    s = hsv(:,:,2);
    v = hsv(:,:,3);
    
    freqH = tabulate(h(:));
    unique_h = length(freqH(:,3));  
    freqS = tabulate(s(:));
    unique_s = length(freqS(:,3));
    freqV = tabulate(v(:));
    unique_v= length(freqV(:,3));
    
    [N,M,C]=size(hsv);
    HSVpoint=reshape(hsv,[M*N,C]);
    [~,~,ind] = unique(HSVpoint,'rows');
    counts = histc(ind,unique(ind));
    unique_hsv = length(find(counts>5));     
end

    