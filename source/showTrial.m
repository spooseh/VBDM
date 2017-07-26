function [aborted,rt,resp,win] = showTrial(auxVars,posSure,xSure,xRisk,risk) 
% This function sets up the scrren to present the offers and returns
% the information related to the participant's reaction, given the
% following information.
% auxVars: auxilary variables including the screen setup, colors, etc.
% posSure: the position of the immediate/sure offer -1, +1 for left and
% right.
% xSure: the ammount of the immediate/sure offer. 
% xRisk: the ammount of the  delayed/risky offer. 
% risk:  the delay/probabality/win associated with the delay/risk of the offer

aborted = 0;
black   = auxVars.black;
blue    = auxVars.blue;
bgCol   = auxVars.bgCol;
curr    = auxVars.currency;
curTask = auxVars.curTask;
fbTime  = auxVars.fbTime;
graySq  = auxVars.graySq;
green   = auxVars.green;
lightSq = auxVars.lightSq;
linW    = auxVars.linW;
stimT   = auxVars.stimDuration;
txtCol  = auxVars.txtCol;
w       = auxVars.wBox;
wd      = auxVars.wd;
wdh     = auxVars.wdh;
wdw     = auxVars.wdw;
linSpc  = auxVars.linSpc;
txtW    = auxVars.txtW;
if     strcmp(auxVars.instLang,'DE')
    noRespMsg = 'Bitte schneller Antworten!';
    badKeyMsg = 'falsche Taste!';
elseif strcmp(auxVars.instLang,'EN')
    noRespMsg = 'Please respond faster!';
    badKeyMsg = 'Wrong key!';
end

if strcmp(auxVars.instLang,'DE')
    txtD = {'drei Tagen', 'einer Woche', 'zwei Wochen',...
            'einem Monat','zwei Monaten','sechs Monaten',...
            'einem Jahr'};
    now = 'jetzt';
else
    txtD = {'three days', 'one week', 'two weeks',...
            'one month','two months','six months',...
            'one year'};
    now = 'now';
end

c = [wdw/2; wdh/2];
cL = c - [20*w;0];
cR = c + [20*w;0];
centerSure = c + posSure*[20*w;0];
centerGam  = c - posSure*[20*w;0];

Box  = [-1 +1 +1 +1 +1 -1 -1 -1; % 2 units square box relative to it's center
        -1 -1 -1 +1 +1 +1 +1 -1];
bBox = 12*w*Box; % Big box relative to it's center
sBox =  3*w*Box; % Small box relative to it's center

lBox = repmat(cL,1,8) + bBox;
rBox = repmat(cR,1,8) + bBox;
pickL = repmat(cL,1,8) + 1.05*bBox;
pickR = repmat(cR,1,8) + 1.05*bBox;

Screen('FillRect', wd, bgCol);
Screen('DrawLines',wd,lBox,linW,black);
Screen('DrawLines',wd,rBox,linW,black);
fbGam = []; fbSure = []; win = [];
switch curTask
    case 'DD'
        txtDi = find([3 7 14 31 61 180 365] == risk);    
        auxVars.giveFeedback = 0;
        if posSure == -1
            txtL = double(sprintf('%d %s\n\n%s',xSure,curr,now));
            txtR = double(sprintf('%d %s\n\n%s',xRisk,curr,txtD{txtDi}));
        else
            txtL = double(sprintf('%d %s\n\n%s',xRisk,curr,txtD{txtDi}));
            txtR = double(sprintf('%d %s\n\n%s',xSure,curr,now));
        end
        rectL = [lBox(:,1)',lBox(:,4)'];
        rectR = [rBox(:,1)',rBox(:,4)'];
        DrawFormattedText(wd,txtL,'center','center',txtCol,txtW,[],[],1.2,[],rectL);
        DrawFormattedText(wd,txtR,'center','center',txtCol,txtW,[],[],1.2,[],rectR);
    case {'PDG','PDL'}
        cSure = {centerSure,centerSure-w*[-4;-4],centerSure-w*[+4;-4],centerSure-w*[+4;+4],centerSure-w*[-4;+4]}; % Centers for sure offer
        locSure = randi(5);
        sS = repmat(cSure{locSure},1,8) + sBox;
        sSRect = [sS(:,1)',sS(:,4)'];
%         sSRect = [cSure{locSure}(1)-3*w,cSure{locSure}(2)-3*w,cSure{locSure}(1)+3*w,cSure{locSure}(2)+3*w];
        Screen('DrawTexture',wd,lightSq,[],sSRect);
        DrawFormattedText(wd,num2str(xSure),'center','center',txtCol,txtW,[],[],linSpc,[],sSRect);
        Screen('DrawLines',wd,sS,linW,black);
        fbSure = repmat(cSure{locSure},1,8) + 1.05*sBox;
        
        cG = {centerGam,centerGam-w*[-7;-7],centerGam-w*[+7;-7],centerGam-w*[+7;+7],centerGam-w*[-7;+7]}; % Centers for gambling offer
        win = (rand <= risk); % Decide if there will be a winning
        probs = [2/3, 1/2, 1/3, 1/4, 1/5];
        allBoxs = {randperm(5,3),randperm(5,2),randperm(5,3),randperm(5,4),randperm(5,5)};
        nEmpty = [1,1,2,3,4];
        locInd = find(abs(probs - risk)< 1e-6);
        locGam = allBoxs{locInd};
        for k = 1:nEmpty(locInd)
            i = locGam(k);
            sG = repmat(cG{i},1,8) + sBox; % Small box for gambling offer
            sGCross = sG(:,[1,4,2,6]);
            sGRect = [sG(:,1)',sG(:,4)'];
            Screen('DrawTexture',wd,graySq,[],sGRect);
            Screen('DrawLines',wd,sG,linW,black);
            Screen('DrawLines',wd,sGCross,linW,black);
        end
        fbZero = i; % The last empty box for the feedback
        for k = nEmpty(locInd)+1:length(locGam)
            i = locGam(k);
            sG = repmat(cG{i},1,8) + sBox; % Small box for gambling offer
            sGRect = [sG(:,1)',sG(:,4)'];
            Screen('DrawTexture',wd,lightSq,[],sGRect);
            DrawFormattedText(wd,num2str(xRisk),'center','center',txtCol,txtW,[],[],linSpc,[],sGRect);
            Screen('DrawLines',wd,sG,linW,black);
        end
        fbNZero = i; % The last full box for the feedback
        if win
            fbGam = fbNZero;
        else
            fbGam = fbZero;
        end
    case 'MG'
        cSure = {centerSure-w*[-4;-4],centerSure-w*[+4;-4],centerSure-w*[+4;+4],centerSure-w*[-4;+4]}; % Centers for sure offer
        locSure = randi(4);
        sS = repmat(cSure{locSure},1,8) + sBox;
        sSRect = [sS(:,1)',sS(:,4)'];
        sGCross = sS(:,[1,4,2,6]);
        Screen('DrawTexture',wd,graySq,[],sSRect);
        Screen('DrawLines',wd,sS,linW,black);
        Screen('DrawLines',wd,sGCross,linW,black);
        fbSure = repmat(cSure{locSure},1,8) + 1.05*sBox;
        
        cG = {centerGam-w*[-4;-4],centerGam-w*[+4;-4],centerGam-w*[+4;+4],centerGam-w*[-4;+4]}; % Centers for gambling offer
        locGam = randperm(4,2);
        for k = 1:2
            i = locGam(k);
            sG = repmat(cG{i},1,8) + sBox; % Small box for gambling offer
            sGRect = [sG(:,1)',sG(:,4)'];
            Screen('DrawTexture',wd,lightSq,[],sGRect);
            DrawFormattedText(wd,num2str(xRisk(k)),'center','center',txtCol,txtW,[],[],linSpc,[],sGRect);
            Screen('DrawLines',wd,sG,linW,black);
        end
        if risk == 1
            fbGam = locGam(1); % The first element of xGam is the gain
        else
            fbGam = locGam(2);
        end
end

badKey = 0;
resp = 0;
rt = inf; %
start_time = Screen('Flip',wd,[],1);
while (GetSecs < start_time + stimT) && (resp == 0)
    [keyIsDown,secs,keyCode] = KbCheck;
    key = KbName(keyCode);
    if keyIsDown
        rt = secs-start_time;
        if   strcmpi(key,'LeftArrow')
            resp = -1;
            Screen('FillRect', wd, bgCol,[wdw/2 0 wdw wdh]);
            Screen('DrawLines',wd,pickL,linW,green);
        elseif strcmpi(key,'RightArrow')
            resp = +1;
            Screen('FillRect', wd, bgCol,[0 0 wdw/2 wdh]);
            Screen('DrawLines',wd,pickR,linW,green);
        elseif strcmpi(key,'ESCAPE');
            aborted = 1;
            return;
        else badKey = 1; break
        end
        Screen('Flip',wd,[],1);    WaitSecs(fbTime);
    end
end
if (resp == 0) || badKey
    Screen('FillRect', wd, bgCol);
    if ~badKey
        DrawFormattedText(wd,noRespMsg,'center','center',txtCol);
    else
        DrawFormattedText(wd,badKeyMsg,'center','center',txtCol);
    end
    Screen('Flip',wd);
elseif auxVars.giveFeedback
    if resp ~= posSure
        % Put a blue box feedback, empty the others
        fbBox = repmat(cG{fbGam},1,8) + 1.05*sBox;
        Screen('DrawLines',wd,fbBox,linW,blue);
        for i = setdiff(locGam,fbGam)
            sGRect = [cG{i}(1)-3*w,cG{i}(2)-3*w,cG{i}(1)+3*w,cG{i}(2)+3*w];
            Screen('DrawTexture',wd,graySq,[],sGRect);
        end
    else
        Screen('DrawLines',wd,fbSure,linW,blue);
    end
    Screen('Flip',wd,[],1);
    WaitSecs(fbTime);
end