function aborted = instructPDG_EN(auxVars,giveFeedback)

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
  tx{i} = ['Der 2. Test steht bereit.\n'...
           'Jetzt erkl�ren wir die Aufgabe. '...
           'Sie k�nnen mit der '...
           'rechten und linken Pfeiltaste vor- und zur�ck bl�ttern.'];
  func{i} = 'getRarrow';
  showUrns(i) = 0;
i = i+1;
  ypos{i} = yposm;
  tx{i} = ['Sie sollen wieder '...
           'Entscheidungen treffen. '...
           'Sie sehen auf dem Bildschirm immer zwei '...
           'verschiedene K�sten mit Losen.'];
  func{i} = 'getLRarrow';
  showUrns(i) = 0;
i = i+1;
  ypos{i} = yposm;
  tx{i} = ['Auf der einen Seite befindet sich jeweils ein '...
           'Kasten mit einem Gewinnlos. '...
           'Auf der anderen Seite wird Ihnen ein Kasten '...
           'angeboten, in dem sich au�er dem Gewinnlos '...
           'auch Nieten befinden. Wie bei einer Lotterie '...
           'kann es also sein, dass Sie ein Los ziehen, mit '...
           'dem Sie nichts gewinnen.'];
  func{i} = 'getLRarrow';
  showUrns(i) = 0;
i = i+1;
  ypos{i} = yposm;
  tx{i} = ['Damit Sie sich die Ziehung besser vorstellen k�nnen, '...
           'wird Ihnen nun ein Beispieldurchgang gezeigt. '...
           'Sie m�ssen in diesem Beispiel noch keine Auswahl treffen. '...
           'Sehen Sie sich das Beispiel bitte nur an. '...
           'Sie k�nnen mit der '...
           'rechten und linken Pfeiltaste vor- und zur�ck bl�ttern.'];
  func{i} = 'getLRarrow';
  showUrns(i) = 0;
i = i+1;
  ypos{i} = yposm;
  tx{i} = '';  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Message with Urns at the bottom
  func{i} = 'getLRarrow';
  showUrns(i) = 1;
i = i+1;
  ypos{i} = yposm;
  tx{i} = ['Sie k�nnen f�r Ihre Auswahl die linke oder '...
           'die rechte Pfeiltaste benutzen. '...
           'Ihre Wahl wird mit einem gr�nen '...
           'Rahmen angezeigt.'];
  func{i} = 'getLRarrow';
  showUrns(i) = 0;
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
  tx{i} = '';  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  func{i} = 'getLRarrow';
  showUrns(i) = 7;
i = i+1;
  ypos{i} = yposm;
  tx{i} = '';  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  func{i} = 'getLRarrow';
  showUrns(i) = 8;
i = i+1;
  ypos{i} = yposm;
  tx{i} = '';  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  func{i} = 'getLRarrow';
  showUrns(i) = 9;
i = i+1;
  ypos{i} = yposm;
  tx{i} = ['Die Ziehung des Loses wird Ihnen f�r jede '...
           'Entscheidung sofort angezeigt. '...
           'Am Ende des Tests wird ein Durchgang zuf�llig '...
           'ausgew�hlt und entsprechend mit Ihrem Guthaben verrechnet.'];
  func{i} = 'getLRarrow';
  showUrns(i) = 0;
i = i+1;
  ypos{i} = yposm;
  tx{i} = ['In diesem Test gibt es keine '...
           'richtigen oder falschen Antworten. '...
           'Entscheiden Sie sich einfach immer f�r '...
           'den Kasten, der Ihnen am meisten zusagt.\n'...
           'F�r jede Entscheidung haben Sie 5 Sekunden Zeit.'];
  func{i} = 'getLRarrow';
  showUrns(i) = 0;
i = i+1;
  ypos{i} = yposm;
  tx{i} = ['Bitte starten Sie den 2. Test, indem '...
           'Sie die rechte Pfeiltaste dr�cken.'];
func{i} = 'getLRarrow';
showUrns(i) = 0;
if length(func)<i;func{i} = [];end
Pages = i;
page = 1;
while 1
    DrawFormattedText(wd,tx{page},'center',ypos{page},txtCol,txtW,[],[],linSpc);
    switch showUrns(page)
        case 1
            instPDGShow(auxVars,-1,4,15,1/5,2,0,0,0)  % Function at the bottom of page
            txU = ['Ein Beispiel:\n'...
                   'Die Geldbetr�ge sind dabei immer in Euro angegeben.'];
            DrawFormattedText(wd,txU,'center',ypos{page},txtCol,txtW,[],[],linSpc,[],upMsg);
            %%%instPDGShow(auxVars,posSure,xSure,xGam,pGam,locSure,choiceBox,fb,win)
            txL = ['Da der linke Kasten lediglich ein Gewinnlos enth�lt, ist Ihnen dieser '...
                   'Gewinn sicher, falls Sie die linke Alternative w�hlen.\n\n\n'];
            Screen('TextSize',wd,ceil(.55*txtSize));
            winRect = [loMsg(1), loMsg(2), wdw/2, loMsg(4)];
            DrawFormattedText(wd,txL,'center',ypos{page},txtCol,45,[],[],linSpc-.5,[],winRect);
            txR = ['Der rechte Kasten enth�lt ein Gewinnlos und vier Nieten. Falls Sie '...
                   'diesen w�hlen, zieht der Computer zuf�llig eine der Karten. Sie gewinnen '...
                   'also, wenn das Gewinnlos gezogen wird und gehen '...
                   'leer aus, falls eine der vier Nieten gezogen wird.'];
            winRect = [wdw/2, loMsg(2), loMsg(3), loMsg(4)];
            DrawFormattedText(wd,txR,'center',ypos{page},txtCol,45,[],[],linSpc-.5,[],winRect);
            Screen('Flip',wd,[],1);
            Screen('TextSize',wd,txtSize);
            
        case 2
            instPDGShow(auxVars,-1,4,15,1/5,2,-1,0,0)
            txU = ['Angenommen Sie h�tten sich in diesem Fall f�r die '...
                   'linke Seite -die sichere Alternative- entschieden:'];
            txD = ['Der Rahmen gibt folglich an, dass Sie in diesem '...
                   'Durchgang 4 Euro gewonnen h�tten.'];
            DrawFormattedText(wd,txU,'center',ypos{page},txtCol,txtW,[],[],linSpc,[],upMsg);
            DrawFormattedText(wd,txD,'center',ypos{page},txtCol,txtW,[],[],linSpc,[],loMsg);
        case 3
            instPDGShow(auxVars,-1,4,15,1/5,2,1,0,0)
            txU = ['Angenommen Sie h�tten sich in diesem Fall stattdessen '...
                   'f�r die rechte Seite -die Lotterie- entschieden:'];
            txD = ['Da sich nun mehrere Lose in dem rechten Kasten '...
                   'befinden, muss der Computer eines der Lose zuf�llig '...
                   'ziehen, um zu ermitteln ob Sie gewonnen h�tten.'];
            DrawFormattedText(wd,txU,'center',ypos{page},txtCol,txtW,[],[],linSpc,[],upMsg);
            DrawFormattedText(wd,txD,'center',ypos{page},txtCol,txtW,[],[],linSpc,[],loMsg);
        case 4
            txD = 'Sie k�nnen sich die Ziehung des Loses so vorstellen.';
            anim = [4,7,5,3,6];
            for cSlide = 1:5
                instPDGShow(auxVars,-1,4,15,1/5,2,1,anim(cSlide),0)
                DrawFormattedText(wd,txD,'center',ypos{page},txtCol,txtW,[],[],linSpc,[],loMsg);
                Screen('Flip',wd,[],1);
                if cSlide == 1
                    WaitSecs(1);
                else
                    WaitSecs(0.5);
                end
            end
        case 5
            instPDGShow(auxVars,-1,4,15,1/5,2,1,2,0)
            txD = ['In diesem Durchgang h�tten Sie leider nichts gewonnen. '...
                   'Aber was k�nnte passieren, wenn wir die Ziehung wiederholen?'];
            DrawFormattedText(wd,txD,'center',ypos{page},txtCol,txtW,[],[],linSpc,[],loMsg);
        case 6
            instPDGShow(auxVars,-1,4,15,1/5,2,1,2,1);
            txU = 'In diesem Durchgang h�tten Sie 15 Euro gewonnen.';
            txD = ['Auf lange Sicht w�rden Sie bei dieser Lotterie in '...
                   'einem von f�nf Durchg�ngen gewinnen und in vier '...
                   'von f�nf Durchg�ngen nichts gewinnen.'];
            DrawFormattedText(wd,txU,'center',ypos{page},txtCol,txtW,[],[],linSpc,[],upMsg);
            DrawFormattedText(wd,txD,'center',ypos{page},txtCol,txtW,[],[],linSpc,[],loMsg);
        case 7
            instPDGShow(auxVars,1,3,8,1/2,3,0,0,0);
            txU = 'Sehen wir uns noch eine Alternative an:';
            txD = ['Nehmen wir an, dass Sie sich erneut f�r die '...
                   'linke Alternative entscheiden.'];
            DrawFormattedText(wd,txU,'center',ypos{page},txtCol,txtW,[],[],linSpc,[],upMsg);
            DrawFormattedText(wd,txD,'center',ypos{page},txtCol,txtW,[],[],linSpc,[],loMsg);
        case 8
            instPDGShow(auxVars,1,3,8,1/2,3,-1,0,0);
            txD = ['Der gr�ne Rahmen erscheint und im '...
                   'Hintergrund l�uft die Lotterie ab:'];
            DrawFormattedText(wd,txD,'center',ypos{page},txtCol,txtW,[],[],linSpc,[],loMsg);
        case 9
            instPDGShow(auxVars,1,3,8,1/2,3,-1,2,1);
            txD = 'Gl�ckwunsch! In diesem Fall h�tten Sie gewonnen.';
            DrawFormattedText(wd,txD,'center',ypos{page},txtCol,txtW,[],[],linSpc,[],loMsg);
    end
    [page,aborted] = eval([func{page} '(auxVars,page);']); % must contain 'getLRarrow' command
    if aborted;    return;    end
    if page>Pages; break;end
end

for k = 1:3
    text = {['Der 2. Test f�ngt in ' num2str(4-k) ' Sekunden an.']};
    displaytext(text,wd,wdw,wdh,txtCol,1,0);
end

