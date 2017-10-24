function aborted = instructDD_DE(auxVars)

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
i=i+1;
    tx{i} = ['Der 1. Test steht bereit.\n'...
             'Jetzt erklären wir die Aufgabe. '...
             'Sie können mit der '...
             'rechten und linken Pfeiltaste vor- und zurück blättern.'];
    func{i}='getRarrow';
    showUrns(i) = 0;
i=i+1; 
    tx{i} = 'Sie sollen sich zwischen zwei Geldbeträgen entscheiden.'; 
    func{i}='getLRarrow';
    showUrns(i) = 0;
i=i+1; 
    tx{i} = 'Sie sollen sich zwischen zwei Geldbeträgen entscheiden.'; 
    func{i}='getLRarrow';
    showUrns(i) = 0;
i=i+1; 
	tx{i} = ['Stellen Sie sich vor, der eine Geldbetrag wird Ihnen jetzt ausgezahlt, '...
             'der andere wird zu dem angegebenen Zeitpunkt an Sie überwiesen.'];
    func{i}='getLRarrow';
    showUrns(i) = 0;
i = i+1;
  tx{i} = ['Damit Sie sich die Aufgabe besser vorstellen können, '...
           'wird Ihnen nun ein Beispieldurchgang gezeigt. '...
           'Sie müssen in diesem Beispiel noch keine Auswahl treffen. '...
           'Sehen Sie sich das Beispiel bitte nur an. '...
           'Sie können mit der '...
           'rechten und linken Pfeiltaste vor- und zurück blättern.'];
  func{i} = 'getLRarrow';
  showUrns(i) = 0;    
i = i+1; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    tx{i} = '';
    func{i} = 'getLRarrow';
    showUrns(i) = 1;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i=i+1; 
    tx{i} = ['Für Ihre Auswahl benutzen Sie die linke oder die rechte Pfeiltaste. '...
             'Sie haben 5 Sekunden Zeit für Ihre Entscheidung. '...
             'Ihre Wahl wird mit einem grünen Rahmen angezeigt.'];
    func{i}='getLRarrow';
    showUrns(i) = 0;
i = i+1; 
    tx{i} = '';  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    func{i} = 'getLRarrow';
    showUrns(i) = 2;
i = i+1; 
    tx{i} = '';  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	func{i} = 'getLRarrow';
    showUrns(i) = 3;
i = i+1; 
    tx{i} = ['Am Ende der Aufgabe wählt der Computer zufällig '...
             'einen Durchgang aus, und die zuvor von Ihnen gewählte '...
             'Alternative wird zum entsprechenden Zeitpunkt an '...
             'Sie ausgezahlt.'];   
    func{i} = 'getLRarrow';
    showUrns(i) = 0;
i = i+1; 
    tx{i} = 'Bitte starten Sie den 1. Test, indem Sie die rechte Pfeiltaste drücken.';
    func{i} = 'getLRarrow';
    showUrns(i) = 0;
    
if length(func) < i;    func{i} = [];    end
Pages = i;
page = 1;
while 1
	DrawFormattedText(wd,tx{page},'center','center',txtCol,txtW,[],[],linSpc);
    switch showUrns(page)
        case 1
            %instDDShow(auxVars,posSure,xSure,xRisk,choiceBox)
            instDDShow(auxVars,1,5,[10,14],0);
            txU = 'Zum Beispiel 5 Euro jetzt oder 10 Euro in 2 Wochen.';
            txD = ['Entscheiden Sie sich einfach immer für die Alternative, '...
                   'die Ihnen mehr zusagt.'];
            DrawFormattedText(wd,txU,'center','center',txtCol,txtW,[],[],linSpc,[],upMsg);
            DrawFormattedText(wd,txD,'center','center',txtCol,txtW,[],[],linSpc,[],loMsg);
        case 2
            instDDShow(auxVars,1,5,[10,14],1);
            txU = 'Wenn Sie sich für 5 Euro jetzt entscheiden:';
            txD = 'Ihre Wahl wird dann mit einem grünen Rahmen angezeigt.';
            DrawFormattedText(wd,txU,'center','center',txtCol,txtW,[],[],linSpc,[],upMsg);
            DrawFormattedText(wd,txD,'center','center',txtCol,txtW,[],[],linSpc,[],loMsg);
        case 3
            instDDShow(auxVars,1,5,[10,14],-1);
            txU = ['Oder für 10 Euro in 2 Wochen:'];
            DrawFormattedText(wd,txU,'center','center',txtCol,txtW,[],[],linSpc,[],upMsg);
    end
    [page,aborted] = eval([func{page} '(auxVars,page);']); % must contain 'getLRarrow' command 
    if aborted;    return;    end
	if page > Pages; break;end
end

for k = 1:3
	text = {['Der nächste Teil fängt in ' num2str(4-k) ' Sekunden an.']};
	displaytext(text,wd,wdw,wdh,txtCol,1,0);
end

function instDDShow(auxVars,posSure,xSure,xRisk,choiceBox)

black   = auxVars.black;
bgCol   = auxVars.bgCol;
cur    = auxVars.currency;
green   = auxVars.green;
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

Box  = [-1 +1 +1 +1 +1 -1 -1 -1; % 2 units square box relative to it's center
    -1 -1 -1 +1 +1 +1 +1 -1];
bBox = 12*w*Box; % Big box relative to it's center

lBox = repmat(cL,1,8) + bBox;
rBox = repmat(cR,1,8) + bBox;
pickL = repmat(cL,1,8) + 1.05*bBox;
pickR = repmat(cR,1,8) + 1.05*bBox;

Screen('FillRect', wd, bgCol);
Screen('DrawLines',wd,lBox,linW,black);
Screen('DrawLines',wd,rBox,linW,black);
txtD = {'drei Tagen', 'einer Woche', 'zwei Wochen',...
    'einem Monat','zwei Monaten','sechs Monaten',...
    'einem Jahr'};
txtDi = find([3 7 14 31 61 180 365] == xRisk(2));

if posSure == -1
    txtL = double(sprintf('%d %s\n\njetzt',xSure,cur));
    txtR = double(sprintf('%d %s\n\n%s',xRisk(1),cur,txtD{txtDi}));
else
    txtL = double(sprintf('%d %s\n\n%s',xRisk(1),cur,txtD{txtDi}));
    txtR = double(sprintf('%d %s\n\njetzt',xSure,cur));
end
rectL = [lBox(:,1)',lBox(:,4)'];
rectR = [rBox(:,1)',rBox(:,4)'];
DrawFormattedText(wd,txtL,'center','center',txtCol,txtW,[],[],0.67 * linSpc,[],rectL);
DrawFormattedText(wd,txtR,'center','center',txtCol,txtW,[],[],0.67 * linSpc,[],rectR);
if   choiceBox == -1
    Screen('DrawLines',wd,pickL,linW,green);
elseif choiceBox == 1
    Screen('DrawLines',wd,pickR,linW,green);
end

Screen('Flip',wd,[],1);
