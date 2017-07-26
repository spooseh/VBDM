function [xetp1,xdtp1,dtp1] = bestOffersDD(t,xet,kht,xr,deltamin,dr,randTrials)

n = length(dr);
if  ismember(t,randTrials)% ~mod(t,4); % choose a random combination of xd and d
    xetp1 = xet;
    xdtp1 = randi([xet+2, xr(end)],1);
    j = randi(n,1);
    dtp1  = dr(j);
elseif  (xr(end)-deltamin) < xr(end)/(1+dr(end)*exp(kht)) % 47, now <  50,d=356
    % if so patient that even the minimal possible fractional increment won't do, then
    xdtp1 = randi([xr(6),xr(end)],1);
    xetp1 = randi([xdtp1-3,xdtp1-1],1);
    j = randi([n-1,n],1);
    dtp1  = dr(j);
elseif 1+dr(1)*exp(kht) > xr(end)/xr(1) % 3,now > 50,d=3
    % if so impulsive that even maximal fractional increment won't do,
    % then
    xdtp1 = randi([xr(end-2),xr(end)],1);
    xetp1 = randi([xr(1),xr(3)],1);
    j = randi(2,1);
    dtp1  = dr(j);
else % if we're in a reasonable region
    % minimum size of delayed reward for each delay
    xdmin = xr(1)*(1+dr*exp(kht));
    % feasible delays
    i = xdmin<=xr(end);
    i = i & ( 1+dr*exp(kht) >= xr(end)/(xr(end)-deltamin) );
    i = i & ( 1+dr*exp(kht) <= xr(end)/xr(1) );
    xdmin = (xdmin(i));
    dtmp  = dr(i);
    % choose a feasible delay randomly
    j = randi(sum(i),1);
    dtp1 = dtmp(j);
    xdtp1 = randi([floor(xdmin(j)),xr(end)],1);
    xetp1 = round(xdtp1/(1+dtp1*exp(kht)));
end