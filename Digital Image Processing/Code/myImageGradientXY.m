function [ Ixy ] = myImageGradientXY( imgInput )
    [rows, columns] = size(imgInput);
    Ixy = zeros(rows+2, columns+2);
    appImgInput = Ixy;
    appImgInput(1,2:columns+1) = imgInput(1,:); %1st row repeated
    appImgInput(1,1) = imgInput(1,1); % Left corner pixel of 1st row repeated to the new top left corner
    appImgInput(1, columns+2) = imgInput(1,columns); % top right corner pixel repeated to the new top right corner
    appImgInput(rows+2,2:columns+1) = imgInput(rows,:); % last row repeated
    appImgInput(rows+2,1) = imgInput(rows,1); % bottom left pixel repeated on the new bottom left corner
    appImgInput(rows+2, columns+2) = imgInput(rows,columns); %bottom right pixel repeated to the new bottom right
    appImgInput(2:rows+1,1) = imgInput(:,1); % 1st column repeated
    appImgInput(2:rows+1,columns+2) = imgInput(:,columns); % last column repeated
    appImgInput(2:rows+1, 2:columns+1) = imgInput; % entire image copied to the middle of the new matrix
    Ixy = circshift(circshift(appImgInput, 1), 1, 2) - circshift(circshift(appImgInput, 1), -1, 2) - circshift(circshift(appImgInput, -1), 1, 2) + circshift(circshift(appImgInput, -1), -1, 2); 
    Ixy = 0.25 * Ixy(2:rows+1,2:columns+1);
end

