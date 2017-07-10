
%%ADD PATH - if you list a new metric in a subfolder make sure to add the
%%path to the folder. 
addpath('am10_FC_am11_SE')


%%SELECT DATA FOLDER - default data is in subfolder 'data'%%
d = uigetdir(pwd, 'Select a folder');
files_jpg = dir(fullfile(d, '*.jpg'));
files_png = dir(fullfile(d, '*.png'));



%%SET VARIABLES, SOME METRICS ARE MULTI METRIC, HENCE THIS DIFFERS%%
n_of_metrics = 4;
n_of_metrics_results = 35;


%%create results array, time_tracker is for effieceny. mr stores all
%%results from all metrics per interface. add two rows to store the mean
%%and standard deviation. +1 is for headers 

time_tracker = zeroes(n_of_metrics+1,length(files_jpg)+2+1);
mr =zeroes(n_of_metric_results+1,length(files_jpg)+2+1);



%%ADD YOUR METRIC HERE - 
for file = 1:length(files_jpg)
    filepath = strcat(d,'\',files_jpg(file).name);
    
    mr(1,file+1) = files_jpg(file).name
    
    tic
    mr(2,file+1) = am1_filesize_jpg_or1_filesize_png(filepath);
    time_tracker(1,file+1)=toc;
    
    tic
    mr(3,file+1) = am1_filesize_jpg_or1_filesize_png(strcat(d,'\',files_png(file).name));
    time_tracker(2,file+1)=toc;
    
    tic
    mr(4,file+1) = am2_number_of_colours(filepath);
    time_tracker(3,file+1)=toc;
    
    tic
    mr(5,file+1) = am3_dynamic_cluster(filepath);
    time_tracker(4,file+1)=toc;
    
    tic
    [mr(6,file+1),mr(7,file+1),mr(8,file+1),mr(9,file+1),mr(10,file+1)] = am4_hsv_average(filepath);
    time_tracker(5,file+1)=toc;
    
    tic
    [mr(11,file+1),mr(12,file+1),mr(13,file+1),mr(14,file+1)] = am5_uniqueHSV(filepath);
    time_tracker(6,file+1)=toc;
    
    tic
    [mr(15,file+1),mr(16,file+1),mr(17,file+1),mr(18,file+1),mr(19,file+1),mr(20,file+1)] = am4_LAB_avg(filepath);
    time_tracker(7,file+1)=toc;
    
    tic
    [mr(21,file+1), mr(22,file+1), mr(23,file+1), mr(24,file+1), mr(25,file+1), mr(26,file+1), mr(27,file+1)] = am7_hassler_susstrunk(filepath);
    time_tracker(8,file+1)=toc;
    
    tic
    mr(28,file+1) = am8_static_cluster(filepath);
    time_tracker(9,file)=toc;
    
    tic
    mr(29,file+1)=dc1_edge_density(filepath);
    time_tracker(10,file+1)=toc;
    
    tic
    mr(30,file+1) = dc2_figure_ground_contrast(filepath);
    time_tracker(11,file+1)=toc;
    
    tic
    mr(31,file+1) = dc3_edge_congestion(filepath);
    time_tracker(12,file+1)=toc;
    
    tic
    mr(32,file+1) = or2_pixel_symmetry(filepath);
    time_tracker(13,file+1)=toc;
    
    tic
    [mr(33,file+1),mr(34,file+1),mr(35,file+1),mr(36,file+1)] = or3_quadtree(filepath);
    time_tracker(14,file+1)=toc;
    
end





