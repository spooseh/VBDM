function aborted = instructPDL_EN(auxVars,giveFeedback)
% Instructions for PDL
txtCol  = auxVars.txtCol;
txtSize = auxVars.txtSize;
txtW    = auxVars.txtW;
linSpc  = auxVars.linSpc;
wd      = auxVars.wd;
wdw     = auxVars.wdw;
wdh     = auxVars.wdh;
upMsg   = auxVars.upMsg;
loMsg   = auxVars.loMsg;
i = 0; 
func{1} = [];
yposm = 'center';
i = i+1; 
	ypos{i} = yposm;
	tx{i} = ['Der 3. Test steht bereit.\n Jetzt erklären wir '...
             'die Aufgabe. Sie können '...
             'mit der rechten und linken Pfeiltaste vor- und zurück blättern.']; 
    func{i}='getRarrow';
    showUrns(i) = 0;
i = i+1; 
	ypos{i} = yposm;
	tx{i} = ['Der folgende Test ähnelt dem letzten. '...
             'Sie sollen eine Entscheidung zwischen zwei '...
             'Kästen mit Losen treffen. Aber die Lose entsprechen '...
             'jetzt keinen Gewinnen sondern Verlusten. '...
             'Alle Geldbeträge sind in Euro angegeben.'];
    func{i} = 'getLRarrow';
    showUrns(i) = 0;
i = i+1; 
	ypos{i} = yposm;
	tx{i} = ['Auf der einen Seite des Bildschirms befindet sich '...
             'jeweils ein Kasten mit nur einem einzigen Verlustlos. '...
             'Entscheiden Sie sich für diesen Kasten, verlieren Sie '...
             'den angezeigten Geldbetrag.'];
    func{i} = 'getLRarrow';
    showUrns(i) = 0;
i = i+1; 
	ypos{i} = yposm;
	tx{i} = ['Auf der anderen Seite des Bildschirms wird Ihnen '...
             'als Alternative eine Lotterie angeboten. In der '...
             'Lotterie befinden sich neben einem oder mehreren '...
             'Verlustlosen auch Lose, die dazu führen, dass Sie '...
             'nichts verlieren.'];
    func{i} = 'getLRarrow';
    showUrns(i) = 0;
i = i+1; 
	ypos{i} = yposm;
	tx{i} = ['Sie können für Ihre Auswahl die linke oder rechte '...
             'Pfeiltaste benutzen. Ihre Wahl wird wieder mit einem '...
             'grünen Rahmen angezeigt.'];   
    func{i} = 'getLRarrow';
    showUrns(i) = 0;
i = i+1; 
	ypos{i} = yposm;
	tx{i} = ['Wenn Sie sich für eine Lotterie entscheiden, wird '...
             'diese im Hintergrund gespielt und Ihnen angezeigt. ' ...
             'Am Ende des Tests wird ein Durchgang zufällig '...
             'ausgewählt und entsprechend mit Ihrem Guthaben verrechnet.'];
    func{i} = 'getLRarrow';
    showUrns(i) = 0;
i = i+1;
  ypos{i} = yposm;
  tx{i} = ['Damit Sie sich die Ziehung besser vorstellen können, '...
           'wird Ihnen nun ein Beispieldurchgang gezeigt. '...
           'Sie müssen in diesem Beispiel noch keine Auswahl treffen. '...
           'Sehen Sie sich das Beispiel bitte nur an. '...
           'Sie können mit der '...
           'rechten und linken Pfeiltaste vor- und zurück blättern.'];
  func{i} = 'getLRarrow';
  showUrns(i) = 0;
i = i+1;
  ypos{i} = yposm;
  tx{i} = '';  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Message with Urns at the bottom
  func{i} = 'getLRarrow';
  showUrns(i) = 1;
i = i+1;
  ypos{i} = yposm;
  tx{i} = '';  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  func{i} = 'getLRarrow';
  showUrns(i) = 2;
i = i+1;
  ypos{i} = yposm;
  tx{i} = '';  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  func{i} = 'getLRarrow';
  showUrns(i) = 3;
i = i+1;
  ypos{i} = yposm;
  tx{i} = '';  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  func{i} = 'getLRarrow';
  showUrns(i) = 4;
i = i+1;
  ypos{i} = yposm;
  tx{i} = '';  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  func{i} = 'getLRarrow';
  showUrns(i) = 5;
i = i+1;
  ypos{i} = yposm;
  tx{i} = '';  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  func{i} = 'getLRarrow';
  showUrns(i) = 6;
i = i+1; 
	ypos{i} = yposm;
	tx{i} = ['In diesem Test gibt es keine richtigen oder '...
             'falschen Antworten. Entscheiden Sie sich bitte immer '...
             'für die Alternative, die Ihnen jeweils am meisten zusagt.'];
    func{i} = 'getLRarrow';    
    showUrns(i) = 0;
i = i+1; 
	ypos{i} = yposm;
	tx{i} = ['Bitte starten Sie den 3. Test, indem Sie '...
             'die rechte Pfeiltaste drücken.'];
    func{i} = 'getLRarrow';
    showUrns(i) = 0;
   
if length(func) < i;    func{i} = [];    end
Pages = i;
page  = 1;
while 1
    DrawFormattedText(wd,tx{page},'center',ypos{page},txtCol,txtW,[],[],linSpc);
    switch showUrns(page)
        case 1
            instPDGShow(auxVars,-1,-4,-15,1/5,2,0,0,0)  % Function at the bottom of page
            txU = ['Ein Beispiel:\n'...
                   'Die Geldbeträge sind dabei immer in Euro angegeben.'];
            DrawFormattedText(wd,txU,'center',ypos{page},txtCol,txtW,[],[],linSpc,[],upMsg);
            %%%instPDGShow(auxVars,posSure,xSure,xGam,pGam,locSure,choiceBox,fb,win)
            txL = ['Da der linke Kasten lediglich ein Verlustlos enthält, ist Ihnen dieser '...
                   'Verlust sicher, falls Sie die linke Alternative wählen.\n\n\n'];
            Screen('TextSize',wd,ceil(.55*txtSize));
            winRect = [loMsg(1), loMsg(2), wdw/2, loMsg(4)];
            DrawFormattedText(wd,txL,'center',ypos{page},txtCol,45,[],[],linSpc-.5,[],winRect);
            txR = ['Der rechte Kasten enthält ein Verlustlos und vier leere Lose. Falls Sie '...
                   'diesen wählen, zieht der Computer zufällig eine der Karten. Sie verlieren '...
                   'also, wenn das Verlustlos gezogen wird und bleiben '...
                   'ohne Verlust, falls eines der vier leeren Lose gezogen wird.'];
            winRect = [wdw/2, loMsg(2), loMsg(3), loMsg(4)];
            DrawFormattedText(wd,txR,'center',ypos{page},txtCol,45,[],[],linSpc-.5,[],winRect);
            Screen('Flip',wd,[],1);
            Screen('TextSize',wd,txtSize);
            
        case 2
            instPDGShow(auxVars,-1,-4,-15,1/5,2,-1,0,0)
            txU = ['Angenommen Sie hätten sich in diesem Fall für die '...
                   'linke Seite -die sichere Alternative- entschieden:'];
            txD = ['Der Rahmen gibt folglich an, dass Sie in diesem '...
                   'Durchgang 4 Euro verloren hätten.'];
            DrawFormattedText(wd,txU,'center',ypos{page},txtCol,txtW,[],[],linSpc,[],upMsg);
            DrawFormattedText(wd,txD,'center',ypos{page},txtCol,txtW,[],[],linSpc,[],loMsg);
        case 3
            instPDGShow(auxVars,-1,-4,-15,1/5,2,1,0,0)
            txU = ['Angenommen Sie hätten sich in diesem Fall stattdessen '...
                   'für die rechte Seite -die Lotterie- entschieden:'];
            txD = ['Da sich nun mehrere Lose in dem rechten Kasten '...
                   'befinden, muss der Computer eines der Lose zufällig '...
                   'ziehen, um zu ermitteln ob Sie verloren hätten.'];
            DrawFormattedText(wd,txU,'center',ypos{page},txtCol,txtW,[],[],linSpc,[],upMsg);
            DrawFormattedText(wd,txD,'center',ypos{page},txtCol,txtW,[],[],linSpc,[],loMsg);
        case 4
            anim = [4,7,5,3,6];
            for cSlide = 1:5
                instPDGShow(auxVars,-1,-4,-15,1/5,2,1,anim(cSlide),0)
                txD = 'Sie können sich die Ziehung des Loses so vorstellen.';
                DrawFormattedText(wd,txD,'center',ypos{page},txtCol,txtW,[],[],linSpc,[],loMsg);
                Screen('Flip',wd,[],1);
                if cSlide == 1
                    WaitSecs(1);
                else
                    WaitSecs(0.5);
                end
            end
        case 5
            instPDGShow(auxVars,-1,-4,-15,1/5,2,1,2,0)
            txD = ['In diesem Durchgang wären Sie ohne Verlust geblieben. '...
                   'Aber was könnte passieren, wenn wir die Ziehung wiederholen?'];
            DrawFormattedText(wd,txD,'center',ypos{page},txtCol,txtW,[],[],linSpc,[],loMsg);
        case 6
            instPDGShow(auxVars,-1,-4,-15,1/5,2,1,2,1);
            txU = 'In diesem Durchgang hätten Sie 15 Euro verloren.';
            txD = ['Auf lange Sicht würden Sie bei dieser Lotterie in '...
                   'einem von fünf Durchgängen verlieren und in vier '...
                   'von fünf Durchgängen ohne Verlust bleiben.'];
            DrawFormattedText(wd,txU,'center',ypos{page},txtCol,txtW,[],[],linSpc,[],upMsg);
            DrawFormattedText(wd,txD,'center',ypos{page},txtCol,txtW,[],[],linSpc,[],loMsg);
    end
    [page,aborted] = eval([func{page} '(auxVars,page);']); % must contain 'getLRarrow' command
    if aborted;    return;    end
    if page>Pages; break;end
end
for k = 1:3
	text = {['Der 3. Test fängt in ' num2str(4-k) ' Sekunden an.']};
	displaytext(text,wd,wdw,wdh,txtCol,1,0);
end
