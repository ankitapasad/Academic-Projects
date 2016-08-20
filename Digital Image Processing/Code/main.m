%% CS 663: Fundamentals of Digital Image Processing 
% *Course Project* on _Vector-Valued Image Regularization with PDEs_
%
%  Find the paper at: https://tschumperle.users.greyc.fr/publications/tschumperle_pami05.pdf
%  Project Proposal: http://home.iitb.ac.in/~praveen.agrawal/Proposal.pdf
%
%  Team members:
%  ===========================
%  Ankita Pasad       12D070021
%  Himanshi Swarnkar  120100065
%  Praveen Agrawal    12D020030

%% Image Regularization

clear;
clc;
tic;
myNumOfColors = 256;
myColorScale = [ (0:1/(myNumOfColors-1):1)' , (0:1/(myNumOfColors-1):1)' , (0:1/(myNumOfColors-1):1)' ];
imgInput = imread('../Input/face.jpg');
filter = fspecial('gaussian', [5 5], 0.66);
imgInput = imfilter(imgInput, filter);
imgOrig = imgInput;
h = waitbar(0,'Wait Please');
dt = 0.01;
tEnd = 1;
for t = 0:dt:tEnd
    t
    imgTemp = imageRegularize(imgOrig);
    imgOutput =  im2double(imgOrig) + dt*imgTemp;
    imgOrig= imgOutput;
    if t==0.05 || t==0.1 || t==0.5 
        figure();
        imshowpair(imgInput,imgOutput,'montage','scaling','none');
        title(num2str(t), 'FontWeight','bold');
    end
     waitbar(t/tEnd);
end
close(h);
figure;
imshowpair(imgInput,imgOutput,'montage','scaling','none');
toc;

%% Image Inpainting

tic;
imgInput = imread('../Input/inpaintParrotCage.jpg');
mask = imread('../Input/parrotCageMask.jpg');
mask = mask(:,:,1);
imgOrig = imgInput;
h = waitbar(0,'Wait Please');
dt = 0.01;
tEnd = 30;
for t = 0:dt:tEnd
    t
    imgTemp = imageInpaint(imgOrig, mask);
    imgOutput =  im2double(imgOrig) + dt*imgTemp;
    imgOrig= imgOutput;
    waitbar(t/tEnd);    
    if t==5 || t==10 || t==15 || t==20 || t==25
        figure();
        imshowpair(imgInput,imgOutput,'montage','scaling','none');
        title(num2str(t), 'FontWeight','bold');
    end
end
close(h);
figure;
imshowpair(imgInput,imgOutput,'montage','scaling','none');
toc;

%% Image Supersampling

clear;
clc;
tic;
imgInput = imread('../Input/resize1.jpg');
scaleFactor = 3; % Upsample by a factor of 4
imgResized = imresize(imgInput, scaleFactor);
filter = fspecial('gaussian', [5 5], 0.66);
imgSmoothed = imfilter(imgResized, filter);
imgOrig = imgSmoothed;
h = waitbar(0,'Wait Please');
dt = 0.01;
tEnd = 2;
for t = 0:dt:tEnd
    t
    imgTemp = imageRegularize(imgOrig);
    imgOutput =  im2double(imgOrig) + dt*imgTemp;
    imgOrig= imgOutput;
    if(t==1 || t==1.5 || t==0.5)
        figure;
        imshowpair(imgResized,imgOutput,'montage','scaling','none');
        title(num2str(t), 'FontWeight','bold');
        file = strcat(num2str(t),'_image1.png');
    end
    waitbar(t/tEnd);
end
close(h);
figure;
imshowpair(imgResized,imgOutput,'montage','scaling','none');
title('Resized Image', 'FontWeight','bold');
toc;


%% Flow Visualization

clear;
clc;
tic;
myNumOfColors = 256;
myColorScale = [ (0:1/(myNumOfColors-1):1)' , (0:1/(myNumOfColors-1):1)' , (0:1/(myNumOfColors-1):1)' ];
imgIn = imread('../Input/face.jpg');
filter = fspecial('gaussian', [5 5], 0.66);
imgInput = imfilter(imgIn, filter);
imgOrig = imgInput;
h = waitbar(0,'Wait Please');
dt = 0.01;
tEnd = 10;
for t = 0:dt:tEnd
    t
    imgTemp = flowVisualization(imgOrig);
    imgOutput =  im2double(imgOrig) + dt*imgTemp;
    imgOrig= imgOutput;
       if t==1 || t==3 || t==5 || t==7 || t==9 
        figure();
        imshowpair(imgInput,imgOutput,'montage','scaling','none');
        title(num2str(t), 'FontWeight','bold');
       end
     waitbar(t/tEnd);
end
close(h);
figure;
imshowpair(imgInput,imgOutput,'montage','scaling','none');
toc;