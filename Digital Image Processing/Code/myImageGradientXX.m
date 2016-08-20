function [ Ixx ] = myImageGradientXX( imgInput )
    [rows, columns] = size(imgInput);
    Ixx = circshift(imgInput,1,2) - 2*imgInput + circshift(imgInput,-1,2); %Central difference for all non border pixels
    Ixx(:,1) = imgInput(:,2) - imgInput(:,1); %Forward difference for 1st column
    Ixx(:,columns) = imgInput(:,columns-1) - imgInput(:,columns); %Backward difference for last column
end

