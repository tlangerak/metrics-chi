function countRGB=am2_number_of_colours(filepath)
    RGB = imread(filepath);  
    RGB= im2uint8(RGB);
    [N,M,C]=size(RGB);
    RGBpoint=reshape(RGB,[M*N,C]);
    [~,~,ind] = unique(RGBpoint,'rows');
    counts = histc(ind,unique(ind));
    countRGB = length(find(counts>5));     
end

