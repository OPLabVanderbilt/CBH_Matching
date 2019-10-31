function newim = Scramble(im,n)
 
mn = floor(size(im)/n);
m1 = mn(1);
n1 = mn(2);
newim = zeros(m1*n,n1*n);
ind = randperm(m1*n1);
[ind1,ind2] = ind2sub([m1,n1],ind);
 
for k = 1:m1*n1
    [i,j] = ind2sub([m1,n1],k);
    newim((i-1)*n+1:i*n,(j-1)*n+1:j*n) = ...
        im((ind1(k)-1)*n+1:ind1(k)*n,(ind2(k)-1)*n+1:ind2(k)*n);
end 
