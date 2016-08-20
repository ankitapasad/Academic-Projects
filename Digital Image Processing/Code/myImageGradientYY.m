function [ Iyy ] = myImageGradientYY( imgInput )
    [rows, columns] = size(imgInput);
    Iyy = circshift(imgInput,1) - 2*imgInput + circshift(imgInput,-1); %Central difference for all non border pixels
    Iyy(1,:) = imgInput(2,:) - imgInput(1,:); %Forward difference for 1st row
    Iyy(rows,:) = imgInput(rows-1,:) - imgInput(rows,:); %Backward difference for last column
end

