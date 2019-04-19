function [mask, area, redsum] = getMask_041919(greenimage, redimage)

    % This function generates a logical mask whose values are 1 around the
    % periphery of a region of interest and zero everywhere else. Only the
    % largest object in each field that is not touching the edge of the
    % field is considered. This function also locates the coordinates of
    % the centroid of the object.
    %
    % takes in: a matrix representing the images
    %
    % returns: a filled-in mask of the entire largest object in the image,
    % and the coordinates of its centroid
    
    close all;
    
    % reads in the images, converts them to greyscale, and converts them to
    % binary images based on the calculated threshold
    imtool(greenimage,[]);
    greengrey = mat2gray(greenimage);
    thresh = graythresh(greengrey);
    bin = imbinarize(greengrey, thresh);
    
    % opens and closes the binary image to generate the solid ROI
    se = strel('disk',2); % mess with this
    opened = imopen(bin, se);
    se = strel('disk',4); % mess with this
    closed = imclose(opened, se);
    
    % fills in the object to create a single solid white object
    filled = imfill(closed,'holes');
    
    % clears any objects that touch the edge of the field
    filled = imclearborder(filled);
    
    % sets all but the largest object in the field to black
    props = regionprops(filled,'Area','PixelIdxList');
    sizeprops = size(props);
    maxarea = max([props.Area]);
    for x=1:sizeprops(1)
        if props(x).Area < maxarea
            filled(props(x).PixelIdxList) = 0;
        end
    end
    imtool(filled,[]);
    
    % finds the sum pixel intensity of the red channel of the mask
    redgray = mat2gray(redimage);
    redgray(~filled) = 0;
    
    % outputs the final mask and the coordinates of the centroid
    props = regionprops(filled, 'Area');
    mask = filled;
    area = props(1).Area;
    redsum = sum(sum(redgray));
    
end