function [gain,loss] = makeFirstOffersMG(lossr,gainr)
% lossr = 5:15; gainr = [1,20];
lam = 1.9 + 0.2*rand;
possible_gain_offers = round(lossr*lam);
% feasible losses
i = possible_gain_offers <= gainr(2);
i = i & ( possible_gain_offers >= gainr(1));
possible_gain_offers = possible_gain_offers(i);
possible_loss_offers = lossr(i);
% choose a feasible gain randomly
j = randi(sum(i),1);
gain =  possible_gain_offers(j);
loss = -possible_loss_offers(j);
