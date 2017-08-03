function showAllPayments(genInfo,auxVars,Payout,taskList)

wd     = auxVars.wd;
txtCol = auxVars.txtCol;
linSpc = auxVars.linSpc;
txtW   = auxVars.txtW;
lang   = genInfo.language;
if doPay
    if     strcmp(lang,'DE')
        text = {'  ','Aufgabe',cur,'Tagen','Summe'};
        nSpace = num2str(18);
    elseif strcmp(lang,'EN')
        text = {'  ','Task',cur,'days','Sum'};
        nSpace = num2str(17);
    end
    paySum  = 0;
    payText = [text{1} '\n---------------------------------'];
    task = {'DD','PDG','PDL','MG'};
    [~,tmp] = ismember(taskList,task);
    for t = 1:length(taskList)
        if tmp(t) == 1
            toPay = Payout{tmp(t)}.DD(1);
            if isnan(toPay)
                continue;
            end
            payD  = Payout{tmp(t)}.DD(2);
            if payD == 0
                nSpace = num2str(0);
                thisLine = sprintf(['%8s %d: %3d%s %' nSpace 's'],...
                                   text{2},tmp(t),toPay,text{3},' ');
            else
                thisLine = sprintf('%8s %d: %3d%s in %2d %5s',...
                                   text{2},tmp(t),toPay,text{3},payD,text{4}); 
            end
            payText = sprintf('%s\n%s',payText,thisLine);
        else
            eval(['toPay  = Payout{tmp(t)}.' task{tmp(t)} ';']);
            if isnan(toPay)
                continue;
            end
            payText = sprintf(['%s\n%8s %d: %3d%s %' nSpace 's'],...
                payText,text{2},tmp(t),toPay,text{3},' ');
        end
        paySum = paySum + toPay;
    end
    payText = [payText '\n---------------------------------'];
    payText = sprintf('%s\n%11s: %2d%s               \n',payText,text{5},paySum,text{3});
else
    payText = '\n';
end
if     strcmp(lang,'DE')
    text = ['Vielen Dank für Ihre Teilnahme!\n'...
            payText...
           '\nBitte drücken Sie zum Beenden die rechte Pfeiltaste.'];
elseif strcmp(lang,'EN')
    text = ['Thank you very much for your participation!\n'...
            payText...
            '\nPlease press NEXT to terminate.'];
end
fid = fopen(['./data/pay_' genInfo.subjn '.txt'],'w');
fprintf(fid,payText);
fclose(fid);
DrawFormattedText(wd,double(text),'center','center',txtCol,txtW,[],[],.8*linSpc);
getRarrow(auxVars,0);
