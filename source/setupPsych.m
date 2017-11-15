function auxVars = setupPsych(debug) 
% Task setup and layout 
bgCol = 200;	% in grayscale
if (~debug && ~ismac && ~IsLinux)
    HideCursor
    ShowHideWinTaskbarMex(0);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Open a screen
AssertOpenGL;
imagingmode = kPsychNeedFastBackingStore;	% flip takes ages without this
Screen('Preference','Verbosity',0);
Screen('Preference', 'TextAntiAliasing', 2);
Screen('Preference', 'TextRenderer', 1);
Screen('Preference','TextEncodingLocale','UTF-8');
if debug;
    Screen('Preference','SkipSyncTests',2); % ONLY do this for quick debugging;
    wd = Screen('OpenWindow',0,bgCol,[100 100 1124 868],[],2,[],[],imagingmode); % make small PTB screen on my large screen
else
    wd = Screen('OpenWindow',0,bgCol,[],[],2,[],[],imagingmode);			% Get Screen. This is always size of the display.
end
KbName('UnifyKeyNames'); % need this for KbName to behave
Screen('TextFont',wd,'Arial');
Screen('TextStyle', wd, 0);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Times
auxVars.fbTime       = 1;
auxVars.intTrialInt  = 0.5;
WaitSecs(2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Colors
auxVars.bgCol    = bgCol;
auxVars.black 	 = [0 0 0];
auxVars.blue     = [0 0 150];
auxVars.gray     = 255/2;
auxVars.green    = [0 210 0]; 
auxVars.lightCol = 245;
auxVars.txtCol 	 = auxVars.black;
auxVars.white    = 255;

auxVars.lightSq  = Screen('MakeTexture',wd,auxVars.lightCol);
auxVars.graySq   = Screen('MakeTexture',wd,bgCol);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Keys
auxVars.abortK = KbName('ESCAPE');
auxVars.leftK  = KbName('LeftArrow');
auxVars.rightK = KbName('RightArrow');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Presentation coordinates
[wdw, wdh]  = Screen('WindowSize', wd);	% Get screen size 
auxVars.wd  = wd;
auxVars.wdw = wdw;
auxVars.wdh = wdh;
if wdh < 864       % 1024 x 768 full screen
    wBox = round(wdh/70);
    rectL = round([wdw/2-42*wBox, .90*wdh, wdw/2-35*wBox, .98*wdh]);
    rectR = round([wdw/2+35*wBox, .90*wdh, wdw/2+42*wBox, .98*wdh]);
else
    wBox = 13; % Gives a 20° visual angle on 70 cm
    rectL = round([wdw/2-44*wBox, .90*wdh, wdw/2-35*wBox, .98*wdh]);
    rectR = round([wdw/2+35*wBox, .90*wdh, wdw/2+44*wBox, .98*wdh]);
end
auxVars.wBox = wBox;
auxVars.linW = ceil(wBox/3);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
auxVars.upMsg = [wdw/2-42*wBox,      0.05*wdh, wdw/2+42*wBox, wdh/2-12*wBox];
auxVars.loMsg = [wdw/2-42*wBox, wdh/2+12*wBox, wdw/2+42*wBox, 0.98*wdh];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Arrows
w = (rectR(3)-rectR(1));
h = (rectR(4)-rectR(2));
xVecR = rectR(1)+ w*[  0,2/3,2/3,  1,2/3,2/3,  0,  0];
yVecR = rectR(2)+ h*[1/4,1/4,  0,1/2,  1,3/4,3/4,1/4];

xVecL = rectL(1) + w*[  0,1/3,1/3,  1,  1,1/3,1/3,  0];
yVecL = rectL(2) + h*[1/2,  0,1/4,1/4,3/4,3/4,  1,1/2];

auxVars.back   = rectL + round([w/5,0,0   ,0]);
auxVars.next   = rectR + round([  0,0,-w/6,0]);
txtsize = 0;
Screen('TextSize',wd,txtsize);			% Set size of text
[~,~,wt] = DrawFormattedText(wd,'NÄCHSTE');
x = .8*w;
dw  = wt(3)-wt(1)-x; 
while dw < 0
	txtsize = txtsize + 1; 
    Screen('TextSize',wd,txtsize);
    [~,~,wt] = DrawFormattedText(wd,'NÄCHSTE');
    dw  = wt(3)-wt(1)-x;
end
auxVars.arrTxt = txtsize;

auxVars.arrowL = [xVecL; yVecL]';
auxVars.arrowR = [xVecR; yVecR]';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Text
auxVars.linSpc = 1.8;
auxVars.txtW   = 55;

txtsize = 0;
Screen('TextSize',wd,txtsize);			% Set size of text
[~,~,wt] = DrawFormattedText(wd,'-50 ');
dw  = wt(3)-wt(1)-6*wBox; % 6xw is the width of the small boxes
while dw < 0
	txtsize = txtsize + 1; 
    Screen('TextSize',wd,txtsize);
    [~,~,wt] = DrawFormattedText(wd,'-50 ');
    dw  = wt(3)-wt(1)-6*wBox;% Text out of box if negative
end
Screen('FillRect', wd, bgCol);
auxVars.txtSize = txtsize;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if ~exist('./data','dir'); mkdir('data'); end
