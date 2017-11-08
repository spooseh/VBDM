function [page,aborted] = getLRarrow(auxVars,page)
% Navigation arrows
aborted = 0;
arrCol  = auxVars.txtCol;
bgCol   = auxVars.bgCol;
wd      = auxVars.wd;
txtSize = auxVars.txtSize;
arrTxt  = auxVars.arrTxt;
arrowL  = auxVars.arrowL;
arrowR  = auxVars.arrowR;
abortK  = auxVars.abortK;
leftK   = auxVars.leftK;
rightK  = auxVars.rightK;
linSpc  = auxVars.linSpc;
txtW    = auxVars.txtW;


if strcmp(auxVars.instLang,'DE')
    txt = {'NÄCHSTE','ZURÜCK'};
else
    txt = {'NEXT','BACK'};
end

isConvex = 0;
Screen('FillPoly', wd, arrCol, arrowR, isConvex);
Screen('FillPoly', wd, arrCol, arrowL, isConvex);
Screen('TextSize',wd,arrTxt);
DrawFormattedText(wd,txt{1},'center','center',bgCol,txtW,[],[],linSpc,[],auxVars.next);
DrawFormattedText(wd,txt{2},'center','center',bgCol,txtW,[],[],linSpc,[],auxVars.back);
Screen('TextSize',wd,txtSize);
Screen('Flip',wd);
while 1
    [~,keyCode] = KbStrokeWait;
    key = find(keyCode,1);
    if     key == rightK;             page = page+1;    break;
    elseif key == leftK && page>1;    page = page-1;    break;
    elseif key == abortK
        aborted = 1;
        return
    end
end

