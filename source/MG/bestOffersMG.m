function [gShowntp1,lShowntp1] = bestOffersMG(t,randTrials,gShownt,all_losses,lambdaht,gainr,lossr)
if ismember(t,randTrials)% choose a random combination of xuncert and prob
    gShowntp1 = gShownt;
    lShowntp1 = -all_losses(randi(length(all_losses),1));
elseif lossr(2)*(lambdaht) < gainr(1)
    % if so loss seeking that all offers exceed min bounds then
    min_gain_offers = gainr(1):gainr(1)+4;
    max_loss_offers = all_losses(end-4:end);
    gShowntp1 = min_gain_offers(randi(length(min_gain_offers),1));
    lShowntp1 = -max_loss_offers(randi(length(max_loss_offers),1));
elseif lossr(1)*(lambdaht) > gainr(2)
    % if so loss aversive that all offers exceed max bounds then
    max_gain_offers = gainr(2)-4:gainr(2);
    min_loss_offers = all_losses(1:4);
    gShowntp1 = max_gain_offers(randi(length(max_gain_offers),1));
    lShowntp1 = -min_loss_offers(randi(length(min_loss_offers),1));
else % if we're in a reasonable region
    % maximum size of delayed reward for each delay
    possible_gain_offers = round(all_losses*(lambdaht));
    % feasible delays
    i = possible_gain_offers <= gainr(2);
    i = i & ( possible_gain_offers >= gainr(1));
    possible_gain_offers = possible_gain_offers(i);
    possible_loss_offers = all_losses(i);
    % choose a feasible gain randomly
    j = randi(sum(i),1);
    gShowntp1 = possible_gain_offers(j);
    lShowntp1 = -possible_loss_offers(j);
end