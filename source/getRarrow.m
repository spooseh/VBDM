function [page,aborted] = getRarrow(auxVars,page)

aborted = 0;
arrCol  = auxVars.txtCol;
bgCol   = auxVars.bgCol;
wd      = auxVars.wd;
txtSize = auxVars.txtSize;
arrTxt  = auxVars.arrTxt;

arrowR  = auxVars.arrowR;
abortK  = auxVars.abortK;

rightK  = auxVars.rightK;
linSpc  = auxVars.linSpc;
txtW    = auxVars.txtW;

if strcmp(auxVars.instLang,'DE')
    txt = {'NÄCHSTE'};
else
    txt = {'NEXT'};
end

isConvex = 0;
Screen('FillPoly', wd, arrCol, arrowR, isConvex);

Screen('TextSize',wd,arrTxt);
DrawFormattedText(wd,txt{1},'center','center',bgCol,txtW,[],[],linSpc,[],auxVars.next);

Screen('TextSize',wd,txtSize);
Screen('Flip',wd);
while 1
    [~,keyCode] = KbStrokeWait;
    key = find(keyCode,1);
    if     key == rightK;             page = page+1;    break;
    
    elseif key == abortK
        aborted = 1;
        return
    end
end
