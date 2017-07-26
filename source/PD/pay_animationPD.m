function [aborted,payout] = pay_animationPD(auxVars,accepted,rejected,posSure)

aborted = 0;
maxPay  = auxVars.maxPay;
maxLoss = auxVars.maxLoss;
task    = auxVars.curTask;
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
            'Sorry! Leider haben Sie kein Geld gewonnen.',...
            'Glückwunsch! Sie haben kein Geld verloren',...
            'Leider werden Ihnen also ',...
            ' Euro für diese Aufgabe von ihrem Spielekonto abgebucht.'};
else
    txt{1} = ['Wir werden Ihnen jetzt zeigen was Sie gewonnen haben. '...
               'Sie können dabei wieder mit der rechten und linken '...
               'Pfeiltaste vor- und zurück blättern.'];
    text = {'Glückwunsch! Insgesamt werden Ihnen also ',...
            ' Euro für diese Aufgabe ausgezahlt.',...
            'Sorry! Leider haben Sie kein Geld gewonnen.',...
            'Glückwunsch! Sie haben kein Geld verloren',...
            'Leider werden Ihnen also ',...
            ' Euro für diese Aufgabe von ihrem Spielekonto abgebucht.'};
end

if strcmp(task,'PDG')
    payInd = find(~accepted(:,3) | (accepted(:,3) & accepted(:,1) <= maxPay));
    zeroPay = text{3};
elseif strcmp(task,'PDL')
    payInd = find(~accepted(:,3) | (accepted(:,3) & accepted(:,1) >= maxLoss));
    zeroPay = text{4};
end
if isempty(payInd)
    txt = 'No trial fits the payout criterion.t';
    DrawFormattedText(wd,txt,'center','center',txtCol,55,[],[],1.8);
    Screen('Flip',wd);
    WaitSecs(4);
    payout = nan;
    return
end
i = randi(length(payInd),1);
t = payInd(i);% Number of trial for payment
payout = accepted(t,1)*accepted(t,3);
if payout > 0
    txt{2} = [text{1},num2str(payout),text{2}];
elseif payout == 0
    txt{2} = zeroPay;
else
    txt{2} = [text{5},num2str(payout),text{6}];
end
DrawFormattedText(wd,txt{1},'center','center',txtCol,txtW,[],[],linSpc);
[~,aborted] = getRarrow(auxVars,0);
if aborted;    return;    end

payTrial(auxVars,posSure(t),accepted(t,:),rejected(t,:),'PD'); 
DrawFormattedText(wd,txt{2},'center','center',txtCol,txtW,[],[],linSpc,[],loMsg);
[~,aborted] = getRarrow(auxVars,0);
if aborted;    return;    end

