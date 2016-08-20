function C = transform(A,H)
   % Applies the homography transformation H on image A to give the
   % transformed image output 'B'
   % A = imread('goi1_downsampled.jpg');
   [rows, cols] = size(A);
   a = 1:1:cols;
   a = repmat(a,1,rows);
   c = ones(1,rows*cols);
   b = 1:1:rows;
   b = repmat(b,cols,1);
   b = reshape(b,1,rows*cols);
   V = [b;a;c];
   temp = H\V; % updated co-ordinates
   temp(1,:) = temp(1,:)./temp(3,:);
   temp(2,:) = temp(2,:)./temp(3,:);
   j = 1;
   for i = 1:(rows*cols)
       val = temp(1:2,i);
       if (floor(val(1))<=0 || floor(val(2))<=0)
           val_int(:,i) = [1,1];
           temp_row = ceil(i/cols);
           temp_col = rem(i,cols);
           if (temp_col == 0)
               temp_col = cols;
           end
           mark_index(j) = temp_row + ((temp_col - 1)*rows);
           j = j+1;
       else
           val_ceil = ceil(val);
           val_floor = floor(val);
           val_int(:,i) = NN(val,val_ceil,val_floor,rows,cols);
       end
   end
   index_no = val_int(1,:) + ((val_int(2,:)-ones(1,rows*cols))*rows);
   temp_pixel = A(1,1);
   A(1,1) = 0;
   B = A(index_no);
%    for i = 1:j-1
%        B(mark_index(i)) = 0;
%    end
   C = reshape(B,cols,rows);
   C = C';
%    imshow([A,C]);
end