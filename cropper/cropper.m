% Crop spindle through time and z-planes
% FILENAME FOR INITIAL IMAGE: 01 - 
% ---------------------------------------------------------------------- %
% PRE-STEPS
% ---------------------------------------------------------------------- %

%%%     Clear command window
clc;
%%%     Clear variables from prior run of this m-file
clearvars;
%%%     Show the whole workpace panel
workspace;
%%%     Close all imtool figures
imtool close all;
% ---------------------------------------------------------------------- %

%%
% figure
clear;

% OPTION (1 single, 0 = default - all)
optionVar = 0;



inputFolder = fullfile('Input');
outputFolder = fullfile('Output');

if ~exist(inputFolder,'dir')
    mkdir(inputFolder);
    disp('Creating input folder...');
    disp('Please copy images to input folder...');
end



if ~exist(outputFolder,'dir')
    mkdir(outputFolder);
    disp('Creating output folder...');
end

addpath('Input'); % Functions folder
addpath('Output'); % Automated labeling algorithm folder

imds = imageDatastore(inputFolder);

% SET WINDOWS SIZE (Window should bewithin the original image size)
widthObject = 320; % <------------------------- for later, change with knob
heightObject = 320; % <------------------------- for later, change with knob
rescaleSizeWidth = 320;
rescaleSizeHeight = 320;


if optionVar == 1

%%
while hasdata(imds)
        [tempImg, info] = read(imds);
        nullImg = tempImg;
% Pick the first image
% nullImg = readimage(imds,1);
% Get the dimension of the original image
[heightImg, widthImg,~] = size(nullImg);
% Display the image
imshow(nullImg)
% Get coordinates, verify with 'Enter'
[y, x] = ginput(1);

% Delete initial image
% imgContainer(1) = [];
% Get X coordinate of the top left corner
canvasXTopLeft = x - widthObject/2;
% Get Y coordinate of the top left corner
canvasYTopLeft = y - heightObject/2;
% Define a rectangle to crop
rect = [canvasYTopLeft canvasXTopLeft heightObject-1 widthObject-1];

% Create empty canvas to display the pre-cropped area
canvas = zeros(heightImg, widthImg);
% Shape the area of the rectangle with 1
canvas(ceil(canvasYTopLeft):ceil(canvasYTopLeft+heightObject), ceil(canvasXTopLeft):ceil(canvasXTopLeft+widthObject)) = 1;
% Trace the boundaries
boundBox = bwboundaries(canvas);
% Call the boundary pixels X and Y
boundBox = boundBox{1};
% Show the initial image
imshow(nullImg)
% Hold on
hold on
% Overlay the pre-cropped box on the initial image
plot(boundBox(:,1), boundBox(:,2), 'Color', 'r', 'Linewidth', 4, 'LineStyle', '-')
% Hold off
hold off


% while hasdata(imds)
    % Read an image.
%    [tempImg, info] = read(imds);
    cropImg = imcrop(tempImg, rect);
    
    % Read dimension of cropped image
    [cropHeight, cropWidth, ~] = size(cropImg);
    if cropHeight ~= rescaleSizeHeight || cropWidth ~= rescaleSizeWidth
        cropImg = imresize(cropImg, [rescaleSizeHeight rescaleSizeWidth], ...
            'nearest');
    else
        % Do nothing
    end
    % Write to disk.
    [~, filename, ext] = fileparts(info.Filename);
    % Add slash to write the file in a proper path
    outputFile = fullfile(outputFolder, '/');
    imwrite(cropImg, [outputFile filename ext])
    
    A = [x; y];
fileID = fopen('cropCoordinates.txt','w');
fprintf(fileID,'%6.4s %6.4s\n','X','Y');
fprintf(fileID,'%6.4f %6.4f\n', A);
fclose(fileID);
end

else


nullImg = readimage(imds,1);
% Get the dimension of the original image
[heightImg, widthImg,~] = size(nullImg);
% Display the image
imshow(nullImg)
% Get coordinates, verify with 'Enter'
[y, x] = ginput(1);

% Delete initial image
% imgContainer(1) = [];

% Get X coordinate of the top left corner
canvasXTopLeft = x - widthObject/2;
% Get Y coordinate of the top left corner
canvasYTopLeft = y - heightObject/2;
% Define a rectangle to crop
rect = [canvasYTopLeft canvasXTopLeft heightObject-1 widthObject-1];

% Create empty canvas to display the pre-cropped area
canvas = zeros(heightImg, widthImg);
% Shape the area of the rectangle with 1
canvas(ceil(canvasYTopLeft):ceil(canvasYTopLeft+heightObject), ceil(canvasXTopLeft):ceil(canvasXTopLeft+widthObject)) = 1;
% Trace the boundaries
boundBox = bwboundaries(canvas);
% Call the boundary pixels X and Y
boundBox = boundBox{1};
% Show the initial image
imshow(nullImg)
% Hold on
hold on
% Overlay the pre-cropped box on the initial image
plot(boundBox(:,1), boundBox(:,2), 'Color', 'r', 'Linewidth', 4, 'LineStyle', '-')
% Hold off
hold off


while hasdata(imds)
    % Read an image.
    [tempImg, info] = read(imds);
    cropImg = imcrop(tempImg, rect);
    % Read dimension of cropped image
    [cropHeight, cropWidth, ~] = size(cropImg);
    if cropHeight ~= rescaleSizeHeight || cropWidth ~= rescaleSizeWidth
        cropImg = imresize(cropImg, [rescaleSizeHeight rescaleSizeWidth], ...
            'nearest');
    else
        % Do nothing
    end
    % Write to disk.
    [~, filename, ext] = fileparts(info.Filename);
    % Add slash to write the file in a proper path
    outputFile = fullfile(outputFolder, '/');
    imwrite(cropImg, [outputFile filename ext])
end

end

close all

