function [xstp1,xutp1,probtp1] = bestOffersPD(t,xst,kht,xr,deltamin,oddsr,randTrials,curTask)
if  ismember(t,randTrials)% ~mod(t,4); % choose a random combination of xd and d
    if strcmp(curTask,'PDG')
        xstp1 = xst;
    elseif strcmp(curTask,'PDL')
        xstp1 = -xst;
    end
    tmp = xstp1:xr(end);    j = randi(length(tmp),1);
    xutp1 = tmp(j);
    j = randi(length(oddsr),1);
    oddtp1  = oddsr(j);
    probtp1 = 1/(1+oddtp1);
elseif 1+oddsr(end)*exp(kht) < xr(end)/(xr(end)-deltamin)
    % if so patient that even the minimal possible fractional increment
    % won't do, then
    xutp1   = randi([xr(6),xr(end)],1);
    xstp1   = randi([xutp1-3,xutp1-1],1);
    oddtp1  = oddsr(end);
    probtp1 = 1/(1+oddtp1);
elseif 1+oddsr(1)*exp(kht) > xr(end)/xr(1)
    % if so impulsive that even maximal fractional increment won't do,
    % then
    tmp     = xr(end-2):xr(end);    j = randi(length(tmp),1);
    xutp1   = tmp(j);
    tmp     = xr(1):xr(3);    j=randi(length(tmp),1);
    xstp1   = tmp(j);
    oddtp1  = oddsr(1);
    probtp1 = 1/(1+oddtp1);
else % if we're in a reasonable region
    xuncertmax = xr(1)*(1+oddsr*exp(kht));
    % feasible delays
    i = xuncertmax<=xr(end);
    i = i & ( 1+oddsr*exp(kht) >= xr(end)/(xr(end)-deltamin) );
    i = i & ( 1+oddsr*exp(kht) <= xr(end)/xr(1) );
    xuncertmax = xuncertmax(i);
    oddtmp  = oddsr(i);
    % choose a feasible delay randomly
    j = randi(sum(i),1);
    oddtp1  = oddtmp(j);
    probtp1 = 1/(1+oddtp1);
    tmp = floor(xuncertmax(j)):xr(end);    j = randi(length(tmp),1);
    xutp1 = tmp(j);
    xstp1 = round(xutp1/(1+oddtp1*exp(kht)));
end
if strcmp(curTask,'PDL')
    xstp1 = -xstp1;
    xutp1 = -xutp1;
end