close all;

% This script loads in all .czi images in a folder, generates a mask for
% each using the getMask function, then calls getPeriphery and getCentroid
% on each image. The data collected by each function is stored in an output
% array which is written to a .csv file at the end of the script. Data
% collected includes the file name of the image, the total intensity around
% the periphery, the number of pixels collected for the periphery, the
% average intensity for the periphery, the total intensity around the
% centroid, the number of pixels collected for the centroid, the average
% intensity around the centroid, and the ratio of average periphery
% intensity to average centroid intensity for both red and green channels.

% prompts the user with a dialog box to select the image folder
path = uigetdir('','Select image folder');

% sets the user-defined radius of the centroid structuring element
prompt = {'Enter centroid size:','Enter periphery size:'};
defaultsizes = {'5', '10'};
se_sizes = inputdlg(prompt, 'Enter structuring element sizes',...
    1, defaultsizes);
centroid_se_radius = str2double(se_sizes{1});
periphery_se_radius = str2double(se_sizes{2});

% limits inputs to .czi files    
filenames = dir(fullfile(path,'*.czi*'));   
    
% initializes an array to hold the image matrices    
red_image_array = cell(length(filenames),1);
green_image_array = red_image_array;
    
% initializes an ouput array with fields for all collected data    
output_array = cell(length(filenames), 17);

% reads all images in the selected folder and puts them in a cell array
for i = 1:length(filenames)
    filename = filenames(i).name;
    output_array{i, 1} = filename;
    filename = fullfile(path, filename);
    czi = bfGetReader(filename);
    red_image_array{i} = bfGetPlane(czi, 2); % the 2nd plane is the red channel
    green_image_array{i} = bfGetPlane(czi, 1);
end

fclose('all');

% calls the getMask, getPeriphery, and getCentroid functions on each image
% in the array and puts the data in the output cell array
for j = 1:length(red_image_array)
    [mask, maskarea, redsum] = getMask_031418(green_image_array{j},...
        red_image_array{j});
    [periph_red, periph_pixel_num] = getPeriphery_031418(...
        red_image_array{j}, periphery_se_radius, mask);
    [cent_red, cent_pixel_num] = getCentroid_031418(red_image_array{j}, ...
        centroid_se_radius, mask, periphery_se_radius);
    [periph_green, ~] = getPeriphery_031418(green_image_array{j},...
        periphery_se_radius, mask);
    [cent_green, ~] = getCentroid_031418(green_image_array{j},...
        centroid_se_radius, mask, periphery_se_radius);
    output_array{j, 2} = redsum;
    output_array{j, 3} = maskarea;
    output_array{j, 4} = redsum/maskarea;
    output_array{j, 5} = periph_red;
    output_array{j, 6} = periph_pixel_num;
    output_array{j, 7} = periph_red/periph_pixel_num;
    output_array{j, 8} = cent_red;
    output_array{j, 9} = cent_pixel_num;
    output_array{j, 10} = cent_red/cent_pixel_num;
    output_array{j, 11} = periph_green;
    output_array{j, 12} = periph_green/periph_pixel_num;
    output_array{j, 13} = cent_green;
    output_array{j, 14} = cent_green/cent_pixel_num;
    output_array{j, 15} = output_array{j, 7}/output_array{j, 12};
    output_array{j, 16} = output_array{j, 10}/output_array{j, 14};
    output_array{j, 17} = output_array{j, 15}/output_array{j, 16};
end

% converts the output cell array to a table with the indicated headers
output_table = cell2table(output_array, 'VariableNames', {'FileName'...
    'MaskTotal' 'MaskArea' 'MaskAverage' 'PeripheryTotal'...
    'PeripheryArea' 'PeripheryAverage' 'PLITotal' 'PLIArea'...
    'PLIAverage', 'GreenPeripheryTotal', 'GreenPeripheryAverage'...
    'GreenPLITotal', 'GreenPLIAverage', 'PeriphRatio', ...
    'PLIRatio', 'PeriphRatio_over_PLIRatio'});

% writes the table to a .csv file of the desired filename
[outputfile, outputpath] = uiputfile('*.csv','Save output table');
fulloutput = fullfile(outputpath, outputfile);
writetable(output_table, fulloutput);


fclose('all');


    