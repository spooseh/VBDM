function aborted = instructMG_DE(auxVars,giveFeedback)

wd     = auxVars.wd;
wdw    = auxVars.wdw;
wdh    = auxVars.wdh;
upMsg  = auxVars.upMsg;
loMsg  = auxVars.loMsg;
txtCol = auxVars.txtCol;
linSpc = auxVars.linSpc;
txtW   = auxVars.txtW;

i = 0; 
func{1} = [];
yposm = 'center';
i = i+1; 
	ypos{i} = yposm;
	tx{i} = ['Der 4. Test steht bereit.\n'...
             'Jetzt erkl�ren wir die Aufgabe. '...
             'Sie k�nnen mit der '...
             'rechten und linken Pfeiltaste vor- und zur�ck bl�ttern.']; 
    func{i} = 'getRarrow';
    showUrns(i) = 0;
i = i+1; 
	ypos{i} = yposm;
	tx{i} = ['In diesem Test geht es wieder darum,\n'...
             'Entscheidungen zwischen zwei K�sten zu treffen. '...
             'Ein Kasten enth�lt immer eine Niete, der andere immer zwei Lose. '...
             'Eins der Lose bedeutet einen Gewinn, das andere einen Verlust.'];
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
    tx{i} = '';  %%%%%%%%%%%%%%%%%%%%%%%%%%% Message with boxes
	func{i} = 'getLRarrow';
    showUrns(i) = 1;
i = i+1; 
	ypos{i} = yposm;
	tx{i} = ['Sie k�nnen f�r Ihre Auswahl die linke oder '...
             'die rechte Pfeiltaste benutzen.\n'...
             'Ihre Wahl wird dann mit einem gr�nen Rahmen angezeigt.'];
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
	tx{i} = ['Zu Beginn der Aufgabe bekommen Sie von uns '...
             '10 Euro Ihrem Spielkonto gutgeschrieben.\n'...
             'Wenn Sie sich f�r eine Lotterie entscheiden wird diese sofort '...
             'vom Computer gespielt und das Ergebnis mit einem blauen Rahmen '...
             'angezeigt. Am Ende des Tests wird ein Durchgang zuf�llig '...
             'ausgew�hlt und entsprechend mit Ihrem Guthaben verrechnet.'];
    func{i} = 'getLRarrow';
    showUrns(i) = 0;
i = i+1; 
	ypos{i} = yposm;
	tx{i} = ['In diesem Test gibt es keine '...
             'richtigen und falschen Antworten. '...
             'Sie sollen sich in jeder Runde entscheiden, '...
             'ob sich die angebotene Lotterie f�r Sie lohnt oder nicht.\n\n'...
             'F�r jede Entscheidung haben Sie 5 Sekunden Zeit.'];
    func{i} = 'getLRarrow';
    showUrns(i) = 0;
i = i+1; 
	ypos{i} = yposm;
	tx{i} = ['Bitte starten Sie den 4. Test, indem '...
             'Sie die rechte Pfeiltaste dr�cken.'];
    func{i} = 'getLRarrow';
    showUrns(i) = 0;
if length(func) < i;    func{i} = [];    end
Pages = i;
page  = 1;
while 1
    DrawFormattedText(wd,tx{page},'center',ypos{page},txtCol,txtW,[],[],linSpc);
    switch showUrns(page)
        case 1
            %instMGShow(auxVars,posSure,xRisk,locSure,locGam,choiceBox,fb,win)
            instMGShow(auxVars,-1,[15,-7],3,[1,3],0,0,0);
            txU = 'Ein Beispiel:\n';
            txD = 'Die Geldbetr�ge sind dabei immer in Euro angegeben.';
            DrawFormattedText(wd,txU,'center',ypos{page},txtCol,txtW,[],[],linSpc,[],upMsg);
            DrawFormattedText(wd,txD,'center',ypos{page},txtCol,txtW,[],[],linSpc,[],loMsg);
        case 2
            instMGShow(auxVars,-1,[15,-7],3,[1,3],-1,0,0);
            txU = ['Wenn Sie den Kasten mit der Niete w�hlen, werden Sie '...
                   'weder Geld gewinnen noch verlieren.'];
            DrawFormattedText(wd,txU,'center',ypos{page},txtCol,txtW,[],[],linSpc,[],upMsg);
        case 3
            instMGShow(auxVars,-1,[15,-7],3,[1,3],1,0,0);
            txU = ['Wenn Sie den Kasten mit der Lotterie w�hlen, spielen '...
                   'Sie um die dargestellten Geldbetr�ge.'];
            txD = ['Dabei ist die Chance zu gewinnen immer '...
                   'genauso gro� wie die Chance zu verlieren.'];
            DrawFormattedText(wd,txU,'center',ypos{page},txtCol,txtW,[],[],linSpc,[],upMsg);
            DrawFormattedText(wd,txD,'center',ypos{page},txtCol,txtW,[],[],linSpc,[],loMsg);
    end
    [page,aborted] = eval([func{page} '(auxVars,page);']); % must contain 'getLRarrow' command 
    if aborted;    return;    end
    if page > Pages;    break;    end
end

for k=1:3
	text = {['Der 4. Test f�ngt in ' num2str(4-k) ' Sekunden an.']};
	displaytext(text,wd,wdw,wdh,txtCol,0,0);
	WaitSecs(1);
end

