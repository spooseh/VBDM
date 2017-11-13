function [Payout,aborted] = runMG(genInfo,auxVars)

T.start  = GetSecs;	% timestamp to record length of entire experiment
aborted  = 0;
maxPay   = auxVars.maxPay;
maxLoss  = auxVars.maxLoss;
genInfo.fileName = [genInfo.fileName '_' datestr(now,'HHMM')];
while 1
    nTrials  = genInfo.nTrials;
       
    gainr      = [1 40]; 			% range of gains offered
    gainrPay   = [1 maxPay];  % First offers less than the max to be paid to make sure of payment
    lossPay    = 5:abs(maxLoss);
    all_losses = 5:20;
    lossr      = [all_losses(1) all_losses(end)];
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%preps%%%%%%%
    lambdahi = (0:.02:4); 
    plambdah = (lambdahi).^2.*(4-lambdahi).^2;
    plambdah = plambdah/sum(plambdah);
    bhi = (-5:.05:5)'; bi = exp(bhi);  lbhi = length(bhi);
    pbh = ones(lbhi,1)./lbhi;
    lambdabh = pbh*plambdah;     lambdabh = lambdabh/sum(lambdabh(:));
    posSure = zeros(2*nTrials,1); % xo on left or right side randomised
    pat = [1;1;-1;-1]; nP = length(pat);
    for i = 1:nP:2*nTrials
        posSure(i:i+nP-1) =  pat(randperm(nP));
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    randTrials = 3:4:nTrials-3;
    randTrials = randTrials+(rand(1,length(randTrials))<.5)-(rand(1,length(randTrials))<.5);
    allOffersMG = [];
    posSureResp = [];
    acceptedMG = nan(nTrials,3);
    rejectedMG = nan(nTrials,2);
    lambdah    = nan(nTrials,1);
    lambdahv   = nan(nTrials,1);
    bhMG       = nan(nTrials,1);
    bhvMG      = nan(nTrials,1);
    payout     = nan;
    Payout.MG  = payout;
    
    win     = zeros(nTrials,1);
    numWins = 0;
    numLoss = 0;
    
    bgCol   = auxVars.bgCol;
    iti     = auxVars.intTrialInt;
    wd      = auxVars.wd;
    
    if genInfo.doInstruct
        tic;
        if     strcmp(genInfo.language,'DE')
            aborted  = instructMG_DE(auxVars,genInfo.giveFeedback);
        elseif strcmp(genInfo.language,'EN')
            aborted  = instructMG_EN(auxVars,genInfo.giveFeedback);
        end
        if aborted;    break;    end
        T.instruction = toc;
    end
    tic
    t = 1;  s = 1;
    [gain,loss] = makeFirstOffersMG(lossPay,gainrPay);
    while t <= nTrials
        allOffersMG = [allOffersMG;[t,gain,loss]];
        win(t) = sosoWins(numWins,numLoss);
        numWins = numWins+(win(t)== 1);
        numLoss = numLoss+(win(t)==-1);
        [aborted,reacT,resp,~] = showTrial(auxVars,posSure(s),0,[gain,loss],win(t));
        posSureResp =[posSureResp;[posSure(s),resp]];
        if aborted; break; end
        if abs(resp) ~= 1
            WaitSecs(iti+.5);
            if t==1
                [gain,loss] = makeFirstOffersMG(all_losses,gainrPay);
            else
                [gain,loss] = bestOffersMG(t,randTrials,gain,all_losses,lambdah(t-1),gainr,lossr);
            end
            s = s+1;
            if s > 2*nTrials; break; end
            continue;
        else
            T.rtMG(t)  = reacT;
            WaitSecs(iti);
            %Parameter estimation
            val_func = 0.5*(gain + lambdahi*loss); %Value of current gamble for each lambda, loss < 0
            peb = 1./(1+exp(-bi*val_func));	% distribution over both lambda and beta
            if resp == posSure(s);
                acceptedMG(t,:) = [0 0 0];
                rejectedMG(t,:) = [gain loss];
                lambdabh = lambdabh.*(1-peb);
            else
                acceptedMG(t,:) = [gain loss win(t)];
                rejectedMG(t,:) = [0 0];
                lambdabh = lambdabh.*peb;
            end
            lambdabh    = lambdabh/sum(sum(lambdabh));
            lambdah(t) = sum(lambdabh*lambdahi');    lambdahv(t) = sum(lambdabh*lambdahi'.^2) - lambdah(t)^2;
            bhMG(t)    = sum(bhi'*lambdabh);         bhvMG(t)    = sum(bhi'.^2*lambdabh) - bhMG(t)^2;
            %Next mixed gamble to offer
            [gain,loss] = bestOffersMG(t,randTrials,gain,all_losses,lambdah(t),gainr,lossr);
            s = s+1;
            t = t+1;
        end
        if s > 2*nTrials; break; end
    end
    genInfo.lMG = lambdah(end);
    if aborted; break; end
    T.estimateL = toc;
    Screen('FillRect', wd, bgCol);
    if genInfo.doPay
        [aborted,payout] = pay_animationMG(auxVars,acceptedMG,rejectedMG,posSure);
        if aborted;    break;    end
    end
    Payout.MG = payout; % payout plus the house money
    T.experiment = GetSecs-T.start;	% record length of experiment
    break;
end
if genInfo.doSave
    toSave = {'T','aborted','acceptedMG','allOffersMG','bhMG','bhi',...
        'bhvMG','gainr','genInfo','lambdah','lambdahi','lambdahv',...
        'lossr','payout','posSureResp','randTrials','rejectedMG','win'};
    
    if aborted
        genInfo.fileName = [genInfo.fileName '_aborted'];
    end
    save(['./data/' genInfo.fileName '.mat'],toSave{:});
end
