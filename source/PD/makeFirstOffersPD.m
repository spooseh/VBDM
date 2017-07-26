function [sure,uncert,prob] = makeFirstOffersPD(xr,curTask)

k = 0.95 + 0.1*rand;
probs = [2/3, 1/2, 1/3, 1/4];
j = randi(length(probs),1);
prob = probs(j);
possible_sure = (1+((1- prob)/prob)*k)*xr;
i = possible_sure <= xr(end); % all feasible uncertain for k and p
possible_sure = xr(i);
j = randi(length(possible_sure),1);
if strcmp(curTask,'PDG')
    sure = possible_sure(j);
elseif strcmp(curTask,'PDL')
    sure = - possible_sure(j);
end
uncert = round((1+((1- prob)/prob)*k)*sure);