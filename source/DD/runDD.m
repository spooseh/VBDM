function [Payout,aborted] = runDD(genInfo,auxVars)

T.start  = GetSecs;	% timestamp to record length of entire experiment
aborted  = 0;
bgCol    = auxVars.bgCol;
iti      = auxVars.intTrialInt;
linSpc   = auxVars.linSpc;
txtCol   = auxVars.txtCol;
txtW     = auxVars.txtW;
wd       = auxVars.wd;
wdw      = auxVars.wdw;
wdh      = auxVars.wdh;
fileName = genInfo.fileName;
while 1
    nTrials  = genInfo.nTrials;
    
    xr       = 3:50;
    xrPay    = 3:19;  % First offers less than the max to be paid to make sure of payment
    deltamin = 3;
    dr       = [3 7 14 31 61 180 365];	% delays available
    maxPayD  = 7; 		% Maximum delay at which payouts actually can be chosen
    maxPayIm = 15;    % max amount to be paid for the immediate choices
    maxPayDe = 20;    % max amount to be paid for the immediate choices
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%preps;
    khi = (-10:.05:2);	ki = exp(khi);
    pkh = (khi+10).^2.*(2-khi).^2;
    pkh = pkh/sum(pkh);
    bhi = (-5:.05:5)'; bi = exp(bhi);  lbhi=length(bhi);
    pbh = ones(lbhi,1)./lbhi;
    kbh = pbh*pkh;
    kbh = kbh/sum(kbh(:));
    posSure = zeros(2*nTrials,1); % left or right side randomised
    pat = [1;1;-1;-1]; nP = length(pat);
    for i = 1:nP:2*nTrials
        posSure(i:i+nP-1) =  pat(randperm(nP));
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    randTrials  = 3:4:nTrials-3;
    randTrials  = randTrials+(rand(1,length(randTrials))<.5)-(rand(1,length(randTrials))<.5);
    allOffersDD = [];
    posSureResp = [];
    acceptedDD  = nan(nTrials,2);
    rejectedDD  = nan(nTrials,2);
    khDD        = nan(nTrials,1);
    bhDD        = nan(nTrials,1);
    khvDD       = nan(nTrials,1);
    bhvDD       = nan(nTrials,1);
    payout      = nan(1,2);
    Payout.DD   = payout;
    
    if genInfo.doInstruct
        tic;
        if     strcmp(genInfo.language,'DE')
            aborted  = instructDD_DE(auxVars);
        elseif strcmp(genInfo.language,'EN')
            aborted  = instructDD_EN(auxVars);
        end
        if aborted;    break;    end
        T.instruction = toc;
    end
    tic
    t=1; s = 1;
    [xe,xd,d] = makeFirstOffersDD(xrPay);
    while t <= nTrials
        allOffersDD = [allOffersDD;[t,xe,0,xd,d]];
        [aborted,reacT,resp,~] = showTrial(auxVars,posSure(s),xe,xd,d);
        posSureResp =[posSureResp;[posSure(s),resp]];
        if aborted; break; end
        if abs(resp) ~= 1
            WaitSecs(iti+.5);
            if t==1
                [xe,xd,d] = makeFirstOffersDD(xrPay);
            else
                [xe,xd,d] = bestOffersDD(t,xe,khDD(t-1),xr,deltamin,dr,randTrials);
            end
            s = s+1;
            if s > 2*nTrials; break; end
            continue;
        else
            T.rtDD(t) = reacT;
            WaitSecs(iti);
            qd = xd./(1+ki*d);			% value of delayed offer for each khi
            peb = 1./(1+exp(bi*(qd-xe)));	% distribution over both k and beta
            if resp == posSure(s);
                acceptedDD(t,:) = [xe 0];
                rejectedDD(t,:) = [xd d];
                kbh = kbh.*peb;                     % kbh from preps.m
            else
                acceptedDD(t,:) = [xd d];
                rejectedDD(t,:) = [xe 0];
                kbh = kbh.*(1-peb);
            end
            kbh = kbh/sum(sum(kbh));
            khDD(t)  = sum(kbh*khi'); khvDD(t) = sum(kbh*khi'.^2) - khDD(t)^2;
            bhDD(t)  = sum(bhi'*kbh); bhvDD(t) = sum(bhi'.^2*kbh) - bhDD(t)^2;
            
            [xe,xd,d] = bestOffersDD(t,xe,khDD(t),xr,deltamin,dr,randTrials);
            s = s+1;
            t = t+1;
        end
        if s > 2*nTrials; break; end
    end
    genInfo.kDD = khDD(end);
    if aborted; break; end
    T.estimateK = toc;
    Screen('FillRect', wd, bgCol);
    if genInfo.doPay
        i=find(acceptedDD(:,2) == 0 & acceptedDD(:,1) < maxPayIm);
        if isempty(i) %in case the participant only chooses the delayed option
            i = find(acceptedDD(:,2) <= maxPayD & acceptedDD(:,1) < maxPayDe);
        end
        if isempty(i)
            payout = [0,0];
            text   = {'No trial fits the payout criterion.'};
            displaytext(text,wd,wdw,wdh,txtCol,5,0);
        else
            payTrials = i(randi(length(i),1));
            payout    = acceptedDD(payTrials,:);
            %.............. payment ....................................................
            if     strcmp(genInfo.language,'DE')
                text = ['Ihnen werden ' num2str(payout(1)) ' Euro in ' num2str(payout(2)) ' Tagen ausgezahlt.'];
            elseif strcmp(genInfo.language,'EN')
                text = ['Ihnen werden ' num2str(payout(1)) ' Euro in ' num2str(payout(2)) ' Tagen ausgezahlt.'];
            end
            DrawFormattedText(wd,text,'center','center',txtCol,txtW,[],[],linSpc);
            [~,aborted] = getRarrow(auxVars,0);
        end
    end
    Payout.DD = payout;
    T.experiment = GetSecs-T.start;	
    break;
end
if genInfo.doSave
    toSave = {'T','aborted','allOffersDD','auxVars','bhDD',...
        'bhi','bhvDD','acceptedDD','dr','genInfo','khDD','khi',...
        'khvDD','payout','posSureResp','rejectedDD','randTrials','xr'};
    if aborted
        fileName = [fileName '_aborted'];
    end
    save(['data/' fileName '.mat'],toSave{:});
end
