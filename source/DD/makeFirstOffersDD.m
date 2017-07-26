function [im,de,d] = makeFirstOffersDD(xr)

dr = [3 7]; 
k = 0.01 + 0.02*rand;

lx = length(xr);
ld = length(dr);
xI = repmat(xr,lx*ld,1);     xI = xI(:);

xD = repmat(xr,ld,1);        xD = xD(:);
xD = repmat(xD,lx,1);

D = repmat(dr',lx*lx,1);

x = [xI,xD,D];
x(x(:,1) >= x(:,2),:) = [];

qD = round(x(:,2)./(1+k*x(:,3)));
x  = [x,qD];
x(x(:,1) ~= x(:,4),:) = [];

i  = randi(size(x,1),1);
im = x(i,1);
de = x(i,2);
d  = x(i,3);