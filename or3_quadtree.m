function [b,s,e,n] = or3_quadtree(filepath)
    I = imread(filepath);
    I = im2uint8(I);
    [N,M,C]=size(I)
    res_leaf=[];
    cor_size=[0,0,M,N];
    [~,res_leaf,~]=quadtree(I,res_leaf,cor_size,0);
    RGB = insertShape(I,'Rectangle',res_leaf);
    imshow(RGB)
    b = balance(res_leaf, M, N)
    s = symmetry(res_leaf, M, N)
    e = equilibrium(res_leaf, M, N)
    [n,~] = size(res_leaf)
end

function [leaf, res_leaf, cor_size]= quadtree(leaf,res_leaf, cor_size,i)
    ent_color = color_entropy(leaf);
    ent_int = intensity_entropy(leaf);
    [height, width, ~] = size(leaf);
    color_thres = 0.75; 
    intensity_thres = 0.75;
    
    if (ent_color > color_thres || ent_int > intensity_thres || i<2) && height / 2 > 6 && width / 2 > 6
        i=i+1;
        hw = int16(width/2);
        hh = int16(height/2);
        new_leaf = {leaf(1:hh, 1:hw,:); leaf(hh:height-1, 1:hw,:); leaf(1:hh,hw:width-1,:); leaf(hh:height-1, hw:width-1,:)};
       
        new_cor_size = {[cor_size(1) + 0, cor_size(2) + 0, width / 2, height / 2];
                        [cor_size(1) + 0, cor_size(2) + height / 2, width / 2, height / 2];
                        [cor_size(1) + width / 2, cor_size(2) + 0, width / 2, height / 2];
                        [cor_size(1) + width / 2, cor_size(2) + height / 2, width / 2, height / 2]
                        };
        for x = 1: length(new_leaf)
            [leaf, res_leaf, cor_size]=quadtree(new_leaf{x}, res_leaf, new_cor_size{x}, i);
        end
    else
        res_leaf = [res_leaf; cor_size];
    end
end

function ie = intensity_entropy(inp)
    lab = rgb2lab(inp);
    L = lab(:,:,1);
    [M,N,C]=size(L);
    L=reshape(L,[M*N,C]);
    edges=linspace(0,100,20);
    h = histogram(L, edges);
    h.Normalization = 'pdf';
    p = h.Values;
    p(p == 0) = 1;
    ie = -sum(p.*log2(p));
end

function ce = color_entropy(inp)
    inp = inp./255;
    hsv = rgb2hsv(inp);
    H = hsv(:,:,1);
    H = H.*360;
    S = hsv(:,:,2);
    S = S.*100;
    
    [M,N,C]=size(H);
    H=reshape(H,[M*N,C]);
    edges=linspace(0,360,30);
    h = histogram(H, edges);
    h.Normalization = 'probability';
    p = h.Values;
    p = h.Values;
    p(p == 0) = 1;
    e_h = -sum(p.*log2(p));
    
    [M,N,C]=size(S);
    S=reshape(S,[M*N,C]);
    edges=linspace(0,100,32);
    h = histogram(S, edges);
    h.Normalization = 'probability';
    p = h.Values;
    p = h.Values;
    p(p == 0) = 1;
    e_s = -sum(p.*log2(p));
    
    ce=(e_h+e_s)/2;
end


function b = balance(leaves, width, height)
    top = [];
    right = [];
    left = [];
    bottom = [];

    for l = 1:length(leaves)
        if leaves(l,1) > width / 2
            right = [right; leaves(l,:)];
        else
            left = [left; leaves(l,:)];
        end
        
        if leaves(l,2) > height / 2
            bottom = [bottom; leaves(l,:)];
        else
            top = [top; leaves(l,:)];
        end
    end

    w_left = 0.0;
    w_top = 0.0;
    w_bottom = 0.0;
    w_right = 0.0;
    center = [width / 2, height / 2];

    for l = 1:length(top)
        area = top(l,3) * top(l,4);
        mid_point_leaf = [top(l,1) + top(l,3) / 2, top(l,2) + top(l,4) / 2];
        X=[mid_point_leaf;center];
        distance = pdist(X,'euclidean');
        score = distance * area;
        w_top = w_top+score;
    end
    for l = 1:length(bottom)
        area = bottom(l,3) * bottom(l,4);
        mid_point_leaf = [bottom(l,1) + bottom(l,3) / 2, bottom(l,2) + bottom(l,4) / 2];
        X=[mid_point_leaf;center];
        distance = pdist(X,'euclidean');
        score = distance * area;
        w_bottom = w_bottom+score;
    end
    for l = 1:length(left)
        area = left(l,3) * left(l,4);
        mid_point_leaf = [left(l,1) + left(l,3) / 2, left(l,2) + left(l,4) / 2];
        X=[mid_point_leaf;center];
        distance = pdist(X,'euclidean');
        score = distance * area;
        w_left = w_left+score;
    end
    for l = 1:length(right)
        area = right(l,3) * right(l,4);
        mid_point_leaf = [right(l,1) + right(l,3) / 2, right(l,2) + right(l,4) / 2];
        X=[mid_point_leaf;center];
        distance = pdist(X,'euclidean');
        score = distance * area;
        w_right = w_right+score;
    end
    IB_left_right = (w_left - w_right) / max(abs(w_right), abs(w_right));
    IB_top_bottom = (w_top - w_bottom) / max(abs(w_top), abs(w_bottom));
    b = 1 - (abs(IB_top_bottom) + abs(IB_left_right)) / 2;    
end

function s = symmetry(leaves, width, height)
    UL_leaves = [];
    UR_leaves = [];
    LL_leaves = [];
    LR_leaves = [];

    for l = 1:length(leaves)
        
        if leaves(l,1) > width / 2 && leaves(l,2) < height / 2
            UR_leaves = [UR_leaves; leaves(l,:,:,:,:)];
        elseif leaves(l,1) <= width / 2 && leaves(l,2) < height / 2
            UL_leaves=[UL_leaves; leaves(l,:,:,:,:)];
        elseif leaves(l,1) > width / 2 && leaves(l,2) >= height / 2 -1
            LR_leaves=[LR_leaves; leaves(l,:,:,:,:)];
        elseif leaves(l,1) <= width / 2 && leaves(l,2) >= height / 2 -1
            leaves(l,:)
            LL_leaves = [LL_leaves; leaves(l,:,:,:,:)];
        end
    end
    
    X_j = [];
    Y_j = [];
    H_j = [];
    B_j = [];
    T_j = [];
    R_j = [];
    
    all_leaves{1}=UL_leaves;
    all_leaves{2}=UR_leaves;
    all_leaves{3}=LL_leaves;
    all_leaves{4}=LR_leaves;
    
    
    x_center = width / 2;
    y_center = height / 2;

    for j = 1:length(all_leaves)
        X_score = 0;
        Y_score = 0;
        H_score = 0;
        B_score = 0;
        T_score = 0;
        R_score = 0;
        
        leaf=all_leaves{1,j};
        [m,n]=size(leaf);  
        for l = 1:m
            x_leaf = (leaf(l,1) + leaf(l,3)) / 2;
            X_score = X_score + abs(x_leaf - x_center);
            y_leaf = (leaf(l,2) + leaf(l,4))  / 2;
            Y_score = Y_score + abs(y_leaf - y_center);
            H_score = H_score + leaf(l,4);
            B_score = B_score + leaf(l,3);
            T_score = T_score + abs(y_leaf - y_center) / abs(x_leaf - x_center);
            R_score = R_score + (((x_leaf - x_center)^2) + ((y_leaf - y_center)^2))^0.5;
        end
        X_j = [X_j; X_score];
        Y_j = [Y_j; Y_score];
        H_j = [H_j; H_score];
        B_j = [B_j; B_score];
        T_j = [T_j; T_score];
        R_j = [R_j; R_score];
    end
    
    X_j = X_j/max(X_j);
    Y_j = X_j/max(X_j);
    H_j = X_j/max(X_j);
    B_j = X_j/max(X_j);
    T_j = X_j/max(X_j);
    R_j = X_j/max(X_j);
    
    SYM_ver = (abs(X_j(1,1) - X_j(2,1)) + abs(X_j(3,1) - X_j(4,1)) + abs(Y_j(1,1) - Y_j(2,1)) + abs(Y_j(3,1) - Y_j(4,1)) + abs(H_j(1,1) - H_j(2,1)) + abs(H_j(3,1) - H_j(4,1)) + abs(B_j(1,1) - B_j(2,1)) + abs(B_j(3,1) - B_j(4,1)) + abs(T_j(1,1) - T_j(2,1)) + abs(T_j(3,1) - T_j(4,1)) + abs(R_j(1,1) - R_j(2,1)) + abs(R_j(3,1) - R_j(4,1))) / 12;

    SYM_hor = (abs(X_j (1,1) - X_j(3,1)) + abs(X_j(2,1) - X_j(4,1)) + abs(Y_j(1,1) - Y_j(3,1)) + abs(Y_j(2,1) - Y_j(4,1)) + abs(H_j(1,1) - H_j(3,1)) + abs(H_j(2,1) - H_j(4,1)) + abs(B_j(1,1) - B_j(3,1)) + abs(B_j(2,1) - B_j(4,1)) + abs(T_j(1,1) - T_j(3,1)) + abs(T_j(2,1) - T_j(4,1)) + abs(R_j(1,1) - R_j(3,1)) + abs(R_j(2,1) - R_j(4,1))) / 12;

    SYM_rot = (abs(X_j(1,1) - X_j(4,1)) + abs(X_j(2) - X_j(3,1)) + abs(Y_j(1,1) - Y_j(4,1)) + abs(Y_j(2,1) - Y_j(3,1)) + abs(H_j(1,1) - H_j(4,1)) + abs(H_j(2,1) - H_j(3,1)) + abs(B_j(1,1) - B_j(4,1)) + abs(B_j(2,1) - B_j(3,1)) + abs(T_j(1,1) - T_j(4,1)) + abs(T_j(2,1) - T_j(3,1)) + abs(R_j(1,1) - R_j(4,1)) + abs(R_j(2,1) - R_j(3,1))) / 12;

    s = 1 - (abs(SYM_ver) + abs(SYM_hor) + abs(SYM_rot)) / 3;
end

function e = equilibrium(leaves, width, height)
    area = [];
    dx = [];
    dy = [];
    
    for l = 1:length(leaves)
        
        area = [area (leaves(l,3) *leaves(l,4))];
        dx = [dx abs(leaves(l,1) + leaves(l,3) / 2) - (width / 2)];
        dy = [dy abs(leaves(l,2) + leaves(l,4) / 2) - (height / 2)];
    end

    sum_x = 0.0;
    sum_y = 0.0;
    for n = 1:length(dx)
        sum_x = sum_x + area(n) * dx(n);
        sum_y = sum_x + area(n) * dx(n);
    end
    EM_x = (2 * sum_x) / (width * length(leaves) * sum(area));
    EM_y = (2 * sum_y) / (height * length(leaves) * sum(area));

    e = 1 - (abs(EM_x) + abs(EM_y)) / 2;
end



