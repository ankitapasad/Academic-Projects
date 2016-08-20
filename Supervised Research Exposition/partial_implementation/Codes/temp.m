imgIn = imread('barbara.png');
[rows,~] = size(imgIn);
imgA = imgIn(rows/4:3*rows/4,rows/4:3*rows/4);
theta = 20*pi/180;
rotMatrix = [cos(theta), -1*sin(theta); sin(theta),cos(theta)];