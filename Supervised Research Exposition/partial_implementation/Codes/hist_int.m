function out = hist_int(A,B)
 [countsa,xa] = imhist(A);
 [countsb,xb] = imhist(B);
 out = zeros(length(countsa),1);
 for i = 1:length(countsa)
     out(i) = min(countsa(i),countsb(i));
 end
end