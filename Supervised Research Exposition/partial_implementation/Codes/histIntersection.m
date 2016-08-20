function out = histIntersection(A,B)
% A, B: patches
    [countsA,~] = imhist(A);
%     size(countsA)
    [countsB,~] = imhist(B);
%     size(countsB)
    out = 0.5*sum(countsA(2:end)+countsB(2:end)-abs(countsA(2:end)-countsB(2:end))); % min(conntsA(i),countsB(i))
end