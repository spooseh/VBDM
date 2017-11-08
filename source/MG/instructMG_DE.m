function aborted = instructMG_DE(auxVars,giveFeedback)
% Instructions for MG
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
             'Jetzt erklären wir die Aufgabe. '...
             'Sie können mit der '...
             'rechten und linken Pfeiltaste vor- und zurück blättern.']; 
    func{i} = 'getRarrow';
    showUrns(i) = 0;
i = i+1; 
	ypos{i} = yposm;
	tx{i} = ['In diesem Test geht es wieder darum,\n'...
             'Entscheidungen zwischen zwei Kästen zu treffen. '...
             'Ein Kasten enthält immer eine Niete, der andere immer zwei Lose. '...
             'Eins der Lose bedeutet einen Gewinn, das andere einen Verlust.'];
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
    tx{i} = '';  %%%%%%%%%%%%%%%%%%%%%%%%%%% Message with boxes
	func{i} = 'getLRarrow';
    showUrns(i) = 1;
i = i+1; 
	ypos{i} = yposm;
	tx{i} = ['Sie können für Ihre Auswahl die linke oder '...
             'die rechte Pfeiltaste benutzen.\n'...
             'Ihre Wahl wird dann mit einem grünen Rahmen angezeigt.'];
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
             'Wenn Sie sich für eine Lotterie entscheiden wird diese sofort '...
             'vom Computer gespielt und das Ergebnis mit einem blauen Rahmen '...
             'angezeigt. Am Ende des Tests wird ein Durchgang zufällig '...
             'ausgewählt und entsprechend mit Ihrem Guthaben verrechnet.'];
    func{i} = 'getLRarrow';
    showUrns(i) = 0;
i = i+1; 
	ypos{i} = yposm;
	tx{i} = ['In diesem Test gibt es keine '...
             'richtigen und falschen Antworten. '...
             'Sie sollen sich in jeder Runde entscheiden, '...
             'ob sich die angebotene Lotterie für Sie lohnt oder nicht.\n\n'...
             'Für jede Entscheidung haben Sie 5 Sekunden Zeit.'];
    func{i} = 'getLRarrow';
    showUrns(i) = 0;
i = i+1; 
	ypos{i} = yposm;
	tx{i} = ['Bitte starten Sie den 4. Test, indem '...
             'Sie die rechte Pfeiltaste drücken.'];
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
            txD = 'Die Geldbeträge sind dabei immer in Euro angegeben.';
            DrawFormattedText(wd,txU,'center',ypos{page},txtCol,txtW,[],[],linSpc,[],upMsg);
            DrawFormattedText(wd,txD,'center',ypos{page},txtCol,txtW,[],[],linSpc,[],loMsg);
        case 2
            instMGShow(auxVars,-1,[15,-7],3,[1,3],-1,0,0);
            txU = ['Wenn Sie den Kasten mit der Niete wählen, werden Sie '...
                   'weder Geld gewinnen noch verlieren.'];
            DrawFormattedText(wd,txU,'center',ypos{page},txtCol,txtW,[],[],linSpc,[],upMsg);
        case 3
            instMGShow(auxVars,-1,[15,-7],3,[1,3],1,0,0);
            txU = ['Wenn Sie den Kasten mit der Lotterie wählen, spielen '...
                   'Sie um die dargestellten Geldbeträge.'];
            txD = ['Dabei ist die Chance zu gewinnen immer '...
                   'genauso groß wie die Chance zu verlieren.'];
            DrawFormattedText(wd,txU,'center',ypos{page},txtCol,txtW,[],[],linSpc,[],upMsg);
            DrawFormattedText(wd,txD,'center',ypos{page},txtCol,txtW,[],[],linSpc,[],loMsg);
    end
    [page,aborted] = eval([func{page} '(auxVars,page);']); % must contain 'getLRarrow' command 
    if aborted;    return;    end
    if page > Pages;    break;    end
end

for k=1:3
	text = {['Der 4. Test fängt in ' num2str(4-k) ' Sekunden an.']};
	displaytext(text,wd,wdw,wdh,txtCol,0,0);
	WaitSecs(1);
end

