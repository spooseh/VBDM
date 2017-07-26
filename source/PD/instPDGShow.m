function instPDGShow(auxVars,posSure,xSure,xGam,pGam,locSure,choiceBox,fb,win)

black   = auxVars.black;
blue    = auxVars.blue;
bgCol   = auxVars.bgCol;
graySq  = auxVars.graySq;
green   = auxVars.green;
lightSq = auxVars.lightSq;
linW    = auxVars.linW;
txtCol  = auxVars.txtCol;
w       = auxVars.wBox;
wd      = auxVars.wd;
wdh     = auxVars.wdh;
wdw     = auxVars.wdw;
linSpc  = auxVars.linSpc;
txtW    = auxVars.txtW;

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
cSure = {centerSure,centerSure-w*[-4;-4],centerSure-w*[+4;-4],centerSure-w*[+4;+4],centerSure-w*[-4;+4]}; % Centers for sure offer
sS = repmat(cSure{locSure},1,8) + sBox;
sSRect = [sS(:,1)',sS(:,4)'];
Screen('DrawTexture',wd,lightSq,[],sSRect);
DrawFormattedText(wd,num2str(xSure),'center','center',txtCol,txtW,[],[],linSpc,[],sSRect);
Screen('DrawLines',wd,sS,linW,black);

cG = {centerGam,centerGam-w*[-7;-7],centerGam-w*[+7;-7],centerGam-w*[+7;+7],centerGam-w*[-7;+7]}; % Centers for gambling offer
probs = [2/3, 1/2, 1/3, 1/4, 1/5];
allBoxs = {[1,3,5],[2,4],[1,3,5],[1,2,3,5],1:5};
nEmpty = [1,1,2,3,4];
locInd = find(probs == pGam);
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
    DrawFormattedText(wd,num2str(xGam),'center','center',txtCol,txtW,[],[],linSpc,[],sGRect);
    Screen('DrawLines',wd,sG,linW,black);
end
fbNZero = i; % The last full box for the feedback
if win
    fbGam = fbNZero;
else
    fbGam = fbZero;
end
if   choiceBox == -1
    Screen('DrawLines',wd,pickL,linW,green);
elseif choiceBox == 1
    Screen('DrawLines',wd,pickR,linW,green);
end

if fb == 1 % Put a blue box feedback on the sure offer
    fbBox = repmat(cSure{locSure},1,8) + 1.05*sBox;
    Screen('DrawLines',wd,fbBox,linW,blue);
elseif fb == 2 % Put a blue box feedback on the risky offer
    fbBox = repmat(cG{fbGam},1,8) + 1.05*sBox;
    Screen('DrawLines',wd,fbBox,linW,blue);
elseif fb > 2 
    fbBox = repmat(cG{fb-2},1,8) + 1.05*sBox;
    Screen('DrawLines',wd,fbBox,linW,blue);
end
Screen('Flip',wd,[],1);
