function [ imgOutput ] = flowVisualization( imgInput )
    imgInput = im2double(imgInput);
    Red = imgInput(:,:,1);
    Green = imgInput(:,:,2);
    Blue = imgInput(:,:,3);
    [rows, columns] = size(Red);
    
    % Gradient function uses :-
    % 1. Central difference for non border pixels
    % 2. Forward difference for 1st column (likewise for row)
    % 3. Backward Difference for last column (likewise for row)
    
    [IxRed, IyRed] = gradient(Red);
    [IxGreen, IyGreen] = gradient(Green);
    [IxBlue, IyBlue] = gradient(Blue);
    
    IxxRed = myImageGradientXX(Red);
    IxxGreen = myImageGradientXX(Green);
    IxxBlue = myImageGradientXX(Blue);
    
    IyyRed = myImageGradientYY(Red);
    IyyGreen = myImageGradientYY(Green);
    IyyBlue = myImageGradientYY(Blue);
    
    IxyRed = myImageGradientXY(Red);
    IxyGreen = myImageGradientXY(Green);
    IxyBlue = myImageGradientXY(Blue);
    
    Ix = cat(3, IxRed, IxGreen, IxBlue);
    Iy = cat(3, IyRed, IyGreen, IyBlue);
    
    windowSize = 5;
    padIx = zeros(rows+2*windowSize, columns+2*windowSize, 3);
    padIy = zeros(rows+2*windowSize, columns+2*windowSize, 3);
    padIx(windowSize+1:windowSize+rows, windowSize+1:windowSize+columns, :) = Ix;
    padIy(windowSize+1:windowSize+rows, windowSize+1:windowSize+columns, :) = Iy;
    
    padIx2 = padIx.*padIx;
    padIy2 = padIy.*padIy;
    padIxIy = padIx.*padIy;
    weight = fspecial('gaussian', [windowSize windowSize], 2);
    
    traceRed = zeros(size(IxRed));
    traceBlue = zeros(size(IxRed));
    traceGreen = zeros(size(IxRed));
    for i = 1:1:rows
        for j = 1:1:columns
            Field = [3*sign(i-(rows/2));3*sign(j-(columns/2))];
            F = (Field*Field')/norm(Field);
            Hred = [IxxRed(i,j), IxyRed(i,j); IxyRed(i,j), IyyRed(i,j)];
            Hblue = [IxxBlue(i,j), IxyBlue(i,j); IxyBlue(i,j), IyyBlue(i,j)];
            Hgreen = [IxxGreen(i,j), IxyGreen(i,j); IxyGreen(i,j), IyyGreen(i,j)];
            
            traceRed(i,j) = trace(F*Hred);
            traceBlue(i,j) = trace(F*Hblue);
            traceGreen(i,j) = trace(F*Hgreen);
        end
    end
    imgOutput = cat(3, traceRed, traceGreen, traceBlue);
end

