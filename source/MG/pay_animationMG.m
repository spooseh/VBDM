function [aborted,payout] = pay_animationMG(auxVars,accepted,rejected,posSure)

aborted = 0;
maxPay  = auxVars.maxPay;
maxLoss = auxVars.maxLoss;
hMoney  = auxVars.houseMoney;
txtCol  = auxVars.txtCol;
wd      = auxVars.wd;
linSpc  = auxVars.linSpc;
txtW    = auxVars.txtW;
loMsg   = auxVars.loMsg;
if strcmp(auxVars.instLang,'DE')
    txt{1} = ['Wir werden Ihnen jetzt zeigen was Sie gewonnen haben. '...
               'Sie können dabei wieder mit der rechten '...
               'Pfeiltaste vorblättern.'];
    text = {'Glückwunsch! Insgesamt werden Ihnen also ',...
            ' Euro für diese Aufgabe ausgezahlt.',...
            'Glückwunsch! Sie haben kein Geld verloren',...
            'Leider werden Ihnen also ',...
            ' Euro für diese Aufgabe von ihrem Spielekonto abgebucht.'};
else
    txt{1} = ['Wir werden Ihnen jetzt zeigen was Sie gewonnen haben. '...
               'Sie können dabei wieder mit der rechten und linken '...
               'Pfeiltaste vor- und zurück blättern.'];
    text = {'Glückwunsch! Insgesamt werden Ihnen also ',...
            ' Euro für diese Aufgabe ausgezahlt.',...
            'Glückwunsch! Sie haben kein Geld verloren',...
            'Leider werden Ihnen also ',...
            ' Euro für diese Aufgabe von ihrem Spielekonto abgebucht.'};
end
gainInd = (accepted(:,3) ==  1 & accepted(:,1) <= maxPay);
lossInd = (accepted(:,3) == -1 & accepted(:,1) >= maxLoss);
payInd = find(accepted(:,3) == 0 | gainInd | lossInd);

if isempty(payInd)
    txt = 'No trial fits the payout criterion.';
    DrawFormattedText(wd,txt,'center','center',txtCol,txtW,[],[],linSpc);
    Screen('Flip',wd);
    WaitSecs(2);
    payout = nan;
    return
end
i = randi(length(payInd),1);
t = payInd(i);% Number of trial for payment
if accepted(t,3) == 1
    payout = accepted(t,1) + hMoney;
elseif accepted(t,3) == -1
    payout = accepted(t,2) + hMoney;
else
     payout = hMoney;
end

if payout > 0
    txt{2} = [text{1},num2str(payout),text{2}];
elseif payout == 0
    txt{2} = text{3};
else
    txt{2} = [text{4},num2str(payout),text{5}];
end
DrawFormattedText(wd,txt{1},'center','center',txtCol,txtW,[],[],linSpc);
[~,aborted] = getRarrow(auxVars,0);
if aborted;    return;    end

payTrial(auxVars,posSure(t),accepted(t,:),rejected(t,:),'MG'); 
DrawFormattedText(wd,txt{2},'center','center',txtCol,txtW,[],[],linSpc,[],loMsg);
[~,aborted] = getRarrow(auxVars,0);