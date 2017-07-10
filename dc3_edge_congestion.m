function result = dc3_edge_congestion(filepath)
    RGB = imread(filepath);
    RGB = im2uint8(RGB);
    [N,M,~]=size(RGB);
    borders=zeros(N,M);
    
    for x = 2:M-2
        for y=2:N-2
            borders(y,x)=get_distance(RGB,borders,y,x);
        end
    end
    
    count_edge=0;
    count_uncongested=0;
    tresh=20;
    
    for x = tresh+1:M-tresh-1
        for y=tresh+1:N-tresh-1
            if borders(y,x) == 255
               count_edge = count_edge+1;
               arr_right=borders(y,x+1:x+tresh);
               sum_right=sum(arr_right);
               arr_left=borders(y,x-tresh:x-1);
               sum_left=sum(arr_left);
               arr_up=borders(y+1:y+tresh,x);
               sum_up=sum(arr_up);
               arr_down=borders(y-tresh:y-1,x);
               sum_down=sum(arr_down);          
              
               if sum_right == 0 || sum_left==0 || sum_up ==0 || sum_down==0
                   count_uncongested = count_uncongested+1;
               end
               
            end
        end
    end
    count_congested=count_edge-count_uncongested;
    result=count_congested/count_edge;    
end


function ret = get_distance(img,borders,y,x)
    r1=img(y,x,1);
    g1=img(y,x,2);
    b1=img(y,x,3);
    points_2 = [x+1,y; x-1,y;x,y+1;x,y-1];
    ret=0;
    for n = 1:4
        x2=points_2(n,1);
        y2=points_2(n,2);
        
        r2=img(y2,x2,1);
        g2=img(y2,x2,2);
        b2=img(y2,x2,3);
        
        dst_r = abs(r2-r1);
        dst_g = abs(g2-g1);
        dst_b = abs(b2-b1);
        
        if (dst_r > 50 || dst_g >50 || dst_b > 50) && borders(y2,x2)==0 
            ret=255;
            break;
        end
    end

end