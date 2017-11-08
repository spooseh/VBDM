function runTasks(genInfo,taskList)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Setup screen
clear MEX
crashed = 0;
genInfo.date = datestr(now,'yymmdd');
auxVars = setupPsych(genInfo.doDebug);
auxVars.giveFeedback = genInfo.giveFeedback;
auxVars.instLang     = genInfo.language;
if exist('OCTAVE_VERSION', 'builtin')
    rand('twister',sum(1000*clock));
    auxVars.currency = '$';
else
    if verLessThan('matlab','7.14')
        rand('twister',sum(1000*clock)); % MATLAB R2011 and earlier
    else
        rng('default')
        rng('shuffle');                  % MATLAB R2012 and later
    end
    if     strcmp(genInfo.language,'DE')
        auxVars.currency = '€';
    elseif strcmp(genInfo.language,'EN')
        auxVars.currency = '$';
    end
end
if genInfo.timedStimulus
    auxVars.stimDuration = 5;
else
    auxVars.stimDuration = 100;
end
linSpc = auxVars.linSpc;
txtW   = auxVars.txtW;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Payment limits
auxVars.houseMoney =  10;
auxVars.maxPay     =  20;
auxVars.maxLoss    = -15;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Run selected tasks
N = length(taskList);
if     strcmp(genInfo.language,'DE')
    aborted  = instructAll_DE(auxVars,N);
elseif strcmp(genInfo.language,'EN')
    aborted  = instructAll_EN(auxVars,N);
end
if aborted
    abortExp(auxVars);
    closeExperiment;
    return;
end
task = {'DD','PDG','PDL','MG'};
[~,tmp] = ismember(taskList,task);
for t = 1:N
    f = str2func(['run' task{tmp(t)}]);
    auxVars.curTask = task{tmp(t)};
    subjn = [repmat('0',1,8-length(genInfo.subjn)),genInfo.subjn]; % To be compatible with Octave
    genInfo.fileName = sprintf('%s_%s_%s_%s_%s',genInfo.ProjectID,subjn,genInfo.session,task{tmp(t)},genInfo.date);
    try
        [x,aborted] = f(genInfo,auxVars);
        if isempty(x)
            Payout{tmp(t)} = nan;
        else
            Payout{tmp(t)} = x;
        end
    catch ex
        crashed = 1;
        if genInfo.doSave
            save(['data/' genInfo.fileName '_crashed.mat']);
        end
        txt = getReport(ex,'extended'); % Output error messages
        fid = fopen([genInfo.fileName '_' datestr(now,'HHMM') '_crashLog.txt'],'a+');
        fprintf(fid,'%s\n',txt);
        fclose(fid);
        break
    end
    if aborted; break; end
    
    if t < length(taskList)-1
        if     strcmp(genInfo.language,'DE')
            text = ['Sie haben den Test erfolgreich beendet. '...
                    'Bitte drücken Sie die rechte Pfeiltaste, wenn Sie '...
                    'bereit sind, mit dem nächsten Test zu beginnen.'];
        elseif strcmp(genInfo.language,'EN')
            text = ['You have finished the task. '...
                    'Please press NEXT when you are ready '...
                    'to start the next task.'];
        end
        DrawFormattedText(auxVars.wd,text,'center','center',auxVars.txtCol,txtW,[],[],linSpc);
        [~,aborted] = getRarrow(auxVars,0);
    end
    if aborted; break; end
end
if aborted
    abortExp(auxVars);
elseif ~crashed
    showAllPayments(auxVars,Payout,taskList,genInfo.doPay,genInfo.language);
end
closeExperiment;
