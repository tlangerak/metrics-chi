function contour_density=dc1_edge_density(filepath)
    I = imread(filepath);
    I = im2uint8(I);
    I = rgb2gray(I);
    
    thresh=[0.11,0.27];
    BW = edge(I,'Canny',thresh,1);
    non_zero=nnz(BW);
    all=numel(BW);
    contour_density=non_zero/all;
end