function out = NN(val,val_ceil,val_floor,rows,cols)
    temp(1,:) = val_floor;
    temp(2,:) = [val_floor(1),val_ceil(2)];
    temp(3,:) = [val_ceil(1),val_floor(2)];
    temp(4,:) = val_ceil;
    dist(1) = sum((val'-temp(1,:)).^2);
    dist(2) = sum((val'-temp(2,:)).^2);
    dist(3) = sum((val'-temp(3,:)).^2);
    dist(4) = sum((val'-temp(4,:)).^2);
    [A, index] = min(dist);
    out = temp(index,:);
    if (out(1)>rows||out(2)>cols) 
        out = [1,1];
    end
end