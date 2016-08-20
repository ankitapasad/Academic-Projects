function img_shift = transformation(img_cut,theta)
% Load image
% Apply transformations
% Divide into patches (p x p): N patches in all
% Graph: N x N matrix with elemets as weights to the patch similarity
% Histogram Intersection for weights
%% Parameters to be fixed
% patch_size = 10;
% thresh = 0;
% theta = 20*pi/180;
tx = 0;
ty = 0;

%% Reading the image
% img = imread('lena.jpg');
% img = rgb2gray(img);
% [xs, ys] = size(img);
% img_cut = img(ceil(xs/4):ceil(3*xs/4),ceil(ys/4):ceil(3*ys/4));
% imgIn = imread('barbara.png');
% [rows,~] = size(imgIn);
% img_cut = imgIn(rows/4:3*rows/4,rows/4:3*rows/4);
%% Transforming the image
R = [cos(theta), -1*sin(theta), tx;
    sin(theta), cos(theta), ty;
    0, 0, 1];
img_shift = transform(img_cut,R);
% figure()
% imshow(img_cut);
% figure()
% imshow(img_shift);

%% Dividing into patches
% hist_int(img_cut,img_shift);
end