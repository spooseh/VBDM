function instMGShow(auxVars,posSure,xRisk,locSure,locGam,choiceBox,fb,win)

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
cSure = {centerSure-w*[-4;-4],centerSure-w*[+4;-4],centerSure-w*[+4;+4],centerSure-w*[-4;+4]}; % Centers for sure offer
sS = repmat(cSure{locSure},1,8) + sBox;
sSRect = [sS(:,1)',sS(:,4)'];
sGCross = sS(:,[1,4,2,6]);
Screen('DrawTexture',wd,graySq,[],sSRect);
Screen('DrawLines',wd,sS,linW,black);
Screen('DrawLines',wd,sGCross,linW,black);
fbSure = repmat(cSure{locSure},1,8) + 1.05*sBox;
        
cG = {centerGam-w*[-4;-4],centerGam-w*[+4;-4],centerGam-w*[+4;+4],centerGam-w*[-4;+4]}; % Centers for gambling offer
for k = 1:2
    i = locGam(k);
    sG = repmat(cG{i},1,8) + sBox; % Small box for gambling offer
    sGRect = [sG(:,1)',sG(:,4)'];
    Screen('DrawTexture',wd,lightSq,[],sGRect);
    DrawFormattedText(wd,num2str(xRisk(k)),'center','center',txtCol,55,[],[],1.8,[],sGRect);
    Screen('DrawLines',wd,sG,linW,black);
end
if win == 1
    fbGam = locGam(1); % The first element of xGam is the gain
else
    fbGam = locGam(2);
end
%%%%%%%%%%%%%
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
elseif fb > 2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    fbBox = repmat(cG{fb-2},1,8) + 1.05*sBox;
    Screen('DrawLines',wd,fbBox,linW,blue);
end
Screen('Flip',wd,[],1);
