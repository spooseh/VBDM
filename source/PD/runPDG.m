function [Payout,aborted] = runPDG(genInfo,auxVars)

T.start = GetSecs;	% timestamp to record length of entire experiment
aborted = 0;
while 1
    nTrials  = genInfo.nTrials;
    fileName = [genInfo.fileName '_' datestr(now,'HHMM');];
    genInfo.fileName = fileName;
    
    xr    = 3:50;
    xrPay = 3:19; % First offers less than the max to be paid to make sure of payment
    deltamin = 3;				% minimum difference between two offers
    probs = [2/3, 1/2, 1/3, 1/4, 1/5]; %Probabilities to be tested
    oddsr = (1- probs)./probs;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%preps;
    khi = (-3:.02:3);    ki = exp(khi);
    pkh = (khi+3).^2.*(3-khi).^2;
    pkh = pkh/sum(pkh);
    bhi = (-5:.05:5)';    bi = exp(bhi);    lbhi=length(bhi);
    pbh = ones(lbhi,1)./lbhi;
    kbh = pbh*pkh;
    kbh = kbh/sum(kbh(:));
    posSure = zeros(2*nTrials,1); % xo on left or right side randomised
    pat = [1;1;-1;-1]; nP = length(pat);
    for i = 1:nP:2*nTrials
        posSure(i:i+nP-1) =  pat(randperm(nP));
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    randTrials = 3:4:nTrials-3;
    randTrials = randTrials+(rand(1,length(randTrials))<.5)-(rand(1,length(randTrials))<.5);
    allOffersPDG = [];
    posSureResp  = [];
    acceptedPDG  = nan(nTrials,3);
    rejectedPDG  = nan(nTrials,2);
    khPDG        = nan(nTrials,1);
    bhPDG        = nan(nTrials,1);
    khvPDG       = nan(nTrials,1);
    bhvPDG       = nan(nTrials,1);
    payout       = nan;
    Payout.PDG   = payout;
        
    bgCol   = auxVars.bgCol;
    iti     = auxVars.intTrialInt;
    wd      = auxVars.wd;
    
    if genInfo.doInstruct
        tic;
        if     strcmp(genInfo.language,'DE')
            aborted  = instructPDG_DE(auxVars,genInfo.giveFeedback);
        elseif strcmp(genInfo.language,'EN')
            aborted  = instructPDG_EN(auxVars,genInfo.giveFeedback);
        end
        if aborted;    break;    end
        T.instruction = toc;
    end
    tic
    t = 1; s = 1;
    [xs,xu,p] = makeFirstOffersPD(xrPay,auxVars.curTask);
    while t <= nTrials
        allOffersPDG = [allOffersPDG;[t,xs,1,xu,p]];
        [aborted,reacT,resp,win] = showTrial(auxVars,posSure(s),xs,xu,p);
        posSureResp =[posSureResp;[posSure(s),resp]];
        if aborted; break; end
        if abs(resp) ~= 1
            WaitSecs(iti+.5);
            if t==1
                [xs,xu,p] = makeFirstOffersPD(xrPay,auxVars.curTask);
            else
                [xs,xu,p] = bestOffersPD(t,xs,khPDG(t-1),xr,deltamin,oddsr,randTrials,auxVars.curTask);
            end
            s = s+1;
            if s > 2*nTrials; break; end
            continue;
        else
            T.rtPDG(t)  = reacT;
            WaitSecs(iti);
            qU  = xu./(1+ki*((1- p)/p));			% value of uncertain offer for each khi
            peb = 1./(1+exp(bi*(qU-xs)));	% distribution over both k and beta
            if resp == posSure(s);
                acceptedPDG(t,:)  = [xs 1 1];
                rejectedPDG(t,:)  = [xu p];
                kbh = kbh.*peb;
            else
                acceptedPDG(t,:) = [xu p win];
                rejectedPDG(t,:) = [xs 1];
                kbh = kbh.*(1-peb);
            end
            kbh = kbh/sum(sum(kbh));
            khPDG(t)  = sum(kbh*khi');    khvPDG(t) = sum(kbh*khi'.^2) - khPDG(t)^2;
            bhPDG(t)  = sum(bhi'*kbh);    bhvPDG(t) = sum(bhi'.^2*kbh) - bhPDG(t)^2;
            [xs,xu,p] = bestOffersPD(t,xs,khPDG(t),xr,deltamin,oddsr,randTrials,auxVars.curTask);
            s = s+1;
            t = t+1;
        end
        if s > 2*nTrials; break; end
    end
    genInfo.kPDG = khPDG(end);
    if aborted; break; end
    T.estimateK = toc;
    Screen('FillRect', wd, bgCol);
    if genInfo.doPay
        [aborted,payout] = pay_animationPD(auxVars,acceptedPDG,rejectedPDG,posSure);
        if aborted;    break;    end
    end
    Payout.PDG = payout;
    T.experiment = GetSecs-T.start;
    break;
end
if genInfo.doSave
    toSave = {'T','aborted','allOffersPDG','auxVars','bhPDG','bhi','bhvPDG',...
        'acceptedPDG','khPDG','khi','khvPDG','rejectedPDG',...
        'probs','posSureResp','randTrials','xr','genInfo'};
    
    if aborted
        fileName = [fileName '_aborted'];
    end
    save(['data/' fileName '.mat'],toSave{:});
end