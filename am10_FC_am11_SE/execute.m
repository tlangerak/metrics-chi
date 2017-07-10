function [result]=execute(filepath)

    [clutter_fc, clutter_map_fc] = getClutter_FC(filepath);
    %
    % get Subband Entropy clutter of the test map
    clutter_se = getClutter_SE(filepath);
    %
    % compute and display color clutter map(s)
    [colour_clutter_levels, colour_clutter_map] = colorClutter(filepath, 3);
    % compute and display contrast clutter map(s)
    [contrast_clutter_levels, contrast_clutter_map] = contrastClutter(filepath, 3, 1);
    % compute and display orientation clutter map(s)
    [orientation_clutter_levels, orientation_clutter_map] = orientationClutter(filepath, 3);
    orientation_clutter_levels=orientation_clutter_levels.';
    

    colour_clutter_average(1,1)= mean(mean(colour_clutter_levels{1,1}{1,1}));
    colour_clutter_average(1,2)= mean(mean(colour_clutter_levels{2,1}{1,1}));
    colour_clutter_average(1,2)= mean(mean(colour_clutter_levels{3,1}{1,1}));
    
    contrast_clutter_average(1,1)= mean(mean(contrast_clutter_levels{1,1}{1,1}));
    contrast_clutter_average(1,2)= mean(mean(contrast_clutter_levels{2,1}{1,1}));
    contrast_clutter_average(1,3)= mean(mean(contrast_clutter_levels{3,1}{1,1}));
    
    orientation_clutter_average(1,1)= mean(mean(orientation_clutter_levels{1,1}{1,1}));
    orientation_clutter_average(1,2)= mean(mean(orientation_clutter_levels{2,1}{1,1}));
    orientation_clutter_average(1,3)= mean(mean(orientation_clutter_levels{3,1}{1,1}));
    
    colour_clutter=mean(colour_clutter_average);
    contrast_clutter=mean(contrast_clutter_average);
    orientation_clutter=mean(orientation_clutter_average);
    
    result=[clutter_fc,clutter_se,colour_clutter,contrast_clutter,orientation_clutter];
    
end
