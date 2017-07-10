function sym = or2_pixel_symmetry(filepath)
    I = imread(filepath);
    I = im2uint8(I);
    I = rgb2gray(I);
    tresh_canny=[0.11,0.27];
    BW = edge(I,'Canny',tresh_canny,5);
    
    [N,M,~]=size(BW);

    radius = 3;
    all_key=0;
    
    for x = 1:M
        for y = 1:N
            if BW(y,x)~=0
                all_key=all_key+1;
                pixels_in_radius= get_pixels_in_radius(y,x,M,N,radius);
            
                for i = 1:length(pixels_in_radius)
                    BW(pixels_in_radius(i,1),pixels_in_radius(i,2)) = 0;
                end
         
            end
        end
    end
    
    sym_radius=4;
    sym_key=0;
    for x = 1:M
        for y = 1:N
            if BW(y,x) == 1
               
                vertical_pixels = get_pixels_in_radius(y,M-x,M,N,sym_radius);
                horizontal_pixels = get_pixels_in_radius(N-y,x,M,N,sym_radius);
                
                for i = 1:length(vertical_pixels)
                    if BW(vertical_pixels(i,1),vertical_pixels(i,2)) == 1
                        sym_key=sym_key+1;                      
                    end
                end
                
                for i = 1:length(horizontal_pixels)
                    if BW(horizontal_pixels(i,1),horizontal_pixels(i,2)) == 1
                        sym_key=sym_key+1;
                    end
                end
            end
        end
    end
    sym = (sym_key/all_key).*(((all_key-1)*sym_radius)/(M * N)).^-1;
end


function pixels = get_pixels_in_radius(y,x,width,height,radius)
    if x < radius
       rad_x_left=-x;
       rad_x_right=radius;
    elseif width-x<radius
       rad_x_right = (width - x);
       rad_x_left = -radius;  
    else
       rad_x_left = -radius;
       rad_x_right = radius;  
    end

    if y < radius
       rad_y_top = -y;
       rad_y_bottom = radius;
    elseif height - y < radius
       rad_y_bottom = (height - y);
       rad_y_top = -radius;
    else
       rad_y_top = -radius;
       rad_y_bottom = radius;
    end
    
    pixels = [];
    for m = rad_x_left:rad_x_right
        for n = rad_y_top:rad_y_bottom
           if (m ~= 0 || n~=0) && x+m>0 && y+n>0
            pixel = [x+m,y+n];
            pixels = [pixels; pixel]; 
           end
        end
    end 
end
