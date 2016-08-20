function [ imgOutput ] = imageInpaint( imgInput, mask )
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
    weight = fspecial('gaussian', [windowSize windowSize], 1.5);
    %weight = 1;
    traceRed = zeros(size(IxRed));
    traceBlue = zeros(size(IxRed));
    traceGreen = zeros(size(IxRed));
    
    for i = 1:1:rows
        for j = 1:1:columns
            if(mask(i,j,:)>0)
                G = zeros(2,2);
                Sx2Red = sum(sum(weight.*padIx2(i+floor(windowSize/2):windowSize+i+floor(windowSize/2)-1, j+floor(windowSize/2):windowSize+j+floor(windowSize/2)-1,1)));
                Sy2Red = sum(sum(weight.*padIy2(i+floor(windowSize/2):windowSize+i+floor(windowSize/2)-1, j+floor(windowSize/2):windowSize+j+floor(windowSize/2)-1,1)));
                SxSyRed = sum(sum(weight.*padIxIy(i+floor(windowSize/2):windowSize+i+floor(windowSize/2)-1, j+floor(windowSize/2):windowSize+j+floor(windowSize/2)-1,1)));

                Sx2Blue = sum(sum(weight.*padIx2(i+floor(windowSize/2):windowSize+i+floor(windowSize/2)-1, j+floor(windowSize/2):windowSize+j+floor(windowSize/2)-1,2)));
                Sy2Blue = sum(sum(weight.*padIy2(i+floor(windowSize/2):windowSize+i+floor(windowSize/2)-1, j+floor(windowSize/2):windowSize+j+floor(windowSize/2)-1,2)));
                SxSyBlue = sum(sum(weight.*padIxIy(i+floor(windowSize/2):windowSize+i+floor(windowSize/2)-1, j+floor(windowSize/2):windowSize+j+floor(windowSize/2)-1,2)));

                Sx2Green = sum(sum(weight.*padIx2(i+floor(windowSize/2):windowSize+i+floor(windowSize/2)-1, j+floor(windowSize/2):windowSize+j+floor(windowSize/2)-1,3)));
                Sy2Green = sum(sum(weight.*padIy2(i+floor(windowSize/2):windowSize+i+floor(windowSize/2)-1, j+floor(windowSize/2):windowSize+j+floor(windowSize/2)-1,3)));
                SxSyGreen = sum(sum(weight.*padIxIy(i+floor(windowSize/2):windowSize+i+floor(windowSize/2)-1, j+floor(windowSize/2):windowSize+j+floor(windowSize/2)-1,3)));

                G = [Sx2Red+Sx2Blue+Sx2Green, SxSyRed+SxSyBlue+SxSyGreen; SxSyRed+SxSyBlue+SxSyGreen, Sy2Red+Sy2Blue+Sy2Green];
                %Smoothing of the above tensor maybe done Gsigma1 = G*Gsigma
                [eigenvector, eigenvalue] = eig(G);

                %f2 = 1; %f1 = 0;
                f2 = 1;%/(sqrt(1+eigenvalue(1,1)+eigenvalue(2,2)));
                f1 = 1/((1+eigenvalue(1,1)+eigenvalue(2,2))^1.2);
                if(eigenvalue(1,1)>eigenvalue(2,2))
                    T = f2*eigenvector(:,1)*eigenvector(:,1)' + f1*eigenvector(:,2)*eigenvector(:,2)';
                else
                T = f2*eigenvector(:,2)*eigenvector(:,2)' + f1*eigenvector(:,1)*eigenvector(:,1)';
                end
                Hred = [IxxRed(i,j), IxyRed(i,j); IxyRed(i,j), IyyRed(i,j)];
                Hblue = [IxxBlue(i,j), IxyBlue(i,j); IxyBlue(i,j), IyyBlue(i,j)];
                Hgreen = [IxxGreen(i,j), IxyGreen(i,j); IxyGreen(i,j), IyyGreen(i,j)];

                traceRed(i,j) = trace(T*Hred);
                traceBlue(i,j) = trace(T*Hblue);
                traceGreen(i,j) = trace(T*Hgreen);
            end
        end
    end
    imgOutput = cat(3, traceRed, traceGreen, traceBlue);
end

