function [total, pixels, loc] = getCentroid_041919(image, centroidsize, ...
    mask, periphery)

    % This function uses the image, the user-specified radius of the
    % structuring element, and the coordinates of the centroid to calculate
    % the fluorescence intensity around the centroid. The function also
    % records the number of pixels examined for the intensity.
    %
    % takes in: a matrix representing the image, a value for the radius of
    % the dilating structuring element, and the coordinates of the centroid
    % of the largest object in the image
    %
    % returns: the total fluorescence intensity of the area dilated around
    % the centroid and the total number of pixels used to capture this
    % sample
    
    close all;

    % makes a mask around the centroid by dilating the centroid pixel with
    % a disk-shaped structuring element of the user-specified radius
    greyimage = mat2gray(image);
    blurred = imgaussfilt(greyimage, 2);
    erodese = strel('disk', periphery);
    mask = imerode(mask, erodese);
    blurred(~mask) = 1;
    [~, mincoords] = min(blurred(:));
    se = strel('disk', centroidsize);
    imagesize = size(image);
    blank = zeros(imagesize);
    blank = imbinarize(blank);
    [row, col] = ind2sub(imagesize, mincoords);
    blank(row, col) = 1;
    dilated = imdilate(blank, se);
    imtool(dilated,[]);
    greyimage(~dilated) = 0;
    imtool(greyimage,[]);
    
    % collects the total number of pixels used for the mask, and the sum of
    % the intensities of those pixels
    total = sum(sum(greyimage));
    pixels = sum(sum(dilated));
    loc = dilated;
    
end