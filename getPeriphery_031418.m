function [total, pixels] = getPeriphery_031418(image, radius, mask)

    % This function generates a 4-pixel-wide mask around the periphery of
    % the largest object in an image, sums the fluorescence intensity in
    % the space included in the mask, and sums the total number of pixels
    % involved in the mask.
    %
    % takes in: a matrix representing the image, a user-defined radius for
    % the erosion structuring element, and a filled mask of the entire
    % largest object in the images
    %
    % returns: the total fluorescence intensity of a 4-pixel-wide masked
    % area around the perimeter and the total number of pixels used in the
    % mask
    
    close all;
    
    % makes a user-defined-width mask around the periphery of an object,
    % calculates the total intensity of the masked area, and the number of
    % pixels included in the mask
    greyimage = mat2gray(image);
    se = strel('disk', radius);
    eroded = imerode(mask, se);
    eroded = imcomplement(eroded);
    edgemask = and(mask, eroded);
    imtool(edgemask,[]);
    greyimage(~edgemask) = 0; 
    imtool(greyimage,[]);
    
    % collects the total intensity of the image in the masked area and the
    % number of pixels included in the mask as outputs
    total = sum(sum(greyimage));
    pixels = sum(sum(edgemask));
    
end