function [Payout,aborted] = runPDL(genInfo,auxVars)

T.start  = GetSecs;	% timestamp to record length of entire experiment
aborted  = 0;
fileName = genInfo.fileName;
while 1
    nTrials  = genInfo.nTrials;
    xr    = 3:50;
    xrPay = 3:15; % First offers less than the max to be paid to make sure of payment
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
    allOffersPDL = [];
    posSureResp  = [];
    acceptedPDL  = nan(nTrials,3);
    rejectedPDL  = nan(nTrials,2);
    khPDL        = nan(nTrials,1);
    bhPDL        = nan(nTrials,1);
    khvPDL       = nan(nTrials,1);
    bhvPDL       = nan(nTrials,1);
    payout       = nan;
    Payout.PDL    = payout;
        
    bgCol   = auxVars.bgCol;
    iti     = auxVars.intTrialInt;
    wd      = auxVars.wd;
    
    if genInfo.doInstruct
        tic;
        if     strcmp(genInfo.language,'DE')
            aborted  = instructPDL_DE(auxVars,genInfo.giveFeedback);
        elseif strcmp(genInfo.language,'EN')
            aborted  = instructPDL_EN(auxVars,genInfo.giveFeedback);
        end
        if aborted;    break;    end
        T.instruction = toc;
    end
    tic
    t = 1; s = 1;
    [xs,xu,p] = makeFirstOffersPD(xrPay,auxVars.curTask);
    while t <= nTrials
        allOffersPDL = [allOffersPDL;[t,xs,1,xu,p]];
        [aborted,reacT,resp,win] = showTrial(auxVars,posSure(s),xs,xu,p);
        posSureResp =[posSureResp;[posSure(s),resp]];
        if aborted; break; end
        if abs(resp) ~= 1
            WaitSecs(iti+.5);
            if t==1
                [xs,xu,p] = makeFirstOffersPD(xrPay,auxVars.curTask);
            else
                [xs,xu,p] = bestOffersPD(t,xs,khPDL(t-1),xr,deltamin,oddsr,randTrials,auxVars.curTask);
            end
            s = s+1;
            if s > 2*nTrials; break; end
            continue;
        else
            T.rtPDL(t)  = reacT;
            WaitSecs(iti);
            qU  = xu./(1+ki*((1- p)/p));			% value of uncertain offer for each khi
            peb = 1./(1+exp(bi*(qU-xs)));	% distribution over both k and beta
            if resp == posSure(s);
                acceptedPDL(t,:)  = [xs 1 1];
                rejectedPDL(t,:)  = [xu p];
                kbh = kbh.*peb;
            else
                acceptedPDL(t,:) = [xu p win];
                rejectedPDL(t,:) = [xs 1];
                kbh = kbh.*(1-peb);
            end
            kbh = kbh/sum(sum(kbh));
            khPDL(t)  = sum(kbh*khi');    khvPDL(t) = sum(kbh*khi'.^2) - khPDL(t)^2;
            bhPDL(t)  = sum(bhi'*kbh);    bhvPDL(t) = sum(bhi'.^2*kbh) - bhPDL(t)^2;
            [xs,xu,p] = bestOffersPD(t,xs,khPDL(t),xr,deltamin,oddsr,randTrials,auxVars.curTask);
            s = s+1;
            t = t+1;
        end
        if s > 2*nTrials; break; end
    end
    genInfo.kPDL = khPDL(end);
    if aborted; break; end
    T.estimateK = toc;
    Screen('FillRect', wd, bgCol);
    if genInfo.doPay
        [aborted,payout] = pay_animationPD(auxVars,acceptedPDL,rejectedPDL,posSure);
        if aborted;    break;    end
    end
    Payout.PDL = payout;
    T.experiment = GetSecs-T.start;
    break;
end
if genInfo.doSave
    toSave = {'T','aborted','allOffersPDL','auxVars','bhPDL','bhi','bhvPDL',...
        'acceptedPDL','khPDL','khi','khvPDL','rejectedPDL','payout',...
        'probs','posSureResp','randTrials','xr','genInfo'};
    
    if aborted
        fileName = [fileName '_aborted'];
    end
    save(['./data/' fileName '.mat'],toSave{:});
end
