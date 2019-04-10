# droplet
MATLAB code for microcolony droplets

This code takes in all .czi-formatted images in a directory, and calculates the ratio of fluorescence intensity between the periphery of the microcolony object and the point of lowest intensity (PLI) of the same object. This code requires the user to have access to MATLAB with the image processing toolbox installed, as well as the bioformats package offered by the Open Microscopy Environment.

The three functions called by peripheryScript are getMask, getPeriphery, and getCentroid.

getMask generates a binary mask representing the largest contiguous object in the field of view, and removing any artifacts or incomplete objects.

getPeriphery converts the whole-object mask into a periphery mask using a structuring element of user-specified radius.

getCentroid calculates a mask of user-specified radius sampling the PLI of the object.

peripheryScript applies the periphery and PLI masks to the raw image data and calculates area-normalized periphery-to-PLI fluorescence intensity ratios.

Detailed information about the performance of the script and each function can be found at the top of each file.
